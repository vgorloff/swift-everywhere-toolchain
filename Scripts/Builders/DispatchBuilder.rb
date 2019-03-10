require_relative "../Common/Builder.rb"

# See:
# - Dispatch build script: https://github.com/readdle/swift-android-toolchain/blob/master/build/Linux/040_build_corelibs_libdispatch.sh
# - Cmake. Cross Compiling for Android: https://cmake.org/cmake/help/v3.7/manual/cmake-toolchains.7.html#id20
class DispatchBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.dispatch, arch)
      @ndk = AndroidBuilder.new(@arch)
   end

   def executeConfigure
      swift = SwiftBuilder.new(@arch)
      # See: /swift/swift-corelibs-libdispatch/INSTALL.md
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja" # --debug-output
      if @arch == Arch.host
         cmd << "-DCMAKE_INSTALL_PREFIX=#{@installs}"
         cmd << "-DCMAKE_C_COMPILER=\"#{llvmToolchain}/bin/clang\""
      else
         cmd << "-DCMAKE_INSTALL_PREFIX=#{swift.installs}/usr" # Applying Dispatch over existing file structure.
         # See why we need to use cmake toolchain in NDK v19 - https://gitlab.kitware.com/cmake/cmake/issues/18739
         cmd << "-DCMAKE_TOOLCHAIN_FILE=#{@ndk.sources}/build/cmake/android.toolchain.cmake"
         cmd << "-DANDROID_STL=c++_static"
         cmd << "-DANDROID_TOOLCHAIN=clang"
         cmd << "-DANDROID_PLATFORM=android-#{@ndk.api}"
         cmd << "-DANDROID_ABI=armeabi-v7a"
      end
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DENABLE_SWIFT=true"
      cmd << "-DENABLE_TESTING=false"
      cmd << "-DCMAKE_SWIFT_COMPILER=\"#{swift.builds}/bin/swiftc\""
      cmd << "-DCMAKE_PREFIX_PATH=\"#{swift.builds}/lib/cmake/swift\""
      cmd << @sources
      execute cmd.join(" ")
      fixNinjaBuild()
   end

   def fixNinjaBuild
      if @arch == Arch.host
         return
      end
      file = "#{@builds}/build.ninja"
      message "Applying fix for #{file}"
      contents = File.readlines(file).join()
      if !contents.include?('-tools-directory')
         contents = contents.gsub('-use-ld=gold', "-use-ld=gold -tools-directory #{@ndk.toolchain}/bin")
         contents = contents.gsub('-module-link-name swiftDispatch', "-module-link-name swiftDispatch -Xcc -I#{@ndk.sources}/sysroot/usr/include -Xcc -I#{@ndk.sources}/sysroot/usr/include/arm-linux-androideabi")
      end
      File.write(file, contents)
   end

   def configurePatches(shouldEnable = true)
      if @arch == Arch.host && shouldEnable
         return
      end
      originalFile = "#{@sources}/cmake/modules/SwiftSupport.cmake"
      patchFile = "#{@patches}/CmakeSystemProcessor.patch"
      configurePatch(originalFile, patchFile, shouldEnable)

      originalFile = "#{@sources}/cmake/modules/DispatchCompilerWarnings.cmake"
      patchFile = "#{@patches}/DisableWarningsAsErrors.patch"
      configurePatch(originalFile, patchFile, shouldEnable)
   end

   def executeBuild
      execute "cd #{@builds} && ninja"
   end

   def executeInstall
      execute "cd #{@builds} && ninja install"
   end

end
