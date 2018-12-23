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
      if arch != Arch.host
         @host = ICUBuilder.new(Arch.host)
      end
   end

   def configureHost
      prepare
      applyPatchIfNeeded(false)
      cmd = ["cd #{@builds} &&"]
      cmd << 'CC="/usr/bin/clang"'
      cmd << 'CXX="/usr/bin/clang++"'
      cmd << 'CFLAGS="-Os"'
      cmd << 'CXXFLAGS="--std=c++11"'
      cmd << "#{@sources}/source/runConfigureICU Linux --prefix=#{@installs}"
      cmd << "--enable-static --enable-shared=no --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no"
      cmd << "--enable-layoutex=no --enable-tools=no --enable-tests=no --enable-samples=no --enable-dyload=no"
      execute cmd.join(" ")
   end

   def configure
      if !@host.nil? && !File.exist?(@host.bin)
         message "Building Corss-Build Host."
         @host.configureHost
         @host.build
         @host.install
         message "Corss-Build Host Build completed."
      end

      prepare
      applyPatchIfNeeded(false)
      applyPatchIfNeeded
      cmd = ["cd #{@builds} &&"]
      cmd << "PATH=#{@ndk.installs}/bin:$PATH"
      if @arch == Arch.armv7a
         cmd << "CFLAGS='-Os -march=armv7-a -mfloat-abi=softfp -mfpu=neon'"
         cmd << "CXXFLAGS='--std=c++11 -march=armv7-a -mfloat-abi=softfp -mfpu=neon'"
         cmd << "LDFLAGS='-march=armv7-a -Wl,--fix-cortex-a8'"
         cmd << "CC=arm-linux-androideabi-clang"
         cmd << "CXX=arm-linux-androideabi-clang++"
         cmd << "AR=arm-linux-androideabi-ar"
         cmd << "RINLIB=arm-linux-androideabi-ranlib"
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
      end
      cmd << "--with-library-suffix=swift"
      cmd << "--enable-static --enable-shared --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no --enable-layoutex=no"
      cmd << "--enable-tools=no --enable-tests=no --enable-samples=no --enable-dyload=no"
      cmd << "--with-cross-build=#{@host.builds}"
      cmd << "--with-data-packaging=archive"
      execute cmd.join(" ")
      logConfigureCompleted
   end

   def checkout
      checkoutIfNeeded(@gitRepoRoot, "https://github.com/unicode-org/icu.git", "2e86b08fcda87e279efdcb8f9f3310cb6b9150af")
   end

   def prepare()
      execute "mkdir -p #{@builds}"
   end

   def applyPatchIfNeeded(shouldApply = true)
      originalFile = "#{@sources}/source/configure"
      backupFile = "#{@sources}/source/configure.orig"
      patchFile = "#{@patches}/configure.patch"
      if shouldApply
         if !File.exist? backupFile
            puts "Patching ICU..."
            execute "patch --backup #{originalFile} #{patchFile}"
         else
            puts "Backup file \"#{backupFile}\" exists. Seems you already patched ICU. Skipping..."
         end
      else
         message "Removing previously applied patch..."
         execute "cd \"#{@gitRepoRoot}\" && git checkout #{originalFile}"
         if File.exist? backupFile
            execute "rm -fv #{backupFile}"
         end
      end
   end

   def build
      prepare
      execute "cd #{@builds} && PATH=#{@ndk.installs}/bin:$PATH make -j4"
      logBuildCompleted
   end

   def install
      execute "cd #{@builds} && PATH=#{@ndk.installs}/bin:$PATH make install"
      logInstallCompleted
   end

   def make
      configure
      build
      install
   end

   def clean
      if !@host.nil?
         @host.clean
      end
      execute "rm -rf #{@builds}"
      execute "rm -rf #{@installs}"
   end

end
