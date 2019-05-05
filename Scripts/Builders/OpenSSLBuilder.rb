require_relative "../Common/Builder.rb"

# See:
# - Compiling the latest OpenSSL for Android: https://stackoverflow.com/questions/11929773/compiling-the-latest-openssl-for-android

class OpenSSLBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.ssl, arch)
      @ndk = NDK.new()
   end

   def prepare
      # Not used at the moment
   end

   def options()
      cmd = ["cd #{@sources} &&"]
      cmd << "ANDROID_NDK=#{@ndk.sources}"
      cmd << "PATH=#{@ndk.toolchain}/bin:$PATH"
      return cmd
   end

   def executeConfigure
      clean()
      # Seems `-D__ANDROID_API__` not needed. See: #{@sources}/NOTES.ANDROID
      commonArgs = options.join(" ") + " ./Configure -D__ANDROID_API__=#{@ndk.api} --prefix=#{@installs}"
      if @arch == Arch.armv7a
         execute "#{commonArgs} android-arm"
      elsif @arch == Arch.x86
         execute "#{commonArgs} android-x86"
      elsif @arch == Arch.aarch64
         execute "#{commonArgs} android-arm64"
      end
   end

   def executeBuild
      execute options.join(" ") + " make SHLIB_VERSION_NUMBER= SHLIB_EXT=.so"
   end

   def executeInstall
      execute options.join(" ") + " make SHLIB_VERSION_NUMBER= SHLIB_EXT=.so install_sw install_ssldirs"
   end

end
