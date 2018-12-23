require_relative "../Common/Builder.rb"

# See:
# - Dispatch build script: https://github.com/readdle/swift-android-toolchain/blob/master/build/Linux/040_build_corelibs_libdispatch.sh
# - Cmake. Cross Compiling for Android: https://cmake.org/cmake/help/v3.7/manual/cmake-toolchains.7.html#id20
class DispatchBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.dispatch, arch)
   end

   def prepare
      execute "mkdir -p #{@builds}"
   end

   def args
      swift = SwiftBuilder.new(@arch)
      cmd = []
      cmd << "CLANG=\"#{swift.builds}/llvm-linux-x86_64/bin/clang\""
      cmd << "CC=\"#{swift.builds}/llvm-linux-x86_64/bin/clang\""
      cmd << "CXX=\"#{swift.builds}/llvm-linux-x86_64/bin/clang++\""
      cmd << "SWIFT=\"#{swift.builds}/swift-linux-x86_64/bin/swift\""
      cmd << "SWIFTC=\"#{swift.builds}/swift-linux-x86_64/bin/swiftc\""
      return cmd
   end

   def options
      swift = SwiftBuilder.new(@arch)
      ndk = AndroidBuilder.new(@arch)
      # See: /swift/swift-corelibs-libdispatch/INSTALL.md
      cmd = []
      # Seems this cause binary to be x86_64 instead of arm.
      # cmd << "-DCMAKE_C_COMPILER=#{swift.builds}/llvm-linux-x86_64/bin/clang"
      # cmd << "-DCMAKE_CXX_COMPILER=#{swift.builds}/llvm-linux-x86_64/bin/clang++"

      cmd << "-DCMAKE_ANDROID_ARCH_ABI=armeabi-v7a"
      cmd << "-DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang"
      cmd << "-DCMAKE_ANDROID_STL_TYPE=\"c++_static\""
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DENABLE_SWIFT=true"
      cmd << "-DENABLE_TESTING=false"
      cmd << "-DCMAKE_SWIFT_COMPILER=\"#{swift.builds}/swift-linux-x86_64/bin/swiftc\""
      cmd << "-DCMAKE_PREFIX_PATH=\"#{swift.builds}/swift-linux-x86_64/lib/cmake/swift\""
      cmd << "-DCMAKE_INSTALL_PREFIX=#{@installs}"
      cmd << "-DCMAKE_SYSTEM_NAME=Android"
      cmd << "-DCMAKE_SYSTEM_VERSION=#{ndk.api} -DCMAKE_ANDROID_NDK=#{ndk.sources}"

      return cmd
   end

   def configure
      prepare
      configurePatches(false)
      configurePatches
      cmd = []
      cmd << "cd #{@builds} &&"
      # cmd += args
      cmd << "cmake -G Ninja"
      cmd += options
      cmd << @sources
      execute cmd.join(" ")
      # configurePatches(false)
      fixNinjaBuild
      logConfigureCompleted
   end

   def fixNinjaBuild
      ndk = AndroidBuilder.new(@arch)
      file = "#{@builds}/build.ninja"
      message "Applying fix for #{file}"
      contents = File.readlines(file).join()
      if !contents.include?('-tools-directory')
         contents = contents.gsub('-use-ld=gold', "-use-ld=gold -tools-directory #{ndk.installs}/bin")
         contents = contents.gsub('-module-link-name swiftDispatch', "-module-link-name swiftDispatch -Xcc -I#{ndk.installs}/sysroot/usr/include")
      end
      File.write(file, contents)
   end

   def configurePatches(shouldEnable = true)
      originalFile = "#{@sources}/cmake/modules/SwiftSupport.cmake"
      patchFile = "#{@patches}/CmakeSystemProcessor.patch"
      configurePatch(originalFile, patchFile, shouldEnable)

      originalFile = "#{@sources}/cmake/modules/DispatchCompilerWarnings.cmake"
      patchFile = "#{@patches}/DisableWarningsAsErrors.patch"
      configurePatch(originalFile, patchFile, shouldEnable)
   end

   def build
      # ndk = AndroidBuilder.new(@arch)
      # sysroot = ndk.installs + "/sysroot"

      # setupLinkerSymLink()
      cmd = ["cd #{@builds} &&"]
      # cmd << "SWIFTCFLAGS='-tools-directory #{ndk.bin}'"
      # cmd << "CFLAGS='-isystem #{sysroot}/usr/include'"
      # cmd << "LDFLAGS=\"--sysroot=#{sysroot} -L#{ndk.sources}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.9.x -L#{sysroot}/usr/lib\""
      cmd << "ninja"
      execute cmd.join(" ")
      # configurePatches(false)
      # setupLinkerSymLink(false)
      return

      prepare
      configurePatches(false)
      configurePatches
      ndk = AndroidBuilder.new(@arch)
      # FIXME: Seems we need to simlink GOLD Linker like in Swift. See CMakeLists.txt file
      # See: What is CMake equivalent of 'configure --prefix=DIR && make all install: https://stackoverflow.com/a/35753015/1418981
      cmd = ["cd #{@builds} &&"]
      cmd << "PATH=#{ndk.installs}/bin:$PATH"
      cmd << "cmake"
      cmd += options
      cmd << " . && "
      # cmd += args
      cmd << "ninja install"
      execute cmd.join(" ")
      configurePatches(false)
      logBuildCompleted
   end

   def install
      execute "cd #{@builds} && ninja install"
   end

   def make
      configure
      build
   end

   def clean
      execute "rm -rf \"#{@builds}\""
      execute "rm -rf \"#{@installs}\""
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/apple/swift-corelibs-libdispatch.git", "afa6cc3d1c42935c5a1016ec7ae13ddcbb1853d4")
   end

end
