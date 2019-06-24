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
# - Libdispatch issues with CMake: https://forums.swift.org/t/libdispatch-switched-to-cmake/6665/7
class FoundationBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.foundation, arch)
      @ndk = NDK.new()
      @dispatch = DispatchBuilder.new(arch)
      @swift = SwiftBuilder.new()
      @llvm = LLVMBuilder.new()
      @curl = CurlBuilder.new(arch)
      @icu = ICUBuilder.new(arch)
      @xml = XMLBuilder.new(arch)
      if @arch == Arch.armv7a
         @archPath = "armv7"
      elsif @arch == Arch.x86
         @archPath = "i686"
      elsif @arch == Arch.aarch64
         @archPath = "aarch64"
      elsif @arch == Arch.x64
         @archPath = "x86_64"
      end
   end

   def executeConfigure
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja"
      cmd << "-DFOUNDATION_PATH_TO_LIBDISPATCH_SOURCE=#{@dispatch.sources}"
      cmd << "-DFOUNDATION_PATH_TO_LIBDISPATCH_BUILD=#{@dispatch.builds}" # Check later if we can use `@installs`
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      includePath = "#{@ndk.sources}/sysroot/usr/include"
      cFlags = "-D__ANDROID__"
      # See why we need to use cmake toolchain in NDK v19 - https://gitlab.kitware.com/cmake/cmake/issues/18739
      cmd << "-DCMAKE_TOOLCHAIN_FILE=#{@ndk.sources}/build/cmake/android.toolchain.cmake"
      cmd << "-DANDROID_STL=c++_static"
      cmd << "-DANDROID_TOOLCHAIN=clang"
      cmd << "-DANDROID_PLATFORM=android-#{@ndk.api}"
      if @arch == Arch.armv7a
         cmd << "-DANDROID_ABI=armeabi-v7a"
         ndkArchPath = "arm-linux-androideabi"
         ndkToolchainPath = ndkArchPath
      elsif @arch == Arch.x86
         cmd << "-DANDROID_ABI=x86"
         ndkArchPath = "i686-linux-android"
         ndkToolchainPath = "x86"
      elsif @arch == Arch.aarch64
         cmd << "-DANDROID_ABI=arm64-v8a"
         ndkArchPath = "aarch64-linux-android"
         ndkToolchainPath = ndkArchPath
      elsif @arch == Arch.x64
         cmd << "-DANDROID_ABI=x86_64"
         ndkArchPath = "x86_64-linux-android"
         ndkToolchainPath = "x86_64"
      end
      cmd << "-DCMAKE_SYSTEM_NAME=Android"
      cmd << "-DCMAKE_C_FLAGS=\"#{cFlags}\""
      cmd << "-DCMAKE_CXX_FLAGS=\"#{cFlags}\""

      cmd << "-DADDITIONAL_SWIFT_FLAGS='-I#{includePath}\;-I#{includePath}/#{ndkArchPath}'"
      # Foundation.so `__CFConstantStringClassReference=$s10Foundation19_NSCFConstantStringCN`. Double $$ used as escape.
      cmd << "-DADDITIONAL_SWIFT_LINK_FLAGS='-v\;-use-ld=gold\;-tools-directory\;#{@ndk.toolchain}/#{ndkArchPath}/bin\;-L\;#{@swift.installs}/lib/swift/android/#{@archPath}\;-L\;#{@ndk.toolchain}/sysroot/usr/lib/#{ndkArchPath}/#{@ndk.api}\;-L\;#{@ndk.sources}/toolchains/#{ndkToolchainPath}-4.9/prebuilt/darwin-x86_64/lib/gcc/#{ndkArchPath}/4.9.x\'"

      cmd << "-DICU_INCLUDE_DIR=#{@icu.include}"
      cmd << "-DICU_LIBRARY=#{@icu.lib}"
      cmd << "-DICU_I18N_LIBRARY_RELEASE=#{@icu.lib}/libicui18nswift.so"
      cmd << "-DICU_UC_LIBRARY_RELEASE=#{@icu.lib}/libicuucswift.so"

      cmd << "-DLIBXML2_INCLUDE_DIR=#{@xml.include}/libxml2"
      cmd << "-DLIBXML2_LIBRARY=#{@xml.lib}/libxml2.so"

      cmd << "-DCURL_INCLUDE_DIR=#{@curl.include}"
      cmd << "-DCURL_LIBRARY=#{@curl.lib}/libcurl.so"

      cmd << "-DCMAKE_INSTALL_PREFIX=/"
      cmd << "-DCMAKE_SWIFT_COMPILER=\"#{@swift.builds}/bin/swiftc\""

      cmd << @sources
      execute cmd.join(" \\\n")
   end

   def executeBuild
      if @arch == Arch.armv7a
         ndkArchPath = "arm-linux-androideabi"
      elsif @arch == Arch.x86
         ndkArchPath = "i686-linux-android"
      elsif @arch == Arch.aarch64
         ndkArchPath = "aarch64-linux-android"
      elsif @arch == Arch.x64
         ndkArchPath = "x86_64-linux-android"
      end
      execute "ln -vfs #{@ndk.toolchain}/sysroot/usr/lib/#{ndkArchPath}/#{@ndk.api}/crtbegin_so.o #{@builds}"
      execute "ln -vfs #{@ndk.toolchain}/sysroot/usr/lib/#{ndkArchPath}/#{@ndk.api}/crtend_so.o #{@builds}"
      # For troubleshooting purpose.
      # execute "cd #{@builds} && ninja CoreFoundation"
      execute "cd #{@builds} && ninja"
   end

   def executeInstall
      execute "DESTDIR=#{@installs} cmake --build #{@builds} --target install"
      Dir["#{@installs}/lib/swift/android/*.so"].each { |file|
        FileUtils.mv(file, "#{File.dirname(file)}/#{@archPath}", :force => true)
      }
   end

   def configurePatches(shouldEnable = true)
      configurePatchFile("#{@patches}/CMakeLists.txt.diff", shouldEnable)
      configurePatchFile("#{@patches}/CoreFoundation/CMakeLists.txt.diff", shouldEnable)
      configurePatchFile("#{@patches}/CoreFoundation/Base.subproj/SwiftRuntime/CoreFoundation.h.diff", shouldEnable)
   end

end
