require_relative "../Common/Builder.rb"

# See:
# - Libdispatch issues with CMake: https://forums.swift.org/t/libdispatch-switched-to-cmake/6665/7
class FoundationBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.foundation, arch)
      @ndk = AndroidBuilder.new(arch)
      @dispatch = DispatchBuilder.new(arch)
      @swift = SwiftBuilder.new(arch)
      @curl = CurlBuilder.new(arch)
      @icu = ICUBuilder.new(arch)
      @xml = XMLBuilder.new(arch)
      @includes = "#{@builds}/external-includes"
   end

   def prepare
      execute "mkdir -p #{@builds}"
   end

   def copyFiles
      usr = @ndk.installs + "/sysroot/usr"
      # Copy dispatch public and private headers to the directory foundation is expecting to get it
      targetDir = "#{usr}/include/dispatch"
      execute "mkdir -p #{targetDir}"
      execute "cp -v #{@dispatch.sources}/dispatch/*.h #{targetDir}"
      execute "cp -v #{@dispatch.sources}/private/*.h #{targetDir}"

      # libFoundation script is not completely prepared to handle cross compilation yet.
      execute "ln -svf #{@swift.lib}/swift #{usr}/lib/"
      execute "cp -vr #{@swift.lib}/swift/android/armv7/* #{@swift.lib}/swift/android/"

      # Search path for curl seems to be wrong in foundation
      execute "cp -rv #{@curl.include}/curl #{usr}/include"
      execute "ln -fvs #{usr}/include/curl #{usr}/include/curl/curl"

      execute "cp -rv #{@xml.include}/libxml2 #{usr}/include"
      execute "ln -fvs #{usr}/include/libxml2/libxml #{usr}/include/libxml"

      execute "cp -vr /usr/include/uuid #{usr}/include"
   end

   def setupSymLinks
      if @arch == Arch.host
         return
      end
      execute "mkdir -p #{@includes}"
      execute "ln -fvs /usr/include/uuid #{@includes}"
   end

   def args
      # Arguments took from `swift/swift-corelibs-foundation/build-android`
      sysroot = @ndk.installs + "/sysroot"
      cmd = []
      cmd << "BUILD_DIR=#{@builds}"
      cmd << "DSTROOT=#{@installs}"

      cmd << "SWIFTC=\"#{@swift.swift}/bin/swiftc\""
      cmd << "CLANG=\"#{@swift.llvm}/bin/clang\""
      # cmd << "CLANGXX=\"#{@llvm.bin}/clang++\""
      cmd << "SWIFT=\"#{@swift.swift}/bin/swift\""
      # cmd << "SDKROOT=\"#{@swift.installs}\""
      cmd << "CFLAGS=\"-DDEPLOYMENT_TARGET_ANDROID -DDEPLOYMENT_ENABLE_LIBDISPATCH --sysroot=#{sysroot} -I#{@icu.include} -I#{@swift.lib}/swift -I#{@ndk.sources}/sources/android/support/include -I#{sysroot}/usr/include -I#{@sources}/closure\""
      cmd << "SWIFTCFLAGS=\"-DDEPLOYMENT_TARGET_ANDROID -DDEPLOYMENT_ENABLE_LIBDISPATCH -Xcc -DDEPLOYMENT_TARGET_ANDROID -I#{sysroot}/usr/include\""
      cmd << "LDFLAGS=\"-fuse-ld=gold --sysroot=#{sysroot} -L#{@ndk.sources}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.9.x -L#{@icu.lib} -L#{sysroot}/usr/lib -ldispatch\""
      return cmd
   end

   def configure_
      sysroot = @ndk.installs + "/sysroot"
      cmd = ["cd #{@sources} &&"]
      cmd += args
      cmd << "./configure Release --target=armv7-none-linux-androideabi --sysroot=#{sysroot}"
      cmd << "-DCMAKE_SYSTEM_NAME=Android"
   end

   def configure
      prepare
      configurePatches(false)
      configurePatches
      cmd = []
      cmd << "cd #{@builds} &&"
      # Seems not needed.
      if @arch != Arch.host
         # cmd << "ICU_ROOT=#{@icu.installs}"
         # cmd << "PATH=#{@ndk.bin}:$PATH"
         # cmd << "CFLAGS='-DDEPLOYMENT_TARGET_ANDROID'"
      end
      cmd << "cmake -G Ninja"
      cmd << "-DFOUNDATION_PATH_TO_LIBDISPATCH_SOURCE=#{@dispatch.sources}"
      cmd << "-DFOUNDATION_PATH_TO_LIBDISPATCH_BUILD=#{@dispatch.builds}" # Check later if we can use `@installs`
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      if @arch == Arch.host
         cmd << "-DCMAKE_C_COMPILER=\"#{@swift.llvm}/bin/clang\""
      else
         cmd << "-DCMAKE_SYSROOT=#{@ndk.installs}/sysroot"
         # cmd << "-DCMAKE_C_COMPILER=\"#{@ndk.bin}/clang\""
         cmd << "-DCMAKE_SYSTEM_NAME=Android"
         cmd << "-DCMAKE_SYSTEM_VERSION=#{@ndk.api}"
         # cmd << "-DCMAKE_ANDROID_STANDALONE_TOOLCHAIN=#{@ndk.installs}"
         # cmd << "-DCMAKE_ANDROID_NDK=#{@ndk.sources}"
         cmd << "-DCMAKE_ANDROID_ARCH_ABI=armeabi-v7a"
         cmd << "-DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang"
         cmd << "-DCMAKE_ANDROID_STL_TYPE=\"c++_static\""

         cmd << "-DICU_INCLUDE_DIR=#{@icu.include}"
         cmd << "-DICU_LIBRARY=#{@icu.lib}"

         cmd << "-DLIBXML2_INCLUDE_DIR=#{@xml.include}/libxml2"
         cmd << "-DLIBXML2_LIBRARY=#{@xml.lib}/libxml2.so"

         cmd << "-DCURL_INCLUDE_DIR=#{@curl.include}"
         cmd << "-DCURL_LIBRARY=#{@curl.lib}/libcurl.so"
      end
      cmd << "-DCMAKE_INSTALL_PREFIX=#{@installs}"
      cmd << "-DCMAKE_SWIFT_COMPILER=\"#{@swift.swift}/bin/swiftc\""

      cmd << @sources
      execute cmd.join(" ")
      fixNinjaBuild()
      execute "cd #{@builds} && CFLAGS='-DDEPLOYMENT_TARGET_ANDROID -I#{@includes}' ninja CoreFoundation-prefix/src/CoreFoundation-stamp/CoreFoundation-configure"
      logConfigureCompleted
   end

   def fixNinjaBuild
      if @arch == Arch.host
         return
      end
      file = "#{@builds}/build.ninja"
      message "Applying fix for #{file}"
      contents = File.readlines(file).join()
      contents = contents.gsub('/usr/lib/x86_64-linux-gnu/libicu', "#{@icu.lib}/libicu")
      contents = contents.gsub('libicuuc.so', 'libicuucswift.so')
      contents = contents.gsub('libicui18n.so', 'libicui18nswift.so')
      # FIXME: Try to comment `find_package(UUID REQUIRED)` in CMakeLists.txt
      # contents = contents.gsub('/usr/lib/x86_64-linux-gnu/libuuid.so', '')
      File.write(file, contents)

      # execute "cd #{@sources} && sed --in-place 's/-I\\/usr\\/include\\/x86_64-linux-gnu//' build.ninja"
      # execute "cd #{@sources} && sed --in-place 's/-I\\/usr\\/include\\/libxml2//' build.ninja"
      # execute "cd #{@sources} && sed --in-place 's/-I.\\///' build.ninja"
      # execute "cd #{@sources} && sed --in-place 's/-licui18n/-licui18nswift/g' build.ninja"
      # execute "cd #{@sources} && sed --in-place 's/-licuuc/-licuucswift/g' build.ninja"
      # execute "cd #{@sources} && sed --in-place 's/-licudata/-licudataswift/g' build.ninja"
   end

   def fixModuleMap
      # Patching module.modulemap file.
      message "Patching module.modulemap file."
      headersPath = "#{@build}/Foundation/usr/lib/swift/CoreFoundation"
      moduleMapPath = headersPath + "/module.modulemap"
      contents = File.readlines(moduleMapPath).join()
      contents = contents.sub('"CoreFoundation.h"', '"' + headersPath + '/CoreFoundation.h"')
      contents = contents.sub('"CFPlugInCOM.h"', '"' + headersPath + '/CFPlugInCOM.h"')
      File.write(moduleMapPath, contents)
   end

   def configurePatches(shouldEnable = true)
      if @arch == Arch.host && shouldEnable
         return
      end
      originalFile = "#{@sources}/cmake/modules/SwiftSupport.cmake"
      patchFile = "#{@patches}/CmakeSystemProcessor.patch"
      configurePatch(originalFile, patchFile, shouldEnable)

      originalFile = "#{@sources}/CoreFoundation/CMakeLists.txt"
      patchFile = "#{@patches}/CompileOptions.patch"
      configurePatch(originalFile, patchFile, shouldEnable)

      originalFile = "#{@sources}/CMakeLists.txt"
      patchFile = "#{@patches}/CMakeLists.patch"
      configurePatch(originalFile, patchFile, shouldEnable)

      # FIXME: This may cause unexpected behaviour on Android because it is not yet implemented. Linux version will be used.
      originalFile = "#{@sources}/CoreFoundation/Base.subproj/CFKnownLocations.c"
      patchFile = "#{@patches}/CFKnownLocations.patch"
      configurePatch(originalFile, patchFile, shouldEnable)
   end

   def build
      prepare
      setupSymLinks
      # cmd += args
      # execute cmd.join(" ") + " ninja CopyHeaders"
      # fixModuleMap()

      # For troubleshooting purpose.
      # execute "cd #{@builds} && ninja CoreFoundation"

      execute "cd #{@builds} && ninja"
      logBuildCompleted
   end

   def install
      execute "cd #{@builds} && ninja install"
      logInstallCompleted
   end

   def make
      configure
      build
      # install
   end

   def clean
      execute "rm -rf \"#{@builds}\""
      execute "rm -rf \"#{@installs}\""
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/apple/swift-corelibs-foundation", "a7f12d0851780b2c196733b2710a8ff2ae56bdcd")
   end

end
