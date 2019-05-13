require_relative "../Common/Builder.rb"

=begin

Swift for Linux:
- Compiling swift on Linux: https://akrabat.com/compiling-swift-on-linux/
- Build Swift for Android from your Mac: https://github.com/flowkey/swift-android-toolchain

Swift for Android:
- See ./Sources/Swift/swift/utils/android/build-toolchain
- Running Swift code on Android https://romain.goyet.com/articles/running_swift_code_on_android/
- Building a Development Environment for Swift on Android: https://medium.com/@michiamling/building-a-development-environment-for-swift-on-android-4bb652d2c938
- Java and Swift interoperability: https://medium.com/@michiamling/android-app-with-java-native-interface-for-swift-c9c322609e08
- Android App with Java native interface for Swift: http://michis.culture-blog.org/2017/04/android-app-with-java-native-interface.html
- Building the Swift stdlib for Android – https://github.com/amraboelela/swift/blob/android/docs/Android.md
- fuchsia build – https://fuchsia.googlesource.com/third_party/swift-corelibs-foundation/+/upstream/google/build-android
- https://www.reddit.com/r/swift/comments/3w0xrd/im_patching_the_opensource_swift_compiler_to/
- https://github.com/flowkey/UIKit-cross-platform
- https://blog.readdle.com/why-we-use-swift-for-android-db449feeacaf
- Swift on Android: The Future of Cross-Platform Programming?: https://academy.realm.io/posts/swift-on-android/

Pull Requests and Patches:
- Port to Android Patch: https://github.com/SwiftAndroid/swift/commit/7c502b6344a240c8e06c5e48e5ab6fa32c887ab3

Issues:
- Issue with lg.gold – https://bugs.swift.org/browse/SR-1264
- Issue with ld.gold – https://github.com/apple/swift/commit/d49d88e53d15b6cba00950ec7985df4631e24312

Cross compile:
- Cross compile Apps on Mac for Linux: https://github.com/apple/swift-package-manager/blob/master/Utilities/build_ubuntu_cross_compilation_toolchain
- Swift cross compile on Rasperi Pi: https://stackoverflow.com/a/44003655/1418981

=end

class SwiftBuilder < Builder

   def initialize()
      super(Lib.swift, Arch.host)
      @ndk = NDK.new()
      @cmark = CMarkBuilder.new()
      @llvm = LLVMBuilder.new()
      @clang = ClangBuilder.new(@arch)
   end

   def executeConfigure
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja"  #  --trace --debug-output"

      cmd << "-DCMAKE_LIBTOOL=#{toolchainPath}/usr/bin/libtool"
      cmd << "-DSWIFT_LIPO=#{toolchainPath}/usr/bin/lipo"
      cmd << "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.9"
      cmd << "-DCMAKE_OSX_SYSROOT=#{macOSSDK}"
      cmd << "-DSWIFT_DARWIN_DEPLOYMENT_VERSION_OSX=10.9"

      cmd << "-DSWIFT_STDLIB_ENABLE_SIL_OWNERSHIP=FALSE"
      cmd << "-DSWIFT_ENABLE_GUARANTEED_NORMAL_ARGUMENTS=TRUE"
      cmd << "-DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE"
      cmd << "-DSWIFT_STDLIB_ENABLE_STDLIBCORE_EXCLUSIVITY_CHECKING=FALSE"

      cmd << "-DSWIFT_ANDROID_NDK_PATH=#{@ndk.sources}"
      cmd << "-DSWIFT_ANDROID_NDK_GCC_VERSION=#{@ndk.gcc}"
      cmd << "-DSWIFT_ANDROID_API_LEVEL=#{@ndk.api}"
      cmd << "-DSWIFT_ANDROID_DEPLOY_DEVICE_PATH=/data/local/tmp"
      cmd << "-DSWIFT_SDK_ANDROID_ARCHITECTURES=\"armv7;aarch64;i686;x86_64\""

      icu = ICUBuilder.new(Arch.armv7a)
      cmd << "-DSWIFT_ANDROID_armv7_ICU_UC=#{icu.lib}/libicuucswift.so"
      cmd << "-DSWIFT_ANDROID_armv7_ICU_UC_INCLUDE=#{icu.sources}/source/common"
      cmd << "-DSWIFT_ANDROID_armv7_ICU_I18N=#{icu.lib}/libicui18nswift.so"
      cmd << "-DSWIFT_ANDROID_armv7_ICU_I18N_INCLUDE=#{icu.sources}/source/i18n"
      cmd << "-DSWIFT_ANDROID_armv7_ICU_DATA=#{icu.lib}/libicudataswift.so"
      icu = ICUBuilder.new(Arch.aarch64)
      cmd << "-DSWIFT_ANDROID_aarch64_ICU_UC=#{icu.lib}/libicuucswift.so"
      cmd << "-DSWIFT_ANDROID_aarch64_ICU_UC_INCLUDE=#{icu.sources}/source/common"
      cmd << "-DSWIFT_ANDROID_aarch64_ICU_I18N=#{icu.lib}/libicui18nswift.so"
      cmd << "-DSWIFT_ANDROID_aarch64_ICU_I18N_INCLUDE=#{icu.sources}/source/i18n"
      cmd << "-DSWIFT_ANDROID_aarch64_ICU_DATA=#{icu.lib}/libicudataswift.so"
      icu = ICUBuilder.new(Arch.x86)
      cmd << "-DSWIFT_ANDROID_i686_ICU_UC=#{icu.lib}/libicuucswift.so"
      cmd << "-DSWIFT_ANDROID_i686_ICU_UC_INCLUDE=#{icu.sources}/source/common"
      cmd << "-DSWIFT_ANDROID_i686_ICU_I18N=#{icu.lib}/libicui18nswift.so"
      cmd << "-DSWIFT_ANDROID_i686_ICU_I18N_INCLUDE=#{icu.sources}/source/i18n"
      cmd << "-DSWIFT_ANDROID_i686_ICU_DATA=#{icu.lib}/libicudataswift.so"
      icu = ICUBuilder.new(Arch.x64)
      cmd << "-DSWIFT_ANDROID_x86_64_ICU_UC=#{icu.lib}/libicuucswift.so"
      cmd << "-DSWIFT_ANDROID_x86_64_ICU_UC_INCLUDE=#{icu.sources}/source/common"
      cmd << "-DSWIFT_ANDROID_x86_64_ICU_I18N=#{icu.lib}/libicui18nswift.so"
      cmd << "-DSWIFT_ANDROID_x86_64_ICU_I18N_INCLUDE=#{icu.sources}/source/i18n"
      cmd << "-DSWIFT_ANDROID_x86_64_ICU_DATA=#{icu.lib}/libicudataswift.so"

      cFlags = "-Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector"
      cmd << "-DCMAKE_C_FLAGS='#{cFlags}'"
      cmd << "-DCMAKE_CXX_FLAGS='#{cFlags}'"
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DSWIFT_BUILD_SOURCEKIT=FALSE"
      cmd << "-DLLVM_ENABLE_ASSERTIONS=TRUE"
      cmd << "-DSWIFT_STDLIB_ASSERTIONS=FALSE"
      cmd << "-DSWIFT_INCLUDE_TOOLS=TRUE"
      cmd << "-DSWIFT_BUILD_REMOTE_MIRROR=TRUE"
      cmd << "-DSWIFT_STDLIB_SIL_DEBUGGING=FALSE"
      cmd << "-DSWIFT_BUILD_DYNAMIC_STDLIB=TRUE"
      cmd << "-DSWIFT_BUILD_STATIC_STDLIB=FALSE"

      cmd << "-DSWIFT_BUILD_DYNAMIC_SDK_OVERLAY=TRUE"
      cmd << "-DSWIFT_BUILD_STATIC_SDK_OVERLAY=FALSE"

      # Disable Benchmarks
      cmd << "-DSWIFT_BUILD_PERF_TESTSUITE=FALSE"
      cmd << "-DSWIFT_BUILD_EXTERNAL_PERF_TESTSUITE=FALSE"

      cmd << "-DSWIFT_BUILD_EXAMPLES=FALSE"
      cmd << "-DSWIFT_INCLUDE_TESTS=FALSE"
      cmd << "-DSWIFT_INCLUDE_DOCS=FALSE"
      cmd << "-DSWIFT_ENABLE_SOURCEKIT_TESTS=FALSE"
      cmd << "-DSWIFT_INSTALL_COMPONENTS='autolink-driver;compiler;clang-builtin-headers;stdlib;swift-remote-mirror;sdk-overlay;license'"
      cmd << "-DLIBDISPATCH_CMAKE_BUILD_TYPE=Release"
      cmd << "-DSWIFT_ENABLE_LLD_LINKER=FALSE"

      cmd << "-DSWIFT_OVERLAY_TARGETS=''" # Disabling builds of Darwin Overlays.
      cmd << "-DSWIFT_HOST_VARIANT=macosx"
      cmd << "-DSWIFT_HOST_VARIANT_SDK=OSX"
      cmd << "-DSWIFT_ENABLE_IOS32=false"
      cmd << "-DSWIFT_SDK_OSX_PATH=#{macOSSDK}"

      cmd << "-DSWIFT_SDKS='ANDROID'"
      cmd << "-DSWIFT_HOST_TRIPLE=x86_64-apple-macosx10.9"

      cmd << "-DSWIFT_HOST_VARIANT_ARCH=x86_64"
      cmd << "-DLLVM_LIT_ARGS=-sv"
      cmd << "-DCOVERAGE_DB="
      cmd << "-DSWIFT_SOURCEKIT_USE_INPROC_LIBRARY=TRUE"
      cmd << "-DSWIFT_AST_VERIFIER=FALSE"
      cmd << "-DSWIFT_RUNTIME_ENABLE_LEAK_CHECKER=FALSE"
      cmd << "-DCMAKE_INSTALL_PREFIX=/"

      cmd << "-DSWIFT_PATH_TO_CLANG_SOURCE=#{@clang.sources}"
      cmd << "-DSWIFT_PATH_TO_CLANG_BUILD=#{@llvm.builds}"

      cmd << "-DSWIFT_PATH_TO_LLVM_SOURCE=#{@llvm.sources}"
      cmd << "-DSWIFT_PATH_TO_LLVM_BUILD=#{@llvm.builds}"

      cmd << "-DSWIFT_PATH_TO_CMARK_SOURCE=#{@cmark.sources}"
      cmd << "-DSWIFT_PATH_TO_CMARK_BUILD=#{@cmark.builds}"

      # See: https://gitlab.kitware.com/cmake/community/wikis/doc/cmake/Graphviz
      # cmd << "--graphviz=#{@builds}/graph.dot"
      cmd << @sources
      execute cmd.join(" \\\n   ")
      fixNinjaBuild()
      fixNinjaRules()
   end

   def executeBuild
      execute "cd #{@builds} && ninja -j#{numberOfJobs}"

      targets = "swiftGlibc-android-armv7 swiftCore-android-armv7 swiftSIMDOperators-android-armv7 swiftSwiftOnoneSupport-android-armv7"
      execute "cd #{@builds} && ninja -j#{numberOfJobs} #{targets}"
      targets = "swiftGlibc-android-aarch64 swiftCore-android-aarch64 swiftSIMDOperators-android-aarch64 swiftSwiftOnoneSupport-android-aarch64"
      execute "cd #{@builds} && ninja -j#{numberOfJobs} #{targets}"
      targets = "swiftGlibc-android-i686 swiftCore-android-i686 swiftSIMDOperators-android-i686 swiftSwiftOnoneSupport-android-i686"
      execute "cd #{@builds} && ninja -j#{numberOfJobs} #{targets}"
      targets = "swiftGlibc-android-x86_64 swiftCore-android-x86_64 swiftSIMDOperators-android-x86_64 swiftSwiftOnoneSupport-android-x86_64"
      execute "cd #{@builds} && ninja -j#{numberOfJobs} #{targets}"
   end

   def executeInstall
      fixInstallScript()
      fixStdLibInstallScript("#{@builds}/stdlib/public/core/cmake_install.cmake")
      fixStdLibInstallScript("#{@builds}/stdlib/public/SwiftOnoneSupport/cmake_install.cmake")
      fixStdLibInstallScript("#{@builds}/stdlib/public/SIMDOperators/cmake_install.cmake")
      fixStdLibInstallScript("#{@builds}/stdlib/public/SwiftRemoteMirror/cmake_install.cmake")
      fixStdLibInstallScript("#{@builds}/stdlib/public/Platform/cmake_install.cmake")
      execute "DESTDIR=#{@installs} cmake --build #{@builds} -- install"
   end

   def fixNinjaBuild
      file = "#{@builds}/build.ninja"
      message "Applying fix for #{file}"
      execute "cp -vf #{file} #{file}.orig"
      lines = File.readlines(file)
      result = []
      # >> Fixes non NDK Linker options.
      shouldFixLinker = false
      lines.each { |line|
         if line.start_with?("build") && line.include?('CXX_SHARED_LIBRARY_LINKER') && line.include?("android")
            shouldFixLinker = true
         elsif line.strip() == ""
            shouldFixLinker = false
         elsif shouldFixLinker && line.include?('LINK_LIBRARIES')
            # See also: Build/armv7a-macos/swift/lib/cmake/swift/SwiftExports.cmake and Build/armv7a-macos/swift/lib/cmake/swift/SwiftConfig.cmake
            line = line.gsub('-framework Foundation', '')
            line = line.gsub('-framework CoreFoundation', '')
            line = line.gsub('-licucore', '')
         elsif shouldFixLinker && line.include?('LINK_FLAGS')
            line = line.gsub('-all_load', '')
         end
         result << line
      }
      # <<
      lines = result
      contents = lines.join()
      contents = contents.gsub('-D__ANDROID_API__=21  -fobjc-arc', '-D__ANDROID_API__=21')
      File.write(file, contents)
   end

   def fixNinjaRules
      file = "#{@builds}/rules.ninja"
      message "Applying fix for #{file}"
      execute "cp -vf #{file} #{file}.orig"
      lines = File.readlines(file)
      result = []
      # >> Fixes non NDK Dynamic Linker options.
      shouldFixLinker = false
      lines.each { |line|
         if line.start_with?("rule") && line.include?('CXX_SHARED_LIBRARY_LINKER') && line.include?("android")
            shouldFixLinker = true
         elsif line.strip() == ""
            shouldFixLinker = false
         elsif shouldFixLinker && line.include?('command')
            line = line.gsub('-dynamiclib', '-shared')
            line = line.gsub('$SONAME_FLAG $INSTALLNAME_DIR$SONAME', '-Wl,-soname,$SONAME')
            line = line.gsub('-Wl,-headerpad_max_install_names', '')
         end
         result << line
      }
      lines = result
      File.write(file, lines.join() + "\n")
   end

   def fixInstallScript
      sourceFile = "#{@builds}/cmake_install.cmake"
      lines = readInstallScript(sourceFile)
      result = []
      lines.each { |line|
         if line.include?('if(CMAKE_INSTALL_COMPONENT)')
            line = installCommands("armv7") + "\n" + installCommands("aarch64") + "\n" + installCommands("i686") + "\n" + installCommands("x86_64") + "\n" + line
         end
         result << line
      }
      lines = result
      File.write(sourceFile, lines.join() + "\n")
   end

   def installCommands(arch)
      files = Dir["#{builds}/lib/swift/android/#{arch}/*.so"].map { |so| " \"#{so}\"" }.join("\n")
      commands = 'if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)' + "\n"
      commands += " file(INSTALL DESTINATION \"${CMAKE_INSTALL_PREFIX}/lib/swift/android/#{arch}\" TYPE FILE FILES" + "\n"
      commands += files
      commands += ")\nendif()\n"
   end

   def fixStdLibInstallScript(sourceFile)
      lines = readInstallScript(sourceFile)
      lines = lines.reject { |line| line.include?(".dylib") }
      File.write(sourceFile, lines.join() + "\n")
   end

   def readInstallScript(sourceFile)
      backupFile = "#{sourceFile}.orig"
      if !File.exist?(backupFile)
         execute "cp -vf #{sourceFile} #{backupFile}"
      end
      message "Applying fix for #{sourceFile}"
      execute "cp -vf #{backupFile} #{sourceFile}"
      return File.readlines(sourceFile)
   end

   def configurePatches(shouldEnable = true)
      configurePatchFile("#{@patches}/stdlib/private/CMakeLists.txt.diff", shouldEnable)
      configurePatchFile("#{@patches}/stdlib/public/stubs/CMakeLists.txt.diff", shouldEnable)
      configurePatchFile("#{@patches}/stdlib/public/SwiftShims/LibcShims.h.diff", shouldEnable)
      configurePatchFile("#{@patches}/stdlib/CMakeLists.txt.diff", shouldEnable)
      configurePatchFile("#{@patches}/cmake/modules/AddSwift.cmake.diff", shouldEnable)
      configurePatchFile("#{@patches}/cmake/modules/SwiftConfigureSDK.cmake.diff", shouldEnable)
      configurePatchFile("#{@patches}/cmake/modules/SwiftAndroidSupport.cmake.diff", shouldEnable)
      configurePatchFile("#{@patches}/include/swift/Runtime/SwiftDtoa.h.diff", shouldEnable)
      configurePatchFile("#{@patches}/stdlib/public/Platform/tgmath.swift.gyb.diff", shouldEnable)
      configurePatchFile("#{@patches}/stdlib/public/Platform/Glibc.swift.gyb.diff", shouldEnable)
      configurePatchFile("#{@patches}/stdlib/public/SDK/CoreGraphics/CGFloat.swift.gyb.diff", shouldEnable)
      configurePatchFile("#{@patches}/stdlib/public/core/FloatingPoint.swift.diff", shouldEnable)
      configurePatchFile("#{@patches}/stdlib/public/core/VarArgs.swift.diff", shouldEnable)
      configurePatchFile("#{@patches}/stdlib/public/core/Mirrors.swift.gyb.diff", shouldEnable)
      configurePatchFile("#{@patches}/stdlib/public/core/BuiltinMath.swift.gyb.diff", shouldEnable)
      configurePatchFile("#{@patches}/stdlib/public/core/FloatingPointParsing.swift.gyb.diff", shouldEnable)
      configurePatchFile("#{@patches}/stdlib/public/core/FloatingPointTypes.swift.gyb.diff", shouldEnable)
      configurePatchFile("#{@patches}/stdlib/public/core/IntegerTypes.swift.gyb.diff", shouldEnable)
      configurePatchFile("#{@patches}/stdlib/public/core/Runtime.swift.gyb.diff", shouldEnable)
   end

end
