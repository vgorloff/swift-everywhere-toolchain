require_relative "../Common/Builder.rb"
require_relative "../Common/Config.rb"

# See:
# - Dispatch build script: https://github.com/readdle/swift-android-toolchain/blob/master/build/Linux/040_build_corelibs_libdispatch.sh
# - Cmake. Cross Compiling for Android: https://cmake.org/cmake/help/v3.7/manual/cmake-toolchains.7.html#id20
class DispatchBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.dispatch, arch)
   end

   def prepare
      execute "mkdir -p #{@build}"
   end

   def args
      @llvm = LLVMBuilder.new(arch)
      @swift = SwiftBuilder.new(arch)
      cmd = []
      cmd << "CLANG=\"#{@llvm.bin}/clang\""
      cmd << "CC=\"#{@llvm.bin}/clang\""
      cmd << "CXX=\"#{@llvm.bin}/clang++\""
      cmd << "SWIFT=\"#{@swift.bin}/swift\""
      cmd << "SWIFTC=\"#{@swift.bin}/swiftc\""
      return cmd
   end

   def options
      @llvm = LLVMBuilder.new(arch)
      @swift = SwiftBuilder.new(arch)
      @ndk = AndroidBuilder.new(arch)
      # See: /swift/swift-corelibs-libdispatch/INSTALL.md
      cmd = []
      cmd << "-DCMAKE_C_COMPILER=#{@llvm.bin}/clang -DCMAKE_CXX_COMPILER=#{@llvm.bin}/clang++"
      cmd << "-DCMAKE_ANDROID_ARCH_ABI=armeabi-v7a"
      cmd << "-DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang"
      cmd << "-DCMAKE_ANDROID_STL_TYPE=\"c++_static\""
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DENABLE_SWIFT=true"
      cmd << "-DCMAKE_SWIFT_COMPILER=\"#{@swift.bin}/swiftc\""
      cmd << "-DCMAKE_PREFIX_PATH=\"#{@swift.lib}/cmake/swift\""
      cmd << "-DCMAKE_INSTALL_PREFIX=#{@install}"
      cmd << "-DCMAKE_SYSTEM_NAME=Android -DCMAKE_SYSTEM_VERSION=#{@ndk.api} -DCMAKE_ANDROID_NDK=#{@ndk.sources}"
      return cmd
   end

   def configure
      cmd = []
      cmd << "cd #{@build} &&"
      cmd += args
      cmd << "cmake -G Ninja"
      cmd += options
      cmd << @sources
      execute cmd.join(" ")
   end

   def compile
      # See: What is CMake equivalent of 'configure --prefix=DIR && make all install: https://stackoverflow.com/a/35753015/1418981
      execute "cd #{@build} && cmake " + options.join(" ") + " . && " + args.join(" ") + " ninja install"
   end

   def make
      prepare
      configure
      compile
   end

   def clean
      execute "rm -rf \"#{@build}\""
      execute "rm -rf \"#{@install}\""
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/apple/swift-corelibs-libdispatch.git")
   end

end
