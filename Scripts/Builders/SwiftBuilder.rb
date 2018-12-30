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

      dispatch = DispatchBuilder.new(@arch)
      llvm = LLVMBuilder.new(@arch)
      ndk = AndroidBuilder.new(@arch)
      icu = ICUBuilder.new(@arch)
      cmark = CMarkBuilder.new(@arch)
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja"

      cmd << "-DCMAKE_C_COMPILER=\"#{llvm.builds}/bin/clang\""
      cmd << "-DCMAKE_CXX_COMPILER=\"#{llvm.builds}/bin/clang++\""

      if isMacOS?
         cmd << "-DCMAKE_LIBTOOL=#{toolchainPath}/usr/bin/libtool"
         cmd << "-DSWIFT_LIPO=#{toolchainPath}/usr/bin/lipo"
         cmd << "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.9"
         cmd << "-DCMAKE_OSX_SYSROOT=#{macOSSDK}"
         cmd << "-DSWIFT_DARWIN_DEPLOYMENT_VERSION_OSX=10.9"
      end
      cmd << "-DSWIFT_STDLIB_ENABLE_SIL_OWNERSHIP=FALSE"
      cmd << "-DSWIFT_ENABLE_GUARANTEED_NORMAL_ARGUMENTS=TRUE"
      cmd << "-DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE"
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
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DSWIFT_BUILD_SOURCEKIT=FALSE"
      cmd << "-DLLVM_ENABLE_ASSERTIONS=TRUE"
      cmd << "-DSWIFT_STDLIB_ASSERTIONS=FALSE"
      cmd << "-DSWIFT_INCLUDE_TOOLS=TRUE"
      cmd << "-DSWIFT_BUILD_REMOTE_MIRROR=TRUE"
      cmd << "-DSWIFT_STDLIB_SIL_DEBUGGING=FALSE"
      cmd << "-DSWIFT_BUILD_DYNAMIC_STDLIB:BOOL=TRUE"
      cmd << "-DSWIFT_BUILD_STATIC_STDLIB:BOOL=FALSE"
      cmd << "-DSWIFT_BUILD_DYNAMIC_SDK_OVERLAY=TRUE"
      cmd << "-DSWIFT_BUILD_STATIC_SDK_OVERLAY=FALSE"
      cmd << "-DSWIFT_BUILD_PERF_TESTSUITE=FALSE"
      cmd << "-DSWIFT_BUILD_EXTERNAL_PERF_TESTSUITE=FALSE"
      cmd << "-DSWIFT_BUILD_EXAMPLES=FALSE"
      cmd << "-DSWIFT_INCLUDE_TESTS=FALSE"
      cmd << "-DSWIFT_INCLUDE_DOCS=FALSE"
      cmd << "-DSWIFT_ENABLE_SOURCEKIT_TESTS=FALSE"
      cmd << "-DSWIFT_INSTALL_COMPONENTS:STRING='autolink-driver;compiler;clang-builtin-headers;stdlib;swift-remote-mirror;sdk-overlay;license'"
      cmd << "-DLIBDISPATCH_CMAKE_BUILD_TYPE:STRING=Release"
      if isMacOS?
         cmd << "-DSWIFT_HOST_VARIANT=macosx"
         cmd << "-DSWIFT_HOST_VARIANT_SDK=OSX"
         if @arch == Arch.host
            cmd << "-DSWIFT_SDKS:STRING='OSX'"
         else
            cmd << "-DSWIFT_SDKS:STRING='ANDROID;OSX'"
            cmd << "-DSWIFT_HOST_TRIPLE:STRING=x86_64-apple-macosx10.9"
         end
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
      cmd << "-DSWIFT_AST_VERIFIER=FALSE"
      cmd << "-DSWIFT_RUNTIME_ENABLE_LEAK_CHECKER:BOOL=FALSE"
      cmd << "-DCMAKE_INSTALL_PREFIX=/usr"
      cmd << "-DSWIFT_PATH_TO_CLANG_SOURCE=#{llvm.sources}/tools/clang"
      cmd << "-DSWIFT_PATH_TO_CLANG_BUILD=#{llvm.builds}"
      cmd << "-DSWIFT_PATH_TO_LLVM_SOURCE=#{llvm.sources}"
      cmd << "-DSWIFT_PATH_TO_LLVM_BUILD=#{llvm.builds}"
      cmd << "-DSWIFT_PATH_TO_CMARK_SOURCE=#{cmark.sources}"
      cmd << "-DSWIFT_PATH_TO_CMARK_BUILD=#{cmark.builds}"
      cmd << "-DSWIFT_PATH_TO_LIBDISPATCH_SOURCE=#{dispatch.sources}"
      cmd << "-DSWIFT_CMARK_LIBRARY_DIR=#{cmark.builds}/src"
      cmd << "-DSWIFT_EXEC:STRING=#{@builds}/bin/swiftc"

      # See: https://gitlab.kitware.com/cmake/community/wikis/doc/cmake/Graphviz
      # cmd << "--graphviz=#{@builds}/graph.dot"
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
