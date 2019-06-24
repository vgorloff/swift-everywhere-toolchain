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
         @ndkArchPath = "arm-linux-androideabi"
      elsif @arch == Arch.x86
         @archPath = "i686"
         @ndkArchPath = "i686-linux-android"
      elsif @arch == Arch.aarch64
         @archPath = "aarch64"
         @ndkArchPath = "aarch64-linux-android"
      elsif @arch == Arch.x64
         @archPath = "x86_64"
         @ndkArchPath = "x86_64-linux-android"
      end
   end

   def executeConfigure
      if @arch == Arch.armv7a
         abi = "armeabi-v7a"
      elsif @arch == Arch.x86
         abi = "x86"
      elsif @arch == Arch.aarch64
         abi = "arm64-v8a"
      elsif @arch == Arch.x64
         abi = "x86_64"
      end

      cFlags = "-D__ANDROID__ -fuse-ld=gold -Wno-unused-command-line-argument -B #{@ndk.toolchain}/#{@ndkArchPath}/bin -Wl,-L,#{@ndk.toolchain}/lib/gcc/#{@ndkArchPath}/4.9.x,-L,#{@ndk.toolchain}/sysroot/usr/lib/#{@ndkArchPath},-L,#{@ndk.toolchain}/sysroot/usr/lib/#{@ndkArchPath}/#{@ndk.api}"
      if @arch == Arch.aarch64 || @arch == Arch.x64
         cFlags += " -Wl,-L,#{@ndk.toolchain}/#{@ndkArchPath}/lib64"
      else
         cFlags += " -Wl,-L,#{@ndk.toolchain}/#{@ndkArchPath}/lib"
      end

      cmd = <<EOM
      cd #{@builds} &&
      cmake -G Ninja

      -DFOUNDATION_PATH_TO_LIBDISPATCH_SOURCE=#{@dispatch.sources}

      # Check later if we can use `@installs`
      -DFOUNDATION_PATH_TO_LIBDISPATCH_BUILD=#{@dispatch.builds}

      # Settings without Android cmake toolchain
      -DCMAKE_SYSTEM_NAME=Android
      -DCMAKE_ANDROID_NDK=#{@ndk.sources}
      -DCMAKE_ANDROID_API=#{@ndk.api}
      -DCMAKE_ANDROID_ARCH_ABI=#{abi}
      -DCMAKE_C_FLAGS="#{cFlags}"
      -DCMAKE_CXX_FLAGS="#{cFlags}"
      -DCMAKE_AR=#{@ndk.toolchain}/#{@ndkArchPath}/bin/ar
      -DCMAKE_LINKER=#{@ndk.toolchain}/#{@ndkArchPath}/bin/ld.gold
      -DCMAKE_RANLIB=#{@ndk.toolchain}/#{@ndkArchPath}/bin/ranlib
      -DCMAKE_STRIP=#{@ndk.toolchain}/#{@ndkArchPath}/bin/strip
      -DCMAKE_NM=#{@ndk.toolchain}/#{@ndkArchPath}/bin/nm
      -DCMAKE_OBJCOPY=#{@ndk.toolchain}/#{@ndkArchPath}/bin/objcopy
      -DCMAKE_OBJDUMP=#{@ndk.toolchain}/#{@ndkArchPath}/bin/objdump

      -DSWIFT_ANDROID_NDK_PATH=#{@ndk.sources}
      -DSWIFT_ANDROID_NDK_GCC_VERSION=#{@ndk.gcc}
      -DSWIFT_ANDROID_API_LEVEL=#{@ndk.api}

      -DICU_INCLUDE_DIR=#{@icu.include}
      -DICU_LIBRARY=#{@icu.lib}
      -DICU_I18N_LIBRARY_RELEASE=#{@icu.lib}/libicui18nswift.so
      -DICU_UC_LIBRARY_RELEASE=#{@icu.lib}/libicuucswift.so

      -DLIBXML2_INCLUDE_DIR=#{@xml.include}/libxml2
      -DLIBXML2_LIBRARY=#{@xml.lib}/libxml2.so

      -DCURL_INCLUDE_DIR=#{@curl.include}
      -DCURL_LIBRARY=#{@curl.lib}/libcurl.so

      -DCMAKE_INSTALL_PREFIX=/
      -DCMAKE_SWIFT_COMPILER=\"#{@swift.builds}/bin/swiftc\"
      -DCMAKE_BUILD_TYPE=Release

      #{@sources}
EOM
      executeCommands cmd
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
