require_relative "../Common/Builder.rb"
require_relative "../Common/Config.rb"

# See:
# - Libdispatch issues with CMake: https://forums.swift.org/t/libdispatch-switched-to-cmake/6665/7
class FoundationBuilder < Builder

   def initialize(target = "armv7a")
      super()
      @target = target
      @sourcesDir = Config.swiftSourcesRoot + "/swift-corelibs-foundation"
      @buildDir = Config.buildRoot + "/foundation/" + @target
      @installDir = Config.installRoot + "/foundation/" + @target

      @ndkToolchainPath = "#{Config.ndkInstallRoot}/#{@target}"
      @ndkToolchainBinPath = "#{@ndkToolchainPath}/bin"
      @ndkToolchainSysPath = "#{@ndkToolchainPath}/sysroot"
   end

   def prepare
      execute "mkdir -p #{@buildDir}"
      execute "mkdir -p #{@installDir}"

      # Copy dispatch public and private headers to the directory foundation is expecting to get it
      targetDir = "#{@ndkToolchainSysPath}/usr/include/dispatch"
      execute "mkdir -p #{targetDir}"
      execute "cp -v #{Config.swiftSourcesRoot}/swift-corelibs-libdispatch/dispatch/*.h #{targetDir}"
      execute "cp -v #{Config.swiftSourcesRoot}/swift-corelibs-libdispatch/private/*.h #{targetDir}"

      # libFoundation script is not completely prepared to handle cross compilation yet.
      execute "ln -svf #{Config.swiftBuildRoot}/swift-linux-x86_64/lib/swift #{@ndkToolchainSysPath}/usr/lib/"
      execute "cp -vr #{Config.swiftBuildRoot}/swift-linux-x86_64/lib/swift/android/armv7/* #{Config.swiftBuildRoot}/swift-linux-x86_64/lib/swift/android/"

      # Search path for curl seems to be wrong in foundation
      execute "cp -rv #{Config.curlInstallRoot}/#{@target}/include/curl #{@ndkToolchainSysPath}/usr/include"
      execute "ln -fvs #{@ndkToolchainSysPath}/usr/include/curl #{@ndkToolchainSysPath}/usr/include/curl/curl"

      execute "cp -rv #{Config.xmlInstallRoot}/#{@target}/include/libxml2 #{@ndkToolchainSysPath}/usr/include"
      execute "ln -fvs #{@ndkToolchainSysPath}/usr/include/libxml2/libxml #{@ndkToolchainSysPath}/usr/include/libxml"

      execute "cp -vr /usr/include/uuid #{@ndkToolchainSysPath}/usr/include"
   end

   def args
      # Arguments took from `swift/swift-corelibs-foundation/build-android`
      swiftCCRoot = "#{Config.swiftBuildRoot}/swift-linux-x86_64"
      llvmCCRoot = "#{Config.swiftBuildRoot}/llvm-linux-x86_64"
      icuRootPath = "#{Config.icuInstallRoot}/#{@target}"
      cmd = []
      cmd << "cd #{@sourcesDir} && env"
      cmd << "BUILD_DIR=#{@buildDir}"
      cmd << "DSTROOT=#{@installDir}"

      cmd << "SWIFTC=\"#{swiftCCRoot}/bin/swiftc\""
      cmd << "CLANG=\"#{llvmCCRoot}/bin/clang\""
      # cmd << "CLANGXX=\"#{llvmCCRoot}/bin/clang++\""
      cmd << "SWIFT=\"#{swiftCCRoot}/bin/swift\""
      cmd << "SDKROOT=\"#{swiftCCRoot}\""
      cmd << "CFLAGS=\"-DDEPLOYMENT_TARGET_ANDROID -DDEPLOYMENT_ENABLE_LIBDISPATCH --sysroot=#{@ndkToolchainSysPath} -I#{icuRootPath}/include -I#{swiftCCRoot}/lib/swift -I#{Config.ndkSourcesRoot}/sources/android/support/include -I#{@ndkToolchainSysPath}/usr/include -I#{@sourcesDir}/closure\""
      cmd << "SWIFTCFLAGS=\"-DDEPLOYMENT_TARGET_ANDROID -DDEPLOYMENT_ENABLE_LIBDISPATCH -Xcc -DDEPLOYMENT_TARGET_ANDROID -I#{@ndkToolchainSysPath}/usr/include\""
      cmd << "LDFLAGS=\"-fuse-ld=gold --sysroot=#{@ndkToolchainSysPath} -L#{Config.ndkSourcesRoot}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.9.x -L#{icuRootPath}/lib -L#{@ndkToolchainSysPath}/usr/lib -ldispatch\""
      return cmd
   end

   def configure
      cmd = args
      cmd << "./configure Release --target=armv7-none-linux-androideabi --sysroot=#{@ndkToolchainSysPath}"
      # cmd << "-DXCTEST_BUILD_DIR=#{swiftCCRoot}/xctest-linux-x86_64"
      cmd << "-DLIBDISPATCH_SOURCE_DIR=#{Config.swiftSourcesRoot}/swift-corelibs-libdispatch"
      cmd << "-DLIBDISPATCH_BUILD_DIR=#{Config.dispatchInstallRoot}/#{@target}"
      execute cmd.join(" ")

      execute "cd #{@sourcesDir} && sed --in-place 's/-I\\/usr\\/include\\/x86_64-linux-gnu//' build.ninja"
      execute "cd #{@sourcesDir} && sed --in-place 's/-I\\/usr\\/include\\/libxml2//' build.ninja"
      execute "cd #{@sourcesDir} && sed --in-place 's/-I.\\///' build.ninja"
      execute "cd #{@sourcesDir} && sed --in-place 's/-licui18n/-licui18nswift/g' build.ninja"
      execute "cd #{@sourcesDir} && sed --in-place 's/-licuuc/-licuucswift/g' build.ninja"
      execute "cd #{@sourcesDir} && sed --in-place 's/-licudata/-licudataswift/g' build.ninja"
   end

   def build
      execute args.join(" ") + " ninja CopyHeaders"

      # Patching module.modulemap file.
      message "Patching module.modulemap file."
      headersPath = "#{@buildDir}/Foundation/usr/lib/swift/CoreFoundation"
      moduleMapPath = headersPath + "/module.modulemap"
      contents = File.readlines(moduleMapPath).join()
      contents = contents.sub('"CoreFoundation.h"', '"' + headersPath + '/CoreFoundation.h"')
      contents = contents.sub('"CFPlugInCOM.h"', '"' + headersPath + '/CFPlugInCOM.h"')
      File.write(moduleMapPath, contents)

      # Running build.
      execute args.join(" ") + " ninja"
   end

   def make
      prepare
      configure
      build
   end

   def clean
      execute "rm -rf \"#{@buildDir}\""
      execute "rm -rf \"#{@installDir}\""
   end

end
