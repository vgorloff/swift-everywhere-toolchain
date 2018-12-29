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

   def initialize(arch = Arch.default)
      super(Lib.swift, arch)
      @icu = ICUBuilder.new(arch)
      @ndk = AndroidBuilder.new(arch)
   end

   def configure
      logConfigureStarted
      prepare

      dispatch = DispatchBuilder.new()
      llvm = LLVMBuilder.new()
      ndk = AndroidBuilder.new()
      icu = ICUBuilder.new()
      cmark = CMarkBuilder.new()
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja"

      cmd << "-DCMAKE_C_COMPILER:PATH=#{clang}"
      cmd << "-DCMAKE_CXX_COMPILER:PATH=#{clang}++"
      if isMacOS?
         cmd << "-DCMAKE_LIBTOOL=#{toolchainPath}/usr/bin/libtool"
         cmd << "-DSWIFT_LIPO=#{toolchainPath}/usr/bin/lipo"
         cmd << "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.12"
         cmd << "-DCMAKE_OSX_SYSROOT=#{macOSSDK}"
         cmd << "-DSWIFT_DARWIN_DEPLOYMENT_VERSION_OSX=10.12"
      end
      # cmd << "-DCMAKE_LIBTOOL:PATH="
      cmd << "-DLLVM_VERSION_MAJOR:STRING=7"
      cmd << "-DLLVM_VERSION_MINOR:STRING=0"
      cmd << "-DLLVM_VERSION_PATCH:STRING=0"
      cmd << "-DCLANG_VERSION_MAJOR:STRING=7"
      cmd << "-DCLANG_VERSION_MINOR:STRING=0"
      cmd << "-DCLANG_VERSION_PATCH:STRING=0"
      cmd << "-DSWIFT_STDLIB_ENABLE_SIL_OWNERSHIP=FALSE"
      cmd << "-DSWIFT_ENABLE_GUARANTEED_NORMAL_ARGUMENTS=TRUE"
      cmd << "-DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE"
      cmd << "-DSWIFT_FORCE_OPTIMIZED_TYPECHECKER=FALSE"
      cmd << "-DSWIFT_STDLIB_ENABLE_STDLIBCORE_EXCLUSIVITY_CHECKING=FALSE"

      if @arch != Arch.host
         cmd << "-DSWIFT_ANDROID_NDK_PATH:STRING=#{ndk.sources}"
         cmd << "-DSWIFT_ANDROID_NDK_GCC_VERSION:STRING=#{ndk.gcc}"
         cmd << "-DSWIFT_ANDROID_API_LEVEL:STRING=#{ndk.api}"
         cmd << "-DSWIFT_ANDROID_armv7_ICU_UC:STRING=#{icu.lib}/libicuucswift.so"
         cmd << "-DSWIFT_ANDROID_armv7_ICU_UC_INCLUDE:STRING=#{icu.sources}/source/common"
         cmd << "-DSWIFT_ANDROID_armv7_ICU_I18N:STRING=#{icu.lib}/libicui18nswift.so"
         cmd << "-DSWIFT_ANDROID_armv7_ICU_I18N_INCLUDE:STRING=#{icu.sources}/source/i18n"
         cmd << "-DSWIFT_ANDROID_armv7_ICU_DATA:STRING=#{icu.lib}/libicudataswift.so"
         cmd << "-DSWIFT_ANDROID_DEPLOY_DEVICE_PATH:STRING=/data/local/tmp"
         cmd << "-DSWIFT_SDK_ANDROID_ARCHITECTURES:STRING=armv7"
      end
      cFlags = "-Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector"
      cmd << "-DCMAKE_C_FLAGS='#{cFlags}'"
      cmd << "-DCMAKE_CXX_FLAGS='#{cFlags}'"
      cmd << "-DCMAKE_BUILD_TYPE:STRING=Release"
      cmd << "-DLLVM_ENABLE_ASSERTIONS:BOOL=TRUE"
      cmd << "-DSWIFT_ANALYZE_CODE_COVERAGE:STRING=FALSE"
      cmd << "-DSWIFT_STDLIB_BUILD_TYPE:STRING=Release"
      cmd << "-DSWIFT_STDLIB_ASSERTIONS:BOOL=FALSE"
      cmd << "-DSWIFT_STDLIB_USE_NONATOMIC_RC:BOOL=FALSE"
      cmd << "-DSWIFT_ENABLE_RUNTIME_FUNCTION_COUNTERS:BOOL=FALSE"
      cmd << "-DSWIFT_NATIVE_LLVM_TOOLS_PATH:STRING="
      cmd << "-DSWIFT_NATIVE_CLANG_TOOLS_PATH:STRING="
      cmd << "-DSWIFT_NATIVE_SWIFT_TOOLS_PATH:STRING="
      cmd << "-DSWIFT_INCLUDE_TOOLS:BOOL=TRUE"
      cmd << "-DSWIFT_BUILD_REMOTE_MIRROR:BOOL=TRUE"
      cmd << "-DSWIFT_STDLIB_SIL_DEBUGGING:BOOL=FALSE"
      cmd << "-DSWIFT_CHECK_INCREMENTAL_COMPILATION:BOOL=FALSE"
      cmd << "-DSWIFT_REPORT_STATISTICS:BOOL=FALSE"
      cmd << "-DSWIFT_BUILD_DYNAMIC_STDLIB:BOOL=TRUE"
      cmd << "-DSWIFT_BUILD_STATIC_STDLIB:BOOL=FALSE"
      cmd << "-DSWIFT_BUILD_DYNAMIC_SDK_OVERLAY:BOOL=TRUE"
      cmd << "-DSWIFT_BUILD_STATIC_SDK_OVERLAY:BOOL=FALSE"
      cmd << "-DSWIFT_BUILD_PERF_TESTSUITE=FALSE"
      cmd << "-DSWIFT_BUILD_EXTERNAL_PERF_TESTSUITE=FALSE"
      # >> Seems can be false
      cmd << "-DSWIFT_BUILD_EXAMPLES:BOOL=TRUE"
      cmd << "-DSWIFT_INCLUDE_TESTS:BOOL=TRUE"
      # <<
      cmd << "-DSWIFT_INSTALL_COMPONENTS:STRING='autolink-driver;compiler;clang-builtin-headers;stdlib;swift-remote-mirror;sdk-overlay;license'"
      cmd << "-DSWIFT_EMBED_BITCODE_SECTION:BOOL=FALSE"
      cmd << "-DSWIFT_TOOLS_ENABLE_LTO:STRING="
      cmd << "-DSWIFT_BUILD_RUNTIME_WITH_HOST_COMPILER:BOOL=FALSE"
      cmd << "-DLIBDISPATCH_CMAKE_BUILD_TYPE:STRING=Release"
      if isMacOS?
         cmd << "-DSWIFT_HOST_VARIANT=macosx"
         cmd << "-DSWIFT_HOST_VARIANT_SDK=OSX"
         if @arch == Arch.host
            cmd << "-DSWIFT_SDKS:STRING='OSX'"
         else
            cmd << "-DSWIFT_SDKS:STRING='ANDROID;OSX'"
         end
         cmd << "-DSWIFT_HOST_TRIPLE:STRING=x86_64-apple-macosx10.12"
      else
         cmd << "-DSWIFT_HOST_VARIANT=linux"
         cmd << "-DSWIFT_HOST_VARIANT_SDK=LINUX"
         if @arch == Arch.host
            cmd << "-DSWIFT_SDKS:STRING='LINUX'"
         else
            cmd << "-DSWIFT_SDKS:STRING='ANDROID;LINUX'"
         end
      end
      cmd << "-DSWIFT_HOST_VARIANT_ARCH=x86_64"
      cmd << "-DLLVM_LIT_ARGS=-sv"
      cmd << "-DCOVERAGE_DB="
      cmd << "-DSWIFT_SOURCEKIT_USE_INPROC_LIBRARY:BOOL=TRUE"
      cmd << "-DSWIFT_DARWIN_XCRUN_TOOLCHAIN:STRING=default"
      cmd << "-DSWIFT_AST_VERIFIER:BOOL=FALSE"
      cmd << "-DSWIFT_SIL_VERIFY_ALL:BOOL=FALSE"
      cmd << "-DSWIFT_RUNTIME_ENABLE_LEAK_CHECKER:BOOL=FALSE"
      cmd << "-DCMAKE_INSTALL_PREFIX:PATH=/usr"
      cmd << "-DSWIFT_PATH_TO_CLANG_SOURCE:PATH=#{llvm.sources}/tools/clang"
      cmd << "-DSWIFT_PATH_TO_CLANG_BUILD:PATH=#{llvm.builds}"
      cmd << "-DSWIFT_PATH_TO_LLVM_SOURCE:PATH=#{llvm.sources}"
      cmd << "-DSWIFT_PATH_TO_LLVM_BUILD:PATH=#{llvm.builds}"
      cmd << "-DSWIFT_PATH_TO_CMARK_SOURCE:PATH=#{cmark.sources}"
      cmd << "-DSWIFT_PATH_TO_CMARK_BUILD:PATH=#{cmark.builds}"
      cmd << "-DSWIFT_PATH_TO_LIBDISPATCH_SOURCE:PATH=#{dispatch.sources}"
      cmd << "-DSWIFT_CMARK_LIBRARY_DIR:PATH=#{cmark.builds}/src"
      cmd << "-DSWIFT_EXEC:STRING=#{@builds}/bin/swiftc"

      cmd << @sources
      execute cmd.join(" ")
      logConfigureCompleted
   end

   def build
      logBuildStarted
      if isMacOS?
         if @arch == Arch.host
            execute "cd #{@builds} && ninja all"
         else
            execute "cd #{@builds} && ninja all swift-test-stdlib-macosx-x86_64 swift-test-stdlib-android-armv7"
         end
      else
         execute "cd #{@builds} && ninja all swift-test-stdlib-linux-x86_64 swift-test-stdlib-android-armv7"
      end
      logBuildCompleted()
   end

   def prepare
      setupLinkerSymLink(false)
      prepareBuilds()
      setupLinkerSymLink()
   end

   def make
      configure
      build
      install
   end

   def install
      logInstallStarted()
      removeInstalls()
      execute "env DESTDIR=#{@installs} cmake --build #{@builds} -- install"
      logInstallCompleted
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/apple/swift.git", "8e38b67d66b41af9062627653963384db0a799eb")
   end

   def clean
      removeBuilds()
      removeInstalls()
      cleanGitRepo()
   end

end
