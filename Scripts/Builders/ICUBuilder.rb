require_relative "../Common/Builder.rb"

# See:
# - ICU Patches: https://github.com/amraboelela/swift/blob/android/docs/Android.md
# - Sample Android Project: https://github.com/amraboelela/AmrSwiftAndroid
# - Build ICU for Android: https://gist.github.com/DanielSerdyukov/188d47e29150622352f1
# - Compile swift file to .so library for armeabi-v7a is not recognized by Android: https://bugs.swift.org/browse/SR-5672
# - Cross-building ICU for Applications on Embedded Devices: http://thebugfreeblog.blogspot.com/2013/05/cross-building-icu-for-applications-on.html
# - Packaging ICU4C: http://userguide.icu-project.org/packaging
# - GitHub libiconv-libicu-android: https://github.com/SwiftAndroid/libiconv-libicu-android

class ICUBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.icu, arch)
      @gitRepoRoot = "#{Config.sources}/#{Lib.icu}"
      @sources = "#{@gitRepoRoot}/icu4c"
      @ndk = AndroidBuilder.new(arch)
   end

   def configure
      logConfigureStarted
      host = ICUBuilder.new(Arch.host)
      if @arch != Arch.host && !File.exist?(host.bin)
         message "Building Corss-Build Host."
         host.llvm = llvm
         host.make
         message "Corss-Build Host Build completed."
      end

      prepare
      configurePatches(false)
      cmd = ["cd #{@builds} &&"]
      if @arch != Arch.host
         configurePatches()
      end
      if @arch == Arch.armv7a
         cmd << "CFLAGS='-Os -march=armv7-a -mfloat-abi=softfp -mfpu=neon'"
         cmd << "CXXFLAGS='--std=c++11 -march=armv7-a -mfloat-abi=softfp -mfpu=neon'"
         cmd << "LDFLAGS='-march=armv7-a -Wl,--fix-cortex-a8'"
         cmd << "CC=#{@ndk.toolchain}/bin/armv7a-linux-androideabi#{@ndk.api}-clang"
         cmd << "CXX=#{@ndk.toolchain}/bin/armv7a-linux-androideabi#{@ndk.api}-clang++"
         cmd << "AR=#{@ndk.toolchain}/bin/arm-linux-androideabi-ar"
         cmd << "RINLIB=#{@ndk.toolchain}/bin/arm-linux-androideabi-ranlib"
         cmd << "#{@sources}/source/configure --prefix=#{@installs}"
         cmd << "--host=arm-linux-androideabi"
      elsif @arch == Arch.x86
         cmd << "CFLAGS='-Os -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32'"
         cmd << "CXXFLAGS='--std=c++11 -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32'"
         cmd << "CC=i686-linux-android-clang"
         cmd << "CXX=i686-linux-android-clang++"
         cmd << "AR=i686-linux-android-ar"
         cmd << "RINLIB=i686-linux-android-ranlib"
         cmd << "#{@sources}/source/configure --prefix=#{@installs}"
         cmd << "--host=i686-linux-android"
      elsif @arch == Arch.aarch64
         cmd << "CFLAGS='-Os'"
         cmd << "CXXFLAGS='--std=c++11'"
         cmd << "CC=aarch64-linux-android-clang"
         cmd << "CXX=aarch64-linux-android-clang++"
         cmd << "AR=aarch64-linux-android-ar"
         cmd << "RINLIB=aarch64-linux-android-ranlib"
         cmd << "#{@sources}/source/configure --prefix=#{@installs}"
         cmd << "--host=aarch64-linux-android"
      elsif @arch == Arch.host
         cmd << "CC='#{llvm}/bin/clang'"
         cmd << "CXX='#{llvm}/bin/clang++'"
         cmd << 'CFLAGS="-Os"'
         cmd << 'CXXFLAGS="--std=c++11"'
         cmd << "#{@sources}/source/runConfigureICU Linux --prefix=#{@installs}"
         cmd << "--enable-static --enable-shared=no --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no"
         cmd << "--enable-layoutex=no --enable-tools=no --enable-tests=no --enable-samples=no --enable-dyload=no"
      end
      if @arch != Arch.host
         cmd << "--with-library-suffix=swift"
         cmd << "--enable-static=no --enable-shared --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no --enable-layoutex=no"
         cmd << "--enable-tools=no --enable-tests=no --enable-samples=no --enable-dyload=no"
         cmd << "--with-cross-build=#{host.builds}"
         cmd << "--with-data-packaging=archive"
      end
      execute cmd.join(" ")
      logConfigureCompleted
   end

   def checkout
      checkoutIfNeeded(@gitRepoRoot, "https://github.com/unicode-org/icu.git", Revision.icu)
   end

   def build
      logBuildStarted
      prepare
      cmd = "cd #{@builds} && PATH=#{@ndk.installs}/bin:$PATH make"
      @dryRun ? message(cmd) : execute(cmd)
      logBuildCompleted
   end

   def install
      logInstallStarted()
      removeInstalls()
      cmd = "cd #{@builds} && PATH=#{@ndk.installs}/bin:$PATH make install"
      @dryRun ? message(cmd) : execute(cmd)
      logInstallCompleted
   end

   def make
      configure
      build
      install
      if @arch != Arch.host
         configurePatches(false)
      end
   end

   def configurePatches(shouldEnable = true)
      configurePatch("#{@sources}/source/configure", "#{@patches}/configure.patch", shouldEnable)
   end

   def clean
      if @arch != Arch.host
         ICUBuilder.new(Arch.host).clean
         configurePatches(false)
      end
      removeBuilds()
      cleanGitRepo()
   end

end
