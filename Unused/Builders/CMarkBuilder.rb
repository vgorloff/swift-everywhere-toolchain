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

class CMarkBuilder < Builder

   def initialize()
      super(Lib.cmark, Arch.host)
   end

   def executeConfigure
      # See: $SWIFT_REPO/docs/WindowsBuild.md
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja"
      cmd << "-DCMAKE_INSTALL_PREFIX=/"
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DCMARK_TESTS=false"
      if isMacOS?
         cFlags = '-Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector'
         cmd << "-DCMAKE_C_FLAGS='#{cFlags}'"
         cmd << "-DCMAKE_CXX_FLAGS='#{cFlags}'"
         cmd << "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.9"
         cmd << "-DCMAKE_OSX_SYSROOT=#{macOSSDK}"
      end
      cmd << @sources
      execute cmd.join(" ")
   end

   def executeBuild
      execute "cd #{@builds} && ninja"
   end

   def executeInstall
      execute "DESTDIR=#{@installs} cmake --build #{@builds} --target install"
   end

end
