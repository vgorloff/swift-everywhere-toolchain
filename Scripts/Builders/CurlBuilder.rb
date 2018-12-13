require_relative "../Common/Builder.rb"
require_relative "../Common/Config.rb"

class CurlBuilder < Builder

   def initialize(target = "armv7a")
      super()
      @target = target
      @sourcesDir = Config.curlSourcesRoot
      @buildDir = Config.buildRoot + "/curl/" + @target
      @installDir = Config.installRoot + "/curl/" + @target
   end

   def checkout
      checkoutIfNeeded(@sourcesDir, "https://github.com/curl/curl.git")
   end

   def prepare
      execute "mkdir -p #{@buildDir}"
      execute "mkdir -p #{@installDir}"
   end

   def commonArgs()

   end

   def configure
      # Arguments took from `swift/swift-corelibs-foundation/build-android`
      ndkToolchainPath = "#{Config.ndkInstallRoot}/#{@target}"
      ndkToolchainBinPath = "#{ndkToolchainPath}/bin"
      ndkToolchainSysPath = "#{ndkToolchainPath}/sysroot"
      archFlags = "-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
      ldFlags = "-march=armv7-a -Wl,--fix-cortex-a8"
      cmd = ["cd #{@sourcesDir} &&"]
      cmd << "PATH=#{ndkToolchainBinPath}:$PATH"
      cmd << "CC=#{ndkToolchainBinPath}/arm-linux-androideabi-clang"
      cmd << "CXX=#{ndkToolchainBinPath}/arm-linux-androideabi-clang++"
      cmd << "AR=#{ndkToolchainBinPath}/arm-linux-androideabi-ar"
      cmd << "AS=#{ndkToolchainBinPath}/arm-linux-androideabi-as"
      cmd << "LD=#{ndkToolchainBinPath}/arm-linux-androideabi-ld"
      cmd << "RANLIB=#{ndkToolchainBinPath}/arm-linux-androideabi-ranlib"
      cmd << "NM=#{ndkToolchainBinPath}/arm-linux-androideabi-nm"
      cmd << "STRIP=#{ndkToolchainBinPath}/arm-linux-androideabi-strip"
      cmd << "CHOST=arm-linux-androideabi"
      cmd << "CPPFLAGS=\"#{archFlags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing\""
      cmd << "CXXFLAGS=\"#{archFlags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -frtti -fexceptions -std=c++11 -Wno-error=unused-command-line-argument\""
      cmd << "CFLAGS=\"#{archFlags} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing\""
      cmd << "LDFLAGS=\"#{ldFlags}\""
      execute cmd.join(" ") + " autoreconf -i"

      cmd << "./configure"
      cmd << "--host=arm-linux-androideabi --enable-shared --disable-static --disable-dependency-tracking --without-ca-bundle --without-ca-path --enable-ipv6 --enable-http --enable-ftp"
      cmd << "--disable-file --disable-ldap --disable-ldaps --disable-rtsp --disable-proxy --disable-dict --disable-telnet --disable-tftp --disable-pop3 --disable-imap --disable-smtp --disable-gopher --disable-sspi --disable-manual"
      cmd << "--target=arm-linux-androideabi --build=x86_64-unknown-linux-gnu"
      cmd << "--with-zlib=#{ndkToolchainSysPath}/usr --with-ssl=#{Config.opensslSourcesRoot} --prefix=#{@installDir}"
      execute cmd.join(" ")
   end

   def build
      execute "cd #{@sourcesDir} && make"
      execute "cd #{@sourcesDir} && make install"
   end

   def make
      checkout
      prepare
      configure
      build
   end

end
