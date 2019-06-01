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
      @ndk = NDK.new()
      @swift = SwiftBuilder.new()
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

      cmd = <<EOM
      cd #{@builds} &&
      cmake -G Ninja
      # --debug-output

      # See why we need to use cmake toolchain in NDK v19 - https://gitlab.kitware.com/cmake/cmake/issues/18739
      -DCMAKE_TOOLCHAIN_FILE=#{@ndk.sources}/build/cmake/android.toolchain.cmake

      -DANDROID_STL=c++_static
      -DANDROID_TOOLCHAIN=clang

      -DANDROID_PLATFORM=android-#{@ndk.api}
      -DANDROID_ABI=#{abi}

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
      configurePatchFile("#{@patches}/cmake/modules/SwiftSupport.cmake.diff", shouldEnable)
   end

   def executeBuild
      execute "cd #{@builds} && ninja"
   end

   def executeInstall
      execute "DESTDIR=#{@installs} cmake --build #{@builds} --target install"
      Dir["#{@installs}/lib/swift/android/*.so"].each { |file|
         FileUtils.mv(file, "#{File.dirname(file)}/#{@archPath}", :force => true)
      }
   end

end
