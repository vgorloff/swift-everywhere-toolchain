require_relative "../Common/Builder.rb"

=begin

Compiling swift on Linux: https://akrabat.com/compiling-swift-on-linux/

# See:
# 1. Building the Swift stdlib for Android – https://github.com/amraboelela/swift/blob/android/docs/Android.md
# 2. fuchsia build – https://fuchsia.googlesource.com/third_party/swift-corelibs-foundation/+/upstream/google/build-android
# 3. Port to Android Patch – https://github.com/SwiftAndroid/swift/commit/7c502b6344a240c8e06c5e48e5ab6fa32c887ab3
# 4. Using Swift to Build Code for Android – https://www.infoq.com/news/2016/04/swift-for-android
# 5. Issue with lg.gold – https://bugs.swift.org/browse/SR-1264?page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel&showAll=true
# 6. Ussue with ld.gold – https://github.com/apple/swift/commit/d49d88e53d15b6cba00950ec7985df4631e24312
# 7. Cross compile Apps on Mac for Linux: https://github.com/apple/swift-package-manager/blob/master/Utilities/build_ubuntu_cross_compilation_toolchain
# 8. Swift cross compile on Rasperi Pi: https://stackoverflow.com/a/44003655/1418981
# 9. Java and Swift interoperability: https://medium.com/@michiamling/android-app-with-java-native-interface-for-swift-c9c322609e08
# 10. /Sources/Swift/swift/utils/android/build-toolchain

Swift in Java.

- https://romain.goyet.com/articles/running_swift_code_on_android/
- https://www.reddit.com/r/swift/comments/3w0xrd/im_patching_the_opensource_swift_compiler_to/
- https://github.com/flowkey/UIKit-cross-platform
- https://github.com/flowkey/swift-android-toolchain
- https://blog.readdle.com/why-we-use-swift-for-android-db449feeacaf


~~OLD

./swift/utils/build-script --show-presets (see also swift/utils/build-presets.ini)

5. Build: ./swift/utils/build-script --preset=buildbot_linux installable_package=~/swift.tar.gz install_destdir=~/swift-install
5. Build: ./swift/utils/build-script --preset=buildbot_linux,no_test installable_package=~/swift.tar.gz install_destdir=~/swift-install

# ./swift/utils/build-script
# --assertions --no-swift-stdlib-assertions --swift-enable-ast-verifier=0
# --llbuild --swiftpm --xctest --libicu --build-ninja --install-swift --install-lldb --install-llbuild
# --install-swiftpm --install-xctest --install-libicu
# --install-prefix=/usr '--swift-install-components=autolink-driver;compiler;clang-builtin-headers;stdlib;swift-remote-mirror;sdk-overlay;license;sourcekit-inproc'
# '--llvm-install-components=llvm-cov;llvm-profdata;IndexStore'
# --build-swift-static-stdlib --build-swift-static-sdk-overlay --build-swift-stdlib-unittest-extra
# --test-installable-package
# --install-destdir=/home/user/Developer/Install/swift/swift5-android
# --installable-package=/home/user/Developer/Install/swift/swift5-android.tar.gz
# --build-subdir=buildbot_linux --lldb --release

=end

class SwiftBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.swift, arch)
      @icu = ICUBuilder.new(arch)
      @ndk = AndroidBuilder.new(arch)
   end

   def compileOLD
      cmd = ["cd #{@sources} &&"]
      cmd << "./swift/utils/build-script --release --android"
      cmd << "--android-ndk #{@ndk.sources}"
      cmd << "--android-api-level #{@ndk.api}"
      cmd << "--android-icu-uc #{@icu.lib}/libicuucswift.so"
      cmd << "--android-icu-uc-include #{@icu.sources}/source/common"
      cmd << "--android-icu-i18n #{@icu.lib}/libicui18nswift.so"
      cmd << "--android-icu-i18n-include #{@icu.sources}/source/i18n"
      cmd << "--android-icu-data #{@icu.lib}/libicudataswift.so"
      # cmd << "--foundation --libdispatch" # Needs to be compiled separately.
      cmd << "--build-dir #{@build}"
      execute cmd.join(" ")
   end

   def compile
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

   def prepare
      targetFile = "/usr/bin/armv7-none-linux-androideabi-ld.gold"
      if File.exist?(targetFile)
         return
      end

      puts "Making symbolic link to \"#{targetFile}\"..."
      cmd = ["sudo"]
      cmd << "ln -s #{Config.ndkSourcesRoot}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/arm-linux-androideabi/bin/ld.gold"
      cmd << targetFile
      execute cmd.join(" ")
      execute "ls -a /usr/bin/*ld.gold"
   end

   def make
      # prepare
      compile
   end

   def help
      execute "cd #{@sources} && ./swift/utils/build-script --help | more"
   end

   def update
      execute "cd #{@sources} && ./swift/utils/update-checkout"
   end

   def checkout
      dir = @sources + "/swift"
      checkoutIfNeeded(dir, "https://github.com/apple/swift.git")
      execute "cd \"#{dir}\" && ./swift/utils/update-checkout --clone"
      message "#{Lib.swift} checkout completed."
   end

end
