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
      @llvm = LLVMBuilder.new(arch)
   end

   def prepare
      execute "mkdir -p #{@build}"
      copyFiles
   end

   def copyFiles
      usr = @ndk.install + "/sysroot/usr"
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
      sysroot = @ndk.install + "/sysroot"
      cmd = []
      cmd << "cd #{@sources} && env"
      cmd << "BUILD_DIR=#{@build}"
      cmd << "DSTROOT=#{@install}"

      cmd << "SWIFTC=\"#{@swift.bin}/swiftc\""
      cmd << "CLANG=\"#{@llvm.bin}/clang\""
      # cmd << "CLANGXX=\"#{@llvm.bin}/clang++\""
      cmd << "SWIFT=\"#{@swift.bin}/swift\""
      cmd << "SDKROOT=\"#{@swift.install}\""
      cmd << "CFLAGS=\"-DDEPLOYMENT_TARGET_ANDROID -DDEPLOYMENT_ENABLE_LIBDISPATCH --sysroot=#{sysroot} -I#{@icu.include} -I#{@swift.lib}/swift -I#{@ndk.sources}/sources/android/support/include -I#{sysroot}/usr/include -I#{@sources}/closure\""
      cmd << "SWIFTCFLAGS=\"-DDEPLOYMENT_TARGET_ANDROID -DDEPLOYMENT_ENABLE_LIBDISPATCH -Xcc -DDEPLOYMENT_TARGET_ANDROID -I#{sysroot}/usr/include\""
      cmd << "LDFLAGS=\"-fuse-ld=gold --sysroot=#{sysroot} -L#{@ndk.sources}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.9.x -L#{@icu.lib} -L#{sysroot}/usr/lib -ldispatch\""
      return cmd
   end

   def configure
      sysroot = @ndk.install + "/sysroot"
      cmd = args
      cmd << "./configure Release --target=armv7-none-linux-androideabi --sysroot=#{sysroot}"
      # cmd << "-DXCTEST_BUILD_DIR=#{swiftCCRoot}/xctest-linux-x86_64"
      cmd << "-DLIBDISPATCH_SOURCE_DIR=#{@dispatch.sources}"
      cmd << "-DLIBDISPATCH_BUILD_DIR=#{@dispatch.install}"
      execute cmd.join(" ")

      execute "cd #{@sourcesDir} && sed --in-place 's/-I\\/usr\\/include\\/x86_64-linux-gnu//' build.ninja"
      execute "cd #{@sourcesDir} && sed --in-place 's/-I\\/usr\\/include\\/libxml2//' build.ninja"
      execute "cd #{@sourcesDir} && sed --in-place 's/-I.\\///' build.ninja"
      execute "cd #{@sourcesDir} && sed --in-place 's/-licui18n/-licui18nswift/g' build.ninja"
      execute "cd #{@sourcesDir} && sed --in-place 's/-licuuc/-licuucswift/g' build.ninja"
      execute "cd #{@sourcesDir} && sed --in-place 's/-licudata/-licudataswift/g' build.ninja"
   end

   def compile
      execute args.join(" ") + " ninja CopyHeaders"

      # Patching module.modulemap file.
      message "Patching module.modulemap file."
      headersPath = "#{@build}/Foundation/usr/lib/swift/CoreFoundation"
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
      compile
   end

   def clean
      execute "rm -rf \"#{@build}\""
      execute "rm -rf \"#{@install}\""
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/apple/swift-corelibs-foundation", "a7f12d0851780b2c196733b2710a8ff2ae56bdcd")
   end

end
