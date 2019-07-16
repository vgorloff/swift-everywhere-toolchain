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
# - Dispatch build script: https://github.com/readdle/swift-android-toolchain/blob/master/build/Linux/040_build_corelibs_libdispatch.sh
# - Cmake. Cross Compiling for Android: https://cmake.org/cmake/help/v3.7/manual/cmake-toolchains.7.html#id20
class DispatchBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.dispatch, arch)
      @isUsedNDKToolchain = true # Make sure that you also changed the patch `Patches/swift-corelibs-libdispatch/src/CMakeLists.txt.diff`
      @ndk = NDK.new()
      @swift = SwiftBuilder.new()
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
      # See: /swift/swift-corelibs-libdispatch/INSTALL.md

      if @arch == Arch.armv7a
         abi = "armeabi-v7a"
      elsif @arch == Arch.x86
         abi = "x86"
      elsif @arch == Arch.aarch64
         abi = "arm64-v8a"
      elsif @arch == Arch.x64
         abi = "x86_64"
      end

      cFlags = "-fuse-ld=gold -Wno-unused-command-line-argument -B #{@ndk.toolchain}/#{@ndkArchPath}/bin -Wl,-L,#{@ndk.toolchain}/lib/gcc/#{@ndkArchPath}/4.9.x,-L,#{@ndk.toolchain}/sysroot/usr/lib/#{@ndkArchPath},-L,#{@ndk.toolchain}/sysroot/usr/lib/#{@ndkArchPath}/#{@ndk.api}"
      if @arch == Arch.aarch64 || @arch == Arch.x64
         cFlags += " -Wl,-L,#{@ndk.toolchain}/#{@ndkArchPath}/lib64"
      else
         cFlags += " -Wl,-L,#{@ndk.toolchain}/#{@ndkArchPath}/lib"
      end

      ndkSettings = <<EOM
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
EOM

      if @isUsedNDKToolchain
         # See why we need to use cmake toolchain in NDK v19 - https://gitlab.kitware.com/cmake/cmake/issues/18739
         ndkSettings = <<EOM
         -DCMAKE_TOOLCHAIN_FILE=#{@ndk.sources}/build/cmake/android.toolchain.cmake
         -DANDROID_STL=c++_static
         -DANDROID_TOOLCHAIN=clang
         -DANDROID_PLATFORM=android-#{@ndk.api}
         -DANDROID_ABI=#{abi}
EOM
      end

      cmd = <<EOM
      cd #{@builds} &&
      cmake -G Ninja
      # --debug-output

      #{ndkSettings}

      -DSWIFT_ANDROID_NDK_PATH=#{@ndk.sources}
      -DSWIFT_ANDROID_NDK_GCC_VERSION=#{@ndk.gcc}
      -DSWIFT_ANDROID_API_LEVEL=#{@ndk.api}

      -DCMAKE_BUILD_TYPE=Release
      -DENABLE_SWIFT=true
      -DENABLE_TESTING=false

      -DCMAKE_SWIFT_COMPILER=\"#{@swift.builds}/bin/swiftc\"
      -DCMAKE_PREFIX_PATH=\"#{@swift.builds}/lib/cmake/swift\"
      -DCMAKE_INSTALL_PREFIX=/

      #{@sources}
EOM
      executeCommands cmd
   end

   def configurePatches(shouldEnable = true)
      configurePatchFile("#{@patches}/CMakeLists.txt.diff", shouldEnable)
      configurePatchFile("#{@patches}/src/CMakeLists.txt.diff", shouldEnable)
   end

   def executeBuild
      if @isUsedNDKToolchain
         execute "ln -vfs #{@ndk.toolchain}/sysroot/usr/lib/#{@ndkArchPath}/#{@ndk.api}/crtbegin_so.o #{@builds}/src"
         execute "ln -vfs #{@ndk.toolchain}/sysroot/usr/lib/#{@ndkArchPath}/#{@ndk.api}/crtend_so.o #{@builds}/src"
      end
      execute "cd #{@builds} && ninja"
   end

   def executeInstall
      execute "DESTDIR=#{@installs} cmake --build #{@builds} --target install"
      Dir["#{@installs}/lib/swift/android/*.so"].each { |file|
         FileUtils.mv(file, "#{File.dirname(file)}/#{@archPath}", force: true)
      }
   end

end
