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
# - ICU Patches: https://github.com/amraboelela/swift/blob/android/docs/Android.md
# - Sample Android Project: https://github.com/amraboelela/AmrSwiftAndroid
# - Build ICU for Android: https://gist.github.com/DanielSerdyukov/188d47e29150622352f1
# - Compile swift file to .so library for armeabi-v7a is not recognized by Android: https://bugs.swift.org/browse/SR-5672
# - Cross-building ICU for Applications on Embedded Devices: http://thebugfreeblog.blogspot.com/2013/05/cross-building-icu-for-applications-on.html
# - Packaging ICU4C: http://userguide.icu-project.org/packaging
# - GitHub libiconv-libicu-android: https://github.com/SwiftAndroid/libiconv-libicu-android

class ICUBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.icu, arch)
      @sources = "#{Config.sources}/#{Lib.icu}/icu4c"
      @ndk = NDK.new()
   end

   def executeConfigure
      host = ICUHostBuilder.new()
      cmd = ["cd #{@builds} &&"]
      if @arch == Arch.armv7a
         cmd << "CFLAGS='-Os -march=armv7-a -mfloat-abi=softfp -mfpu=neon'"
         cmd << "CXXFLAGS='--std=c++11 -march=armv7-a -mfloat-abi=softfp -mfpu=neon'"
         cmd << "LDFLAGS='-march=armv7-a -Wl,--fix-cortex-a8'"
         cmd << "CC=#{@ndk.toolchain}/bin/armv7a-linux-androideabi#{@ndk.api}-clang"
         cmd << "CXX=#{@ndk.toolchain}/bin/armv7a-linux-androideabi#{@ndk.api}-clang++"
         cmd << "AR=#{@ndk.toolchain}/bin/arm-linux-androideabi-ar"
         cmd << "RINLIB=#{@ndk.toolchain}/bin/arm-linux-androideabi-ranlib"
         cmd << "#{@sources}/source/configure --prefix=#{@installs}"
         cmd << "--host=arm-linux-androideabi"
      elsif @arch == Arch.x86
         cmd << "CFLAGS='-Os -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32'"
         cmd << "CXXFLAGS='--std=c++11 -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32'"
         cmd << "CC=#{@ndk.toolchain}/bin/i686-linux-android#{@ndk.api}-clang"
         cmd << "CXX=#{@ndk.toolchain}/bin/i686-linux-android#{@ndk.api}-clang++"
         cmd << "AR=#{@ndk.toolchain}/bin/i686-linux-android-ar"
         cmd << "RINLIB=#{@ndk.toolchain}/bin/i686-linux-android-ranlib"
         cmd << "#{@sources}/source/configure --prefix=#{@installs}"
         cmd << "--host=i686-linux-android"
      elsif @arch == Arch.aarch64
         cmd << "CFLAGS='-Os'"
         cmd << "CXXFLAGS='--std=c++11'"
         cmd << "CC=#{@ndk.toolchain}/bin/aarch64-linux-android#{@ndk.api}-clang"
         cmd << "CXX=#{@ndk.toolchain}/bin/aarch64-linux-android#{@ndk.api}-clang++"
         cmd << "AR=#{@ndk.toolchain}/bin/aarch64-linux-android-ar"
         cmd << "RINLIB=#{@ndk.toolchain}/bin/aarch64-linux-android-ranlib"
         cmd << "#{@sources}/source/configure --prefix=#{@installs}"
         cmd << "--host=aarch64-linux-android"
      elsif @arch == Arch.x64
         cmd << "CFLAGS='-Os -march=x86-64'"
         cmd << "CXXFLAGS='--std=c++11'"
         cmd << "CC=#{@ndk.toolchain}/bin/x86_64-linux-android#{@ndk.api}-clang"
         cmd << "CXX=#{@ndk.toolchain}/bin/x86_64-linux-android#{@ndk.api}-clang++"
         cmd << "AR=#{@ndk.toolchain}/bin/x86_64-linux-android-ar"
         cmd << "RINLIB=#{@ndk.toolchain}/bin/x86_64-linux-android-ranlib"
         cmd << "#{@sources}/source/configure --prefix=#{@installs}"
         cmd << "--host=x86_64-linux-android"
      end
      cmd << "--with-library-suffix=swift"
      cmd << "--enable-static=no --enable-shared --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no --enable-layoutex=no"
      cmd << "--enable-tools=no --enable-tests=no --enable-samples=no --enable-dyload=no"
      cmd << "--with-cross-build=#{host.builds}"
      cmd << "--with-data-packaging=archive"
      execute cmd.join(" ")
   end

   def executeBuild
      cmd = "cd #{@builds} && make"
      @dryRun ? message(cmd) : execute(cmd)
   end

   def executeInstall
      cmd = "cd #{@builds} && make install"
      @dryRun ? message(cmd) : execute(cmd)
      Dir[lib + "/**.so*"].each { |f|
         if File.symlink?(f)
            File.delete(f)
         else
            File.rename(f, f.sub(/\.so.*/, '.so'))
         end
      }
   end

   def configurePatches(shouldEnable = true)
      configurePatchFile("#{@patches}/source/configure.diff", shouldEnable)
      configurePatchFile("#{@patches}/source/config/mh-linux.diff", shouldEnable)
   end

end
