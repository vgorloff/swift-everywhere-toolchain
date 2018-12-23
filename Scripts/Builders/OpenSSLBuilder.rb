require_relative "../Common/Builder.rb"

# See:
# - Compiling the latest OpenSSL for Android: https://stackoverflow.com/questions/11929773/compiling-the-latest-openssl-for-android

class OpenSSLBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.ssl, arch)
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/openssl/openssl.git", "cf1698cb9137de7fa4681f5babbdcb464ed1c70d")
   end

   def prepare
      # Not used at the moment
      # execute "mkdir -p #{@builds}"
   end

   def options()
      ndk = AndroidBuilder.new(@arch)
      cmd = ["cd #{@sources} &&"]
      cmd << "ANDROID_NDK=#{ndk.installs}"
      cmd << "PATH=#{ndk.bin}:$PATH"
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
      prepare
      ndk = AndroidBuilder.new(@arch)
      # Seems `-D__ANDROID_API__` not needed. See: #{@sources}/NOTES.ANDROID
      execute options.join(" ") + " ./Configure -D__ANDROID_API__=#{ndk.api} --prefix=#{@installs} android-arm"
   end

   def build
      prepare
      execute options.join(" ") + " make -j4"
   end

   def install
      execute options.join(" ") + " make install_sw install_ssldirs"
   end

   def make
      configure
      build
   end

end
