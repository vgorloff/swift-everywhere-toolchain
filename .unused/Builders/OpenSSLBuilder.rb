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

# See:
# - Compiling the latest OpenSSL for Android: https://stackoverflow.com/questions/11929773/compiling-the-latest-openssl-for-android

class OpenSSLBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.ssl, arch)
      @ndk = NDK.new()
   end

   def prepare
      # Not used at the moment
   end

   def options()
      cmd = ["cd #{@sources} &&"]
      cmd << "ANDROID_NDK=#{@ndk.sources}"
      cmd << "PATH=#{@ndk.toolchain}/bin:$PATH"
      return cmd
   end

   def executeConfigure
      clean()
      # Seems `-D__ANDROID_API__` not needed. See: #{@sources}/NOTES.ANDROID
      commonArgs = options.join(" ") + " ./Configure -D__ANDROID_API__=#{@ndk.api} --prefix=#{@installs}"
      if @arch == Arch.armv7a
         execute "#{commonArgs} android-arm"
      elsif @arch == Arch.x86
         execute "#{commonArgs} android-x86"
      elsif @arch == Arch.aarch64
         execute "#{commonArgs} android-arm64"
      elsif @arch == Arch.x64
         execute "#{commonArgs} android-x86_64"
      end
   end

   def executeBuild
      execute options.join(" ") + " make SHLIB_VERSION_NUMBER= SHLIB_EXT=.so"
   end

   def executeInstall
      execute options.join(" ") + " make SHLIB_VERSION_NUMBER= SHLIB_EXT=.so install_sw install_ssldirs"
   end

   def libs()
      files = Dir["#{@installs}/lib/*.so"]
      return files
   end

end
