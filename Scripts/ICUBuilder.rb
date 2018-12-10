require_relative "Builder.rb"
require_relative "Config.rb"

# See:
# - ICU Patches: https://github.com/amraboelela/swift/blob/android/docs/Android.md
# - Sample Android Project: https://github.com/amraboelela/AmrSwiftAndroid
# - Build ICU for Android: https://gist.github.com/DanielSerdyukov/188d47e29150622352f1
# - Compile swift file to .so library for armeabi-v7a is not recognized by Android: https://bugs.swift.org/browse/SR-5672
# - Cross-building ICU for Applications on Embedded Devices: http://thebugfreeblog.blogspot.com/2013/05/cross-building-icu-for-applications-on.html
# - Packaging ICU4C: http://userguide.icu-project.org/packaging
# - GitHub libiconv-libicu-android: https://github.com/SwiftAndroid/libiconv-libicu-android

class ICUBuilder < Builder

   def initialize(target)
      super()
      @target = target
      @buildDir = Config.buildRoot + "/icu/" + @target
      @prefixDir = Config.installRoot + "/icu/" + @target
   end

   def configure
      cmd = ["cd #{@buildDir} &&"]
      if @target == "linux"
         cmd << 'CFLAGS="-Os"'
         cmd << 'CXXFLAGS="--std=c++11"'
         cmd << "#{Config.icuSources}/source/runConfigureICU Linux --prefix=#{@prefixDir}"
         cmd << "--enable-static --enable-shared=no --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no"
         cmd << "--enable-layoutex=no --enable-tools=no --enable-tests=no --enable-samples=no --enable-dyload=no"
      elsif @target == "armv7a"
         cmd << "PATH=#{Config.installRoot}/android/#{@target}/bin:$PATH"
         cmd << "CFLAGS='-Os -march=armv7-a -mfloat-abi=softfp -mfpu=neon'"
         cmd << "CXXFLAGS='--std=c++11 -march=armv7-a -mfloat-abi=softfp -mfpu=neon'"
         cmd << "LDFLAGS='-march=armv7-a -Wl,--fix-cortex-a8'"
         cmd << "CC=arm-linux-androideabi-clang"
         cmd << "CXX=arm-linux-androideabi-clang++"
         cmd << "AR=arm-linux-androideabi-ar"
         cmd << "RINLIB=arm-linux-androideabi-ranlib"
         cmd << "#{Config.icuSources}/source/configure --prefix=#{@prefixDir}"
         cmd << "--host=arm-linux-androideabi"
         cmd << "--with-library-suffix=swift"
         cmd << "--enable-static --enable-shared --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no --enable-layoutex=no"
         cmd << "--enable-tools=no --enable-tests=no --enable-samples=no --enable-dyload=no"
         cmd << "--with-cross-build=#{Config.buildRoot}/icu/linux"
         cmd << "--with-data-packaging=archive"
      elsif @target == "x86"
         cmd << "PATH=#{Config.installRoot}/android/#{@target}/bin:$PATH"
         cmd << "CFLAGS='-Os -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32'"
         cmd << "CXXFLAGS='--std=c++11 -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32'"
         cmd << "CC=i686-linux-android-clang"
         cmd << "CXX=i686-linux-android-clang++"
         cmd << "AR=i686-linux-android-ar"
         cmd << "RINLIB=i686-linux-android-ranlib"
         cmd << "#{Config.icuSources}/source/configure --prefix=#{@prefixDir}"
         cmd << "--host=i686-linux-android"
         cmd << "--with-library-suffix=swift"
         cmd << "--enable-static --enable-shared --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no --enable-layoutex=no"
         cmd << "--enable-tools=no --enable-tests=no --enable-samples=no --enable-dyload=no"
         cmd << "--with-cross-build=#{Config.buildRoot}/icu/linux"
         cmd << "--with-data-packaging=archive"
      elsif @target == "aarch64"
         cmd << "PATH=#{Config.installRoot}/android/#{@target}/bin:$PATH"
         cmd << "CFLAGS='-Os'"
         cmd << "CXXFLAGS='--std=c++11'"
         cmd << "CC=aarch64-linux-android-clang"
         cmd << "CXX=aarch64-linux-android-clang++"
         cmd << "AR=aarch64-linux-android-ar"
         cmd << "RINLIB=aarch64-linux-android-ranlib"
         cmd << "#{Config.icuSources}/source/configure --prefix=#{@prefixDir}"
         cmd << "--host=aarch64-linux-android"
         cmd << "--with-library-suffix=swift"
         cmd << "--enable-static --enable-shared --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no --enable-layoutex=no"
         cmd << "--enable-tools=no --enable-tests=no --enable-samples=no --enable-dyload=no"
         cmd << "--with-cross-build=#{Config.buildRoot}/icu/linux"
         cmd << "--with-data-packaging=archive"
      end
      execute cmd.join(" ")
   end

   def prepare()
      execute "mkdir -p #{@buildDir}"
      applyPatchIfNeeded()
   end

   def applyPatchIfNeeded()
      originalFile = "#{Config.icuSources}/source/configure"
      backupFile = "#{Config.icuSources}/source/configure.orig"
      patchFile = "#{Config.icuPatchesDir}/configure.patch"
      if !File.exist? backupFile
         execute "patch --backup #{originalFile} #{patchFile}"
      end
   end

   def build
      execute "cd #{@buildDir} && PATH=#{Config.installRoot}/android/#{@target}/bin:$PATH make -j4"
      execute "cd #{@buildDir} && PATH=#{Config.installRoot}/android/#{@target}/bin:$PATH make install"
   end

   def make()
      prepare
      configure
      build
   end

   def clean()
      execute "rm -rf #{Config.buildRoot}/icu/"
      execute "rm -rf #{Config.installRoot}/icu/"
   end

end
