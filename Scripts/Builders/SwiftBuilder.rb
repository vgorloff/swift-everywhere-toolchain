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

   def compileNew
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

   def compile
      puts "Implement Me"
   end

   def prepare
      targetFile = "/usr/bin/armv7-none-linux-androideabi-ld.gold"
      if File.exist?(targetFile)
         return
      end
      puts "Making symbolic link to \"#{targetFile}\"..."
      cmd = ["sudo"]
      cmd << "ln -svf #{@ndk.sources}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/arm-linux-androideabi/bin/ld.gold"
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

   def clean
      execute "rm -rf #{@build}"
      execute "rm -rf #{@install}"
   end

end
