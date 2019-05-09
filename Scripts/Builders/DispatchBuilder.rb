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
         @includePath = "arm-linux-androideabi"
      elsif @arch == Arch.x86
         @archPath = "i686"
         @includePath = "i686-linux-android"
      elsif @arch == Arch.aarch64
         @archPath = "aarch64"
         @includePath = "aarch64-linux-android"
      elsif @arch == Arch.x64
         @archPath = "x86_64"
         @includePath = "x86_64-linux-android"
      end
   end

   def executeConfigure
      # See: /swift/swift-corelibs-libdispatch/INSTALL.md
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja" # --debug-output
      cmd << "-DCMAKE_INSTALL_PREFIX=/"
      # See why we need to use cmake toolchain in NDK v19 - https://gitlab.kitware.com/cmake/cmake/issues/18739
      cmd << "-DCMAKE_TOOLCHAIN_FILE=#{@ndk.sources}/build/cmake/android.toolchain.cmake"
      cmd << "-DANDROID_STL=c++_static"
      cmd << "-DANDROID_TOOLCHAIN=clang"
      cmd << "-DANDROID_PLATFORM=android-#{@ndk.api}"
      if @arch == Arch.armv7a
         cmd << "-DANDROID_ABI=armeabi-v7a"
      elsif @arch == Arch.x86
         cmd << "-DANDROID_ABI=x86"
      elsif @arch == Arch.aarch64
         cmd << "-DANDROID_ABI=arm64-v8a"
      elsif @arch == Arch.x64
         cmd << "-DANDROID_ABI=x86_64"
      end
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DENABLE_SWIFT=true"
      cmd << "-DENABLE_TESTING=false"
      cmd << "-DCMAKE_SWIFT_COMPILER=\"#{@swift.builds}/bin/swiftc\""
      cmd << "-DCMAKE_PREFIX_PATH=\"#{@swift.builds}/lib/cmake/swift\""
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
      execute "cp -vf #{file} #{file}.orig"
      contents = File.readlines(file).join()
      if !contents.include?('-tools-directory')
         contents = contents.gsub('-use-ld=gold', "-use-ld=gold -L #{@swift.installs}/lib/swift/android/#{@archPath} -tools-directory #{@ndk.toolchain}/bin")
         contents = contents.gsub('-module-link-name swiftDispatch', "-module-link-name swiftDispatch -Xcc -I#{@ndk.sources}/sysroot/usr/include -Xcc -I#{@ndk.sources}/sysroot/usr/include/#{@includePath}")
      end
      File.write(file, contents)
   end

   def configurePatches(shouldEnable = true)
      if @arch == Arch.host && shouldEnable
         return
      end
      configurePatchFile("#{@patches}/cmake/modules/SwiftSupport.cmake.diff", shouldEnable)
      configurePatchFile("#{@patches}/cmake/modules/DispatchCompilerWarnings.cmake.diff", shouldEnable)
   end

   def executeBuild
      execute "cd #{@builds} && ninja"
   end

   def executeInstall
      execute "DESTDIR=#{@installs} cmake --build #{@builds} -- install"
      Dir["#{@installs}/lib/swift/android/*.so"].each { |file|
        FileUtils.mv(file, "#{File.dirname(file)}/#{@archPath}", :force => true)
      }
   end

end
