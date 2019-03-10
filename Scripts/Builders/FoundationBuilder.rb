require_relative "../Common/Builder.rb"

# See:
# - Libdispatch issues with CMake: https://forums.swift.org/t/libdispatch-switched-to-cmake/6665/7
class FoundationBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.foundation, arch)
      @ndk = AndroidBuilder.new(arch)
      @dispatch = DispatchBuilder.new(arch)
      @swift = SwiftBuilder.new(arch)
      @llvm = LLVMBuilder.new(arch)
      @curl = CurlBuilder.new(arch)
      @icu = ICUBuilder.new(arch)
      @xml = XMLBuilder.new(arch)
   end

   def executeConfigure
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja"
      cmd << "-DFOUNDATION_PATH_TO_LIBDISPATCH_SOURCE=#{@dispatch.sources}"
      cmd << "-DFOUNDATION_PATH_TO_LIBDISPATCH_BUILD=#{@dispatch.builds}" # Check later if we can use `@installs`
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      if @arch == Arch.host
         cmd << "-DCMAKE_C_COMPILER=\"#{@llvm.builds}/bin/clang\""
         cmd << "-DCMAKE_INSTALL_PREFIX=#{@installs}"
      else
         includePath = "#{@ndk.sources}/sysroot/usr/include"
         cFlags = "-D__ANDROID__"
         # See why we need to use cmake toolchain in NDK v19 - https://gitlab.kitware.com/cmake/cmake/issues/18739
         cmd << "-DCMAKE_TOOLCHAIN_FILE=#{@ndk.sources}/build/cmake/android.toolchain.cmake"
         cmd << "-DANDROID_STL=c++_static"
         cmd << "-DANDROID_TOOLCHAIN=clang"
         cmd << "-DANDROID_PLATFORM=android-#{@ndk.api}"
         cmd << "-DANDROID_ABI=armeabi-v7a"
         cmd << "-DCMAKE_SYSTEM_NAME=Android"
         cmd << "-DCMAKE_C_FLAGS=\"#{cFlags}\""
         cmd << "-DCMAKE_CXX_FLAGS=\"#{cFlags}\""

         cmd << "-DADDITIONAL_SWIFT_FLAGS='-I#{includePath}\;-I#{includePath}/arm-linux-androideabi'"
         # Foundation.so `__CFConstantStringClassReference=$s10Foundation19_NSCFConstantStringCN`. Double $$ used as escape.
         platformPathComponent = isMacOS? ? "darwin-x86_64" : "linux-x86_64"
         cmd << "-DADDITIONAL_SWIFT_LINK_FLAGS='-v\;-use-ld=gold\;-tools-directory\;#{@ndk.toolchain}/arm-linux-androideabi/bin\;-L\;#{@ndk.toolchain}/sysroot/usr/lib/arm-linux-androideabi/#{@ndk.api}\;-L\;#{@ndk.sources}/toolchains/arm-linux-androideabi-4.9/prebuilt/#{platformPathComponent}/lib/gcc/arm-linux-androideabi/4.9.x\;-Xlinker\;--defsym\;-Xlinker\;\"__CFConstantStringClassReference=\\$$s10Foundation19_NSCFConstantStringCN\"'"
         cmd << "-DADDITIONAL_SWIFT_CFLAGS='-DDEPLOYMENT_TARGET_ANDROID'"

         cmd << "-DICU_INCLUDE_DIR=#{@icu.include}"
         cmd << "-DICU_LIBRARY=#{@icu.lib}"
         cmd << "-DICU_I18N_LIBRARY_RELEASE=#{@icu.lib}/libicui18nswift.so"
         cmd << "-DICU_UC_LIBRARY_RELEASE=#{@icu.lib}/libicuucswift.so"

         cmd << "-DLIBXML2_INCLUDE_DIR=#{@xml.include}/libxml2"
         cmd << "-DLIBXML2_LIBRARY=#{@xml.lib}/libxml2.so"

         cmd << "-DCURL_INCLUDE_DIR=#{@curl.include}"
         cmd << "-DCURL_LIBRARY=#{@curl.lib}/libcurl.so"

         cmd << "-DCMAKE_INSTALL_PREFIX=#{@swift.installs}/usr" # Applying Foundation over existing file structure.
      end
      cmd << "-DCMAKE_SWIFT_COMPILER=\"#{@swift.builds}/bin/swiftc\""

      # if isMacOS?
      #    cmd << "-DCMAKE_AR=#{@ndk.bin}/arm-linux-androideabi-ar"
      # end

      cmd << @sources
      execute cmd.join(" ")
   end

   def executeBuild
      # For troubleshooting purpose.
      # execute "cd #{@builds} && ninja CoreFoundation"
      execute "ln -vfs #{@ndk.toolchain}/sysroot/usr/lib/arm-linux-androideabi/21/crtbegin_so.o #{@builds}"
      execute "ln -vfs #{@ndk.toolchain}/sysroot/usr/lib/arm-linux-androideabi/21/crtend_so.o #{@builds}"
      execute "cd #{@builds} && ninja"
   end

   def executeInstall
      execute "cd #{@builds} && ninja install"
   end

   def configurePatches(shouldEnable = true)
      if @arch == Arch.host && shouldEnable
         return
      end
      configurePatchFile("#{@patches}/CMakeLists.txt.diff", shouldEnable)
      configurePatchFile("#{@patches}/Foundation/Data.swift.diff", shouldEnable)
      configurePatchFile("#{@patches}/CoreFoundation/CMakeLists.txt.diff", shouldEnable)
      configurePatchFile("#{@patches}/cmake/modules/SwiftSupport.cmake.diff", shouldEnable)
      configurePatch("#{@sources}/Foundation/NSGeometry.swift", "#{@patches}/NSGeometry.patch", shouldEnable)

      # FIXME: Below patches may cause unexpected behaviour on Android because it is not yet implemented. Linux version will be used.
      configurePatch("#{@sources}/CoreFoundation/Base.subproj/CFKnownLocations.c", "#{@patches}/CFKnownLocations.patch", shouldEnable)
      configurePatch("#{@sources}/CoreFoundation/Base.subproj/ForSwiftFoundationOnly.h", "#{@patches}/ForSwiftFoundationOnly.patch", shouldEnable)
      configurePatch("#{@sources}/Foundation/FileManager.swift", "#{@patches}/FileManager.patch", shouldEnable)
   end

end
