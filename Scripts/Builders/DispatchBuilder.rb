require_relative "../Common/Builder.rb"
require_relative "../Common/Config.rb"

# See:
# - Dispatch build script: https://github.com/readdle/swift-android-toolchain/blob/master/build/Linux/040_build_corelibs_libdispatch.sh
# - Cmake. Cross Compiling for Android: https://cmake.org/cmake/help/v3.7/manual/cmake-toolchains.7.html#id20
class DispatchBuilder < Builder

   def initialize(target = "armv7a")
      super()
      @target = target
      @sourcesDir = Config.swiftSourcesRoot + "/swift-corelibs-libdispatch"
      @buildDir = Config.buildRoot + "/dispatch/" + @target
      @installDir = Config.installRoot + "/dispatch/" + @target
   end

   def prepare
      execute "mkdir -p #{@buildDir}"
      execute "mkdir -p #{@installDir}"
   end

   def configure
      # See: /swift/swift-corelibs-libdispatch/INSTALL.md
      swiftCCRoot = "#{Config.swiftBuildRoot}/swift-linux-x86_64"
      llvmCCRoot = "#{Config.swiftBuildRoot}/llvm-linux-x86_64"
      cmd = []
      cmd << "cd #{@buildDir} &&"
      cmd << "CLANG=\"#{llvmCCRoot}/bin/clang\""
      cmd << "CC=\"#{llvmCCRoot}/bin/clang\""
      cmd << "CXX=\"#{llvmCCRoot}/bin/clang++\""
      cmd << "SWIFT=\"#{swiftCCRoot}/bin/swift\""
      cmd << "SWIFTC=\"#{swiftCCRoot}/bin/swiftc\""
      cmd << "cmake -G Ninja"
      cmd << "-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"
      cmd << "-DCMAKE_ANDROID_ARCH_ABI=armeabi-v7a"
      cmd << "-DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang"
      cmd << "-DCMAKE_ANDROID_STL_TYPE=\"c++_static\" -DCMAKE_BUILD_TYPE=Release"
      cmd << "-DCMAKE_SYSTEM_NAME=Android -DCMAKE_SYSTEM_VERSION=#{Config.androidAPI} -DCMAKE_ANDROID_NDK=#{Config.ndkSourcesRoot}"
      cmd << @sourcesDir
      execute cmd.join(" ")
   end

   def build
      execute "cd #{@buildDir} && ninja"
   end

   def make
      prepare
      configure
      build
   end

end
