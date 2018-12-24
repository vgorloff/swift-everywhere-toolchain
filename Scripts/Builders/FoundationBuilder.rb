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
   end

   def prepare
      execute "mkdir -p #{@builds}"
      # copyFiles
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
      cmd << "-DLIBDISPATCH_SOURCE_DIR=#{@dispatch.sources}"
      cmd << "-DLIBDISPATCH_BUILD_DIR=#{@dispatch.installs}"
      cmd << "-DCMAKE_SYSTEM_NAME=Android"
      execute cmd.join(" ")

      fixNinjaBuild()
      logConfigureCompleted
   end

   def configure
      prepare
      cmd = []
      cmd << "cd #{@builds} &&"
      # cmd << "PATH=#{@ndk.bin}:$PATH"
      # cmd += args
      cmd << "cmake -G Ninja"
      cmd << "-DFOUNDATION_PATH_TO_LIBDISPATCH_SOURCE=#{@dispatch.sources}"
      cmd << "-DFOUNDATION_PATH_TO_LIBDISPATCH_BUILD=#{@dispatch.builds}"
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DCMAKE_INSTALL_PREFIX=#{@installs}"
      cmd << "-DICU_INCLUDE_DIR=#{@icu.include}"
      cmd << "-DLIBXML2_INCLUDE_DIR=#{@xml.include}/libxml2"
      cmd << "-DLIBXML2_LIBRARY=#{@xml.lib}/libxml2.so"
      cmd << "-DCURL_INCLUDE_DIR=#{@curl.include}"
      cmd << "-DCURL_LIBRARY=#{@curl.lib}/libcurl.so"
      cmd << "-DICU_ROOT=#{@icu.installs}"
      cmd << "-DCMAKE_SWIFT_COMPILER=\"#{@swift.swift}/bin/swiftc\""
      cmd << "-DCMAKE_C_COMPILER=\"#{@swift.llvm}/bin/clang\""
      # cmd << "-DCMAKE_CXX_COMPILER=\"#{@swift.llvm}/bin/clang++\""
      cmd << @sources
      execute cmd.join(" ")
   end

   def fixNinjaBuild
      execute "cd #{@sources} && sed --in-place 's/-I\\/usr\\/include\\/x86_64-linux-gnu//' build.ninja"
      execute "cd #{@sources} && sed --in-place 's/-I\\/usr\\/include\\/libxml2//' build.ninja"
      execute "cd #{@sources} && sed --in-place 's/-I.\\///' build.ninja"
      execute "cd #{@sources} && sed --in-place 's/-licui18n/-licui18nswift/g' build.ninja"
      execute "cd #{@sources} && sed --in-place 's/-licuuc/-licuucswift/g' build.ninja"
      execute "cd #{@sources} && sed --in-place 's/-licudata/-licudataswift/g' build.ninja"
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

   def build
      cmd = ["cd #{@builds} &&"]
      # cmd += args
      # execute cmd.join(" ") + " ninja CopyHeaders"
      # fixModuleMap()
      execute cmd.join(" ") + " ninja"
      logBuildCompleted
   end

   def install
      logInstallCompleted
   end

   def make
      prepare
      configure
      build
      install
   end

   def clean
      execute "rm -rf \"#{@builds}\""
      execute "rm -rf \"#{@installs}\""
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/apple/swift-corelibs-foundation", "a7f12d0851780b2c196733b2710a8ff2ae56bdcd")
   end

end
