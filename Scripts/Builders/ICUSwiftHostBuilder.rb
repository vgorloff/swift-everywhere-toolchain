#
# The MIT License
#
# Copyright (c) 2019 Volodymyr Gorlov (https://github.com/vgorloff)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

require_relative "../Common/Builder.rb"

class ICUSwiftHostBuilder < Builder

   def initialize()
      super(Lib.icuSwift, Arch.host)
      @sources = "#{Config.sources}/#{Lib.icu}/icu4c"
   end

   def executeConfigure
      # See: ./Sources/swift/utils/build-script-impl
      hostSystem = isMacOS? ? "MacOSX" : "Linux"
      cmd = ["cd #{@builds} &&"]
      cmd << "CFLAGS='-Os'"
      cmd << "CXXFLAGS='--std=c++11 -fPIC'"
      cmd << "#{@sources}/source/runConfigureICU #{hostSystem} --prefix=#{@installs}"
      cmd << "--enable-renaming --with-library-suffix=swift"
      # cmd << "--enable-static"

      # Below option should not be set. Otherwize you will have ICU without embed data.
      # See:
      # - ICU Data - ICU User Guide: http://userguide.icu-project.org/icudata#TOC-Building-and-Linking-against-ICU-data
      # - https://forums.swift.org/t/partial-nightlies-for-android-sdk/25909/43?u=v.gorlov
      # cmd << --enable-tools=no"

      cmd << "--enable-shared --enable-strict --disable-icuio --disable-plugins --disable-dyload"
      cmd << "--disable-extras --disable-samples --enable-tests=no --disable-layoutex --with-data-packaging=library"
      execute cmd.join(" ")
   end

   def executeBuild
      cmd = "cd #{@builds} && make"
      @dryRun ? message(cmd) : execute(cmd)
   end

   def executeInstall
      cmd = "cd #{@builds} && make install"
      @dryRun ? message(cmd) : execute(cmd)
      prependContents = File.read("#{@builds}/uconfig.h.prepend")
      file = "#{@installs}/include/unicode/uconfig.h"
      contents = File.read(file)
      token = "#define __UCONFIG_H__"
      contents = contents.sub(token, "#{token}\n#{prependContents}")
      File.write(file, contents)
   end

end
