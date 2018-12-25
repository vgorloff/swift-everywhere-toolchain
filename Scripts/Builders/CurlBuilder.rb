require_relative "../Common/Builder.rb"

class CurlBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.curl, arch)
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/curl/curl.git", "7608f9a2d57c26320a35f07d36fe20f6bde92fc4")
   end

   def prepare
      # Unused at the moment.
      # prepareBuilds()
   end

   def configure
      prepare
      # Arguments took from `swift/swift-corelibs-foundation/build-android`
      ndk = AndroidBuilder.new(@arch)
      ssl = OpenSSLBuilder.new(@arch)

      archFlags = "-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
      ldFlags = "-march=armv7-a -Wl,--fix-cortex-a8"
      cmd = ["cd #{@sources} &&"]
      cmd << "PATH=#{ndk.bin}:$PATH"
      cmd << "CC=#{ndk.bin}/arm-linux-androideabi-clang"
      cmd << "CXX=#{ndk.bin}/arm-linux-androideabi-clang++"
      cmd << "AR=#{ndk.bin}/arm-linux-androideabi-ar"
      cmd << "AS=#{ndk.bin}/arm-linux-androideabi-as"
      cmd << "LD=#{ndk.bin}/arm-linux-androideabi-ld"
      cmd << "RANLIB=#{ndk.bin}/arm-linux-androideabi-ranlib"
      cmd << "NM=#{ndk.bin}/arm-linux-androideabi-nm"
      cmd << "STRIP=#{ndk.bin}/arm-linux-androideabi-strip"
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
      cmd << "--with-zlib=#{ndk.installs}/usr/sysroot --with-ssl=#{ssl.installs} --prefix=#{@installs}"
      execute cmd.join(" ")
      logConfigureCompleted
   end

   def build
      prepare
      execute "cd #{@sources} && make"
      logBuildCompleted
   end

   def install
      execute "cd #{@sources} && make install"
      logInstallCompleted
   end

   def make
      configure
      build
      install
   end

end
