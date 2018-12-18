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
      if arch != "linux"
         @host = ICUBuilder.new("linux")
      end
   end

   def configureHost
      cmd = ["cd #{@build} &&"]
      cmd << 'CFLAGS="-Os"'
      cmd << 'CXXFLAGS="--std=c++11"'
      cmd << "#{@sources}/source/runConfigureICU Linux --prefix=#{@install}"
      cmd << "--enable-static --enable-shared=no --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no"
      cmd << "--enable-layoutex=no --enable-tools=no --enable-tests=no --enable-samples=no --enable-dyload=no"
      execute cmd.join(" ")
   end

   def configure
      if !@host.nil? && !File.exist?(@host.build)
         message "Building Corss-Build Host."
         @host.prepare
         @host.configureHost
         @host.compile
         message "Corss-Build Host Build completed."
      end

      cmd = ["cd #{@build} &&"]
      if @arch == Arch.armv7a
         cmd << "PATH=#{@ndk.install}/bin:$PATH"
         cmd << "CFLAGS='-Os -march=armv7-a -mfloat-abi=softfp -mfpu=neon'"
         cmd << "CXXFLAGS='--std=c++11 -march=armv7-a -mfloat-abi=softfp -mfpu=neon'"
         cmd << "LDFLAGS='-march=armv7-a -Wl,--fix-cortex-a8'"
         cmd << "CC=arm-linux-androideabi-clang"
         cmd << "CXX=arm-linux-androideabi-clang++"
         cmd << "AR=arm-linux-androideabi-ar"
         cmd << "RINLIB=arm-linux-androideabi-ranlib"
         cmd << "#{@sources}/source/configure --prefix=#{@install}"
         cmd << "--host=arm-linux-androideabi"
         cmd << "--with-library-suffix=swift"
         cmd << "--enable-static --enable-shared --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no --enable-layoutex=no"
         cmd << "--enable-tools=no --enable-tests=no --enable-samples=no --enable-dyload=no"
         cmd << "--with-cross-build=#{@host.build}"
         cmd << "--with-data-packaging=archive"
      elsif @arch == Arch.x86
         cmd << "PATH=#{@ndk.install}/bin:$PATH"
         cmd << "CFLAGS='-Os -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32'"
         cmd << "CXXFLAGS='--std=c++11 -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32'"
         cmd << "CC=i686-linux-android-clang"
         cmd << "CXX=i686-linux-android-clang++"
         cmd << "AR=i686-linux-android-ar"
         cmd << "RINLIB=i686-linux-android-ranlib"
         cmd << "#{@sources}/source/configure --prefix=#{@install}"
         cmd << "--host=i686-linux-android"
         cmd << "--with-library-suffix=swift"
         cmd << "--enable-static --enable-shared --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no --enable-layoutex=no"
         cmd << "--enable-tools=no --enable-tests=no --enable-samples=no --enable-dyload=no"
         cmd << "--with-cross-build=#{@host.build}"
         cmd << "--with-data-packaging=archive"
      elsif @arch == Arch.aarch64
         cmd << "PATH=#{@ndk.install}/bin:$PATH"
         cmd << "CFLAGS='-Os'"
         cmd << "CXXFLAGS='--std=c++11'"
         cmd << "CC=aarch64-linux-android-clang"
         cmd << "CXX=aarch64-linux-android-clang++"
         cmd << "AR=aarch64-linux-android-ar"
         cmd << "RINLIB=aarch64-linux-android-ranlib"
         cmd << "#{@sources}/source/configure --prefix=#{@install}"
         cmd << "--host=aarch64-linux-android"
         cmd << "--with-library-suffix=swift"
         cmd << "--enable-static --enable-shared --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no --enable-layoutex=no"
         cmd << "--enable-tools=no --enable-tests=no --enable-samples=no --enable-dyload=no"
         cmd << "--with-cross-build=#{@host.build}"
         cmd << "--with-data-packaging=archive"
      end
      execute cmd.join(" ")
   end

   def checkout
      checkoutIfNeeded(@gitRepoRoot, "https://github.com/unicode-org/icu.git")
   end

   def prepare()
      execute "mkdir -p #{@build}"
      applyPatchIfNeeded()
   end

   def applyPatchIfNeeded()
      originalFile = "#{@sources}/source/configure"
      backupFile = "#{@sources}/source/configure.orig"
      patchFile = "#{@patches}/configure.patch"
      if !File.exist? backupFile
         puts "Patching ICU..."
         execute "patch --backup #{originalFile} #{patchFile}"
      else
         puts "Backup file \"#{backupFile}\" exists. Seems you already patched ICU. Skipping..."
      end
   end

   def compile
      execute "cd #{@build} && PATH=#{@ndk.install}/bin:$PATH make -j4"
      execute "cd #{@build} && PATH=#{@ndk.install}/bin:$PATH make install"
   end

   def make()
      prepare
      configure
      compile
   end

   def clean()
      if !@host.nil?
         @host.clean
      end
      execute "rm -rf #{@build}"
      execute "rm -rf #{@install}"
   end

end
