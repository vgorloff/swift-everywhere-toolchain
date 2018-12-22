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
      # @cmark = CMarkBuilder.new(arch)
      # @llvm = LLVMBuilder.new(arch)
      # @clang = ClangBuilder.new(arch)
      # @dispatch = DispatchBuilder.new(arch)
   end

   def compileOLD
      cmd = ["cd #{@sources} &&"]
      # To avoid issue:
      # /usr/bin/ld.gold: fatal error: /vagrant/Sources/ndk/platforms/android-21/arch-arm/usr/lib/../lib/crtbegin_so.o: unsupported ELF machine number 40
      cmd << "env PATH=#{@ndk.install}/arm-linux-androideabi/bin:$PATH"

      cmd << "./swift/utils/build-script --release --android"
      cmd << "--android-ndk #{@ndk.sources}"
      cmd << "--android-api-level #{@ndk.api}"
      cmd << "--android-icu-uc #{@icu.lib}/libicuucswift.so"
      cmd << "--android-icu-uc-include #{@icu.sources}/source/common"
      cmd << "--android-icu-i18n #{@icu.lib}/libicui18nswift.so"
      cmd << "--android-icu-i18n-include #{@icu.sources}/source/i18n"
      cmd << "--android-icu-data #{@icu.lib}/libicudataswift.so"
      cmd << "--libdispatch --install-libdispatch"
      cmd << "--foundation --install-foundation"
      cmd << "--install-prefix=/usr"
      cmd << "--install-destdir=#{@install}"
      cmd << "--build-dir #{@build}"
      execute cmd.join(" ")
   end

   def compileOld2
      cmd = ["cd #{@sources} &&"]
      cmd << "./swift/utils/build-script --release --android"
      cmd << "--android-ndk #{@ndk.sources}"
      cmd << "--android-api-level #{@ndk.api}"
      cmd << "--android-icu-uc #{@icu.lib}/libicuucswift.so"
      cmd << "--android-icu-uc-include #{@icu.sources}/source/common"
      cmd << "--android-icu-i18n #{@icu.lib}/libicui18nswift.so"
      cmd << "--android-icu-i18n-include #{@icu.sources}/source/i18n"
      cmd << "--android-icu-data #{@icu.lib}/libicudataswift.so"
      cmd << "--libdispatch --install-libdispatch"
      cmd << "--foundation --install-foundation"
      cmd << "--llbuild --install-llbuild"
      cmd << "--lldb --install-lldb"
      cmd << "--swiftpm --install-swiftpm"
      cmd << "--xctest --install-xctest"
      cmd << "--install-swift"
      cmd << "'--swift-install-components=autolink-driver;compiler;clang-builtin-headers;stdlib;swift-remote-mirror;sdk-overlay;dev'"
      cmd << "--install-prefix=/usr"
      cmd << "--install-destdir=#{@install}"
      cmd << "--build-dir #{@build}"
      execute cmd.join(" ")
   end

   def configureOld
      prepare
      # See: SWIFT_GIT_ROOT/docs/WindowsBuild.md
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja"

      # cmd << "-DCMAKE_C_COMPILER=\"#{@llvm.bin}/clang\""
      # cmd << "-DCMAKE_CXX_COMPILER=\"#{@llvm.bin}/clang++\""

      cmd << "-DCMAKE_C_COMPILER=/usr/bin/clang"
      cmd << "-DCMAKE_CXX_COMPILER=/usr/bin/clang++"

      # See:
      # - https://stackoverflow.com/questions/10712972/what-is-the-use-of-fno-stack-protector
      # - https://reviews.llvm.org/D34264
      # - https://bugzilla.mozilla.org/show_bug.cgi?id=731316
      cFlags = "-Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector"
      cmd << "-DCMAKE_C_FLAGS=\"#{cFlags}\""
      cmd << "-DCMAKE_CXX_FLAGS=\"#{cFlags}\""

      # cmd << "-DCLANG_VERSION_MAJOR=\"7\" -DCLANG_VERSION_MINOR=\"0\" -DCLANG_VERSION_PATCH=\"0\""

      # cmd << "-DCMAKE_CXX_FLAGS="-Wno-c++98-compat -Wno-c++98-compat-pedantic"^
      # cmd << "-DCMAKE_EXE_LINKER_FLAGS:STRING="/INCREMENTAL:NO"^
      # cmd << "-DCMAKE_SHARED_LINKER_FLAGS="/INCREMENTAL:NO"^
      cmd << "-DCMAKE_INSTALL_PREFIX=\"#{@installs}\""
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DSWIFT_INCLUDE_TESTS=NO"
      cmd << "-DSWIFT_INCLUDE_DOCS=NO"
      cmd << "-DSWIFT_BUILD_SOURCEKIT=NO"
      cmd << "-DSWIFT_BUILD_SYNTAXPARSERLIB=NO"

      # Making Ninja verbose. See: https://github.com/ninja-build/ninja/issues/900#issuecomment-132346047
      # cmd << "-DCMAKE_VERBOSE_MAKEFILE=ON"

      cmd << "-DSWIFT_PATH_TO_LLVM_SOURCE=\"#{@llvm.sources}\""
      cmd << "-DSWIFT_PATH_TO_LLVM_BUILD=\"#{@llvm.builds}\""

      cmd << "-DSWIFT_PATH_TO_CMARK_SOURCE=\"#{@cmark.sources}\""
      cmd << "-DSWIFT_PATH_TO_CMARK_BUILD=\"#{@cmark.builds}\""
      cmd << "-DSWIFT_CMARK_LIBRARY_DIR=\"#{@cmark.lib}\""

      cmd << "-DSWIFT_SDKS=LINUX"

      # Seems these vars is unused.
      cmd << "-DSWIFT_EXEC=#{@builds}/bin/swiftc"
      cmd << "-DLIBDISPATCH_CMAKE_BUILD_TYPE=Release"

      # cmd << "-DSWIFT_PATH_TO_CLANG_SOURCE=\"#{@clang.sources}\""
      cmd << "-DSWIFT_PATH_TO_LIBDISPATCH_SOURCE=\"#{@dispatch.sources}\""
      # cmd << "-DSWIFT_PATH_TO_CLANG_BUILD=\"#{@llvm.builds}\""
      # cmd << "-DLLVM_BUILD_LIBRARY_DIR=\"#{@llvm.lib}\""
      # cmd << "-DLLVM_BUILD_MAIN_INCLUDE_DIR=\"#{@llvm.include}\""
      # cmd << "-DLLVM_BUILD_BINARY_DIR=\"#{@llvm.bin}\""
      # cmd << "-DLLVM_BUILD_MAIN_SRC_DIR=\"#{@llvm.sources}\""

      # Both lines not needed after setting C/CXX compillers
      # cmd << "-DCMAKE_PREFIX_PATH=#{@llvm.lib}/cmake/clang"
      # cmd << "-DClang_DIR=#{@llvm.lib}/cmake/clang"
      #
      # -DSWIFT_WINDOWS_x86_64_ICU_UC_INCLUDE="%swift_source_dir%/icu/include"^
      # -DSWIFT_WINDOWS_x86_64_ICU_UC="%swift_source_dir%/icu/lib64/icuuc.lib"^
      # -DSWIFT_WINDOWS_x86_64_ICU_I18N_INCLUDE="%swift_source_dir%/icu/include"^
      # -DSWIFT_WINDOWS_x86_64_ICU_I18N="%swift_source_dir%/icu/lib64/icuin.lib"^
      cmd << @sources
      execute cmd.join(" ")
      logConfigureCompleted
   end

   def build
      cmd = ["cd #{@sources} &&"]
      cmd << "./utils/build-script --release --skip-reconfigure"
      cmd << "--assertions --no-swift-stdlib-assertions --swift-enable-ast-verifier=0"
      # cmd << "--android"
      # cmd << "--android-ndk #{@ndk.sources}"
      # cmd << "--android-api-level #{@ndk.api}"
      # cmd << "--android-icu-uc #{@icu.lib}/libicuucswift.so"
      # cmd << "--android-icu-uc-include #{@icu.sources}/source/common"
      # cmd << "--android-icu-i18n #{@icu.lib}/libicui18nswift.so"
      # cmd << "--android-icu-i18n-include #{@icu.sources}/source/i18n"
      # cmd << "--android-icu-data #{@icu.lib}/libicudataswift.so"
      cmd << "--install-swift"
      cmd << "--libdispatch --install-libdispatch"
      cmd << "--foundation --install-foundation"
      cmd << "--build-swift-static-stdlib --build-swift-static-sdk-overlay"
      cmd << "--skip-test-cmark --skip-test-lldb --skip-test-swift --skip-test-llbuild --skip-test-swiftpm --skip-test-xctest"
      cmd << "--skip-test-foundation --skip-test-libdispatch --skip-test-playgroundsupport --skip-test-libicu"
      # cmd << "--llbuild --install-llbuild"
      # cmd << "--lldb --install-lldb"
      # cmd << "--swiftpm --install-swiftpm"
      # cmd << "--xctest --install-xctest"
      cmd << "'--swift-install-components=autolink-driver;compiler;clang-builtin-headers;stdlib;swift-remote-mirror;sdk-overlay;license;sourcekit-inproc'"
      cmd << "'--llvm-install-components=llvm-cov;llvm-profdata;IndexStore'"
      cmd << "--install-prefix=/usr"
      cmd << "--install-destdir=#{@installs}"
      cmd << "--build-dir #{@builds}"
      execute cmd.join(" ")
      logBuildCompleted()
   end

   def prepare
      execute "mkdir -p #{@builds}"
      # Fix for missed file: `CMake Error at cmake/modules/SwiftSharedCMakeConfig.cmake:196 (include):`
      # execute "touch \"#{@cmark.builds}/src/CMarkExports.cmake\""

      # targetFile = "/usr/bin/armv7-none-linux-androideabi-ld.gold"
      # if File.exist?(targetFile)
      #    return
      # end
      # puts "Making symbolic link to \"#{targetFile}\"..."
      # cmd = ["sudo"]
      # cmd << "ln -svf #{@ndk.sources}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/arm-linux-androideabi/bin/ld.gold"
      # cmd << targetFile
      # execute cmd.join(" ")
      # execute "ls -a /usr/bin/*ld.gold"
   end

   def make
      prepare
      build
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/apple/swift.git")
   end

   def clean
      execute "rm -rf #{@builds}"
      execute "rm -rf #{@installs}"
   end

end
