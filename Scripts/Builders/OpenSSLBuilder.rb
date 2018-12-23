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
      execute "mkdir -p #{@buildDir}"
      execute "mkdir -p #{@installDir}"
   end

   def configure
      execute commonArgs.join(" ") + " ./Configure -D__ANDROID_API__=#{Config.androidAPI} --prefix=#{@installDir} android-arm"
   end

   def commonArgs()
      ndkToolchainPath = "#{Config.ndkInstallRoot}/#{@target}"
      ndkToolchainBinPath = "#{ndkToolchainPath}/bin"
      archFlags = "-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
      ldFlags = "-march=armv7-a -Wl,--fix-cortex-a8"
      cmd = ["cd #{@sourcesDir} &&"]
      cmd << "ANDROID_NDK=#{ndkToolchainPath}"
      cmd << "PATH=#{ndkToolchainBinPath}:$PATH"
      # >> Seems not needed
      cmd << "CPPFLAGS=\"#{archFlags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing\""
      cmd << "CXXFLAGS=\"#{archFlags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -frtti -fexceptions -std=c++11 -Wno-error=unused-command-line-argument\""
      cmd << "CFLAGS=\"#{archFlags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing\""
      cmd << "LDFLAGS=\"#{ldFlags}\""
      # <<
      return cmd
   end

   def build
      execute commonArgs.join(" ") + " make -j4"
      execute commonArgs.join(" ") + " make install"
   end

   def make
      checkout
      prepare
      configure
      build
   end

end
