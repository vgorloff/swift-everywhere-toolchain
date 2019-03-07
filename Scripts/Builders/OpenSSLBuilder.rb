require_relative "../Common/Builder.rb"

# See:
# - Compiling the latest OpenSSL for Android: https://stackoverflow.com/questions/11929773/compiling-the-latest-openssl-for-android

class OpenSSLBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.ssl, arch)
   end

   def checkout
      # OpenSSL_1_1_1a: d1c28d791a7391a8dc101713cd8646df96491d03
      checkoutIfNeeded(@sources, "https://github.com/openssl/openssl.git", "d1c28d791a7391a8dc101713cd8646df96491d03")
   end

   def prepare
      # Not used at the moment
      # prepareBuilds()
   end

   def options()
      ndk = AndroidBuilder.new(@arch)
      cmd = ["cd #{@sources} &&"]
      cmd << "ANDROID_NDK=#{ndk.sources}"
      cmd << "PATH=#{ndk.toolchain}/bin:$PATH"
      # >> Seems not needed
      # archFlags = "-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
      # ldFlags = "-march=armv7-a -Wl,--fix-cortex-a8"
      # cmd << "CPPFLAGS=\"#{archFlags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing\""
      # cmd << "CXXFLAGS=\"#{archFlags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -frtti -fexceptions -std=c++11 -Wno-error=unused-command-line-argument\""
      # cmd << "CFLAGS=\"#{archFlags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing\""
      # cmd << "LDFLAGS=\"#{ldFlags}\""
      # <<
      return cmd
   end

   def configure
      logConfigureStarted
      prepare
      ndk = AndroidBuilder.new(@arch)
      # Seems `-D__ANDROID_API__` not needed. See: #{@sources}/NOTES.ANDROID
      execute options.join(" ") + " ./Configure -D__ANDROID_API__=#{ndk.api} --prefix=#{@installs} android-arm"
      logConfigureCompleted
   end

   def build
      logBuildStarted
      prepare
      execute options.join(" ") + " make"
      logBuildCompleted
   end

   def install
      logInstallStarted
      execute options.join(" ") + " make install_sw install_ssldirs"
      logInstallCompleted
   end

   def make
      configure
      build
      install
   end

   def clean
      removeBuilds()
      cleanGitRepo()
   end

end
