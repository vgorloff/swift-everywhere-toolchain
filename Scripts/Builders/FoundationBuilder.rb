require_relative "../Common/Builder.rb"
require_relative "../Common/Config.rb"

class FoundationBuilder < Builder

   def initialize(target = "armv7a")
      super()
      @target = target
      @sourcesDir = Config.swiftSourcesRoot
      @buildDir = Config.buildRoot + "/foundation/" + @target
      @installDir = Config.installRoot + "/foundation/" + @target
   end

   def prepare
      execute "mkdir -p #{@buildDir}"
      execute "mkdir -p #{@installDir}"
   end

   def configure
      # Arguments took from `swift/swift-corelibs-foundation/build-android`
      ndkToolchainPath = "#{Config.ndkInstallRoot}/#{@target}"
      ndkToolchainBinPath = "#{ndkToolchainPath}/bin"
      ndkToolchainSysPath = "#{ndkToolchainPath}/sysroot"
      swiftBuildPath = Config.swiftBuildRoot
      swiftSDKRoot = "#{swiftBuildPath}/swift-linux-x86_64"
      icuRootPath = "#{Config.icuInstallRoot}/#{@target}"
      cmd = []
      cmd << "cd #{@sourcesDir}/swift-corelibs-foundation &&"
      cmd << "BUILD_DIR=#{@buildDir}"
      cmd << "DSTROOT=#{@installDir}"

      cmd << "SWIFTC=\"#{swiftSDKRoot}/bin/swiftc\""
      cmd << "CLANG=\"#{swiftBuildPath}/llvm-linux-x86_64/bin/clang\""
      cmd << "SWIFT=\"#{swiftSDKRoot}/bin/swift\""
      cmd << "SDKROOT=\"#{swiftSDKRoot}\""
      cmd << "CFLAGS=\"-DDEPLOYMENT_TARGET_ANDROID -DDEPLOYMENT_ENABLE_LIBDISPATCH --sysroot=#{ndkToolchainSysPath} -I#{icuRootPath}/include -I#{swiftSDKRoot}/lib/swift -I#{Config.ndkSourcesRoot}/sources/android/support/include -I#{ndkToolchainSysPath}/usr/include -I#{@sourcesDir}/swift-corelibs-foundation/closure\""
      cmd << "SWIFTCFLAGS=\"-DDEPLOYMENT_TARGET_ANDROID -DDEPLOYMENT_ENABLE_LIBDISPATCH -I#{ndkToolchainSysPath}/usr/include\""
      cmd << "LDFLAGS=\"-fuse-ld=gold --sysroot=#{ndkToolchainSysPath} -L#{Config.ndkSourcesRoot}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.9.x -L#{icuRootPath} -L#{ndkToolchainSysPath}/usr/lib -ldispatch\""

      cmd << "./configure Release --target=armv7-none-linux-androideabi --sysroot=#{ndkToolchainSysPath}"
      # cmd << "-DXCTEST_BUILD_DIR=#{swiftSDKRoot}/xctest-linux-x86_64"
      cmd << "-DLIBDISPATCH_SOURCE_DIR=#{Config.swiftSourcesRoot}/swift-corelibs-libdispatch"
      # cmd << "-DLIBDISPATCH_BUILD_DIR=#{Config.dispatchBuildDir}/swift-corelibs-libdispatch" #fixme
      execute cmd.join(" ")
   end

   def build; end

   def make
      prepare
      configure
      build
   end

end
