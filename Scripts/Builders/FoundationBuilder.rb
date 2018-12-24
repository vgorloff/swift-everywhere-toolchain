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

   def configure
      prepare
      configurePatches(false)
      configurePatches
      # sysroot = @ndk.installs + "/sysroot"
      cmd = []
      cmd << "cd #{@builds} &&"
      # Seems not needed.
      if @arch != Arch.host
         # cmd << "ICU_ROOT=#{@icu.installs}"
         # cmd << "PATH=#{@ndk.bin}:$PATH"
         # cmd << "CFLAGS='-DDEPLOYMENT_TARGET_ANDROID'"
         # cmd << "SWIFTCFLAGS='-DDEPLOYMENT_TARGET_ANDROID -DDEPLOYMENT_ENABLE_LIBDISPATCH -Xcc -DDEPLOYMENT_TARGET_ANDROID -I#{sysroot}/usr/include'"
      end
      cmd << "cmake -G Ninja"
      cmd << "-DFOUNDATION_PATH_TO_LIBDISPATCH_SOURCE=#{@dispatch.sources}"
      cmd << "-DFOUNDATION_PATH_TO_LIBDISPATCH_BUILD=#{@dispatch.builds}" # Check later if we can use `@installs`
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      if @arch == Arch.host
         cmd << "-DCMAKE_C_COMPILER=\"#{@swift.llvm}/bin/clang\""
      else
         cmd << "-DCMAKE_SYSROOT=#{@ndk.installs}/sysroot"
         cmd << "-DCMAKE_SYSTEM_NAME=Android"
         cmd << "-DCMAKE_SYSTEM_VERSION=#{@ndk.api}"
         cmd << "-DCMAKE_ANDROID_ARCH_ABI=armeabi-v7a"
         cmd << "-DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang"
         cmd << "-DCMAKE_ANDROID_STL_TYPE=\"c++_static\""

         # Seems not needed.
         # cmd << "-DCMAKE_C_COMPILER=\"#{@ndk.bin}/clang\""
         # cmd << "-DCMAKE_ANDROID_STANDALONE_TOOLCHAIN=#{@ndk.installs}"
         # cmd << "-DCMAKE_ANDROID_NDK=#{@ndk.sources}"

         cmd << "-DICU_INCLUDE_DIR=#{@icu.include}"
         cmd << "-DICU_LIBRARY=#{@icu.lib}"
         cmd << "-DICU_I18N_LIBRARY_RELEASE=#{@icu.lib}/libicui18nswift.so"
         cmd << "-DICU_UC_LIBRARY_RELEASE=#{@icu.lib}/libicuucswift.so"

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

   def build
      prepare
      setupSymLinks

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
      includePath = "#{@ndk.installs}/sysroot/usr/include"
      if !contents.include?(includePath)
         contents = contents.gsub('-module-link-name Foundation', "-module-link-name Foundation -Xcc -I#{includePath}")
         contents = contents.gsub('-target armv7-none-linux-androideabi', "-target armv7-none-linux-androideabi -tools-directory #{@ndk.installs}/bin")
         contents = contents.gsub('-Xcc -DDEPLOYMENT_TARGET_LINUX', '-Xcc -DDEPLOYMENT_TARGET_ANDROID')
      end
      File.write(file, contents)
   end

   def setupSymLinks
      if @arch == Arch.host
         return
      end
      execute "mkdir -p #{@includes}"
      execute "ln -fvs /usr/include/uuid #{@includes}"
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

      # FIXME: Below patches may cause unexpected behaviour on Android because it is not yet implemented. Linux version will be used.

      originalFile = "#{@sources}/CoreFoundation/Base.subproj/CFKnownLocations.c"
      patchFile = "#{@patches}/CFKnownLocations.patch"
      configurePatch(originalFile, patchFile, shouldEnable)

      originalFile = "#{@sources}/CoreFoundation/Base.subproj/ForSwiftFoundationOnly.h"
      patchFile = "#{@patches}/ForSwiftFoundationOnly.patch"
      configurePatch(originalFile, patchFile, shouldEnable)

      originalFile = "#{@sources}/Foundation/FileManager.swift"
      patchFile = "#{@patches}/FileManager.patch"
      configurePatch(originalFile, patchFile, shouldEnable)

      originalFile = "#{@sources}/Foundation/NSGeometry.swift"
      patchFile = "#{@patches}/NSGeometry.patch"
      configurePatch(originalFile, patchFile, shouldEnable)

      originalFile = "#{@sources}/Tools/plutil/main.swift"
      patchFile = "#{@patches}/plutil.patch"
      configurePatch(originalFile, patchFile, shouldEnable)
   end

end
