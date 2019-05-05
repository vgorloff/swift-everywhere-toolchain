require_relative "../Common/Builder.rb"

# See also:
# - Build Curl for Android NDK: https://gist.github.com/bertrandmartel/d964444f4a85c2598053

class CurlBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.curl, arch)
      @ndk = NDK.new()
      @ssl = OpenSSLBuilder.new(@arch)
   end

   def prepare
      # Unused at the moment.
   end

   def executeConfigure
      clean()
      # Arguments took from `swift/swift-corelibs-foundation/build-android`
      archFlags = "-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
      ldFlags = "-march=armv7-a -Wl,--fix-cortex-a8"
      cmd = ["cd #{@sources} &&"]
      cmd << "CC=#{@ndk.toolchain}/bin/armv7a-linux-androideabi#{@ndk.api}-clang"
      cmd << "CXX=#{@ndk.toolchain}/bin/armv7a-linux-androideabi#{@ndk.api}-clang++"
      cmd << "AR=#{@ndk.toolchain}/bin/arm-linux-androideabi-ar"
      cmd << "AS=#{@ndk.toolchain}/bin/arm-linux-androideabi-as"
      cmd << "LD=#{@ndk.toolchain}/bin/arm-linux-androideabi-ld"
      cmd << "RANLIB=#{@ndk.toolchain}/bin/arm-linux-androideabi-ranlib"
      cmd << "NM=#{@ndk.toolchain}/bin/arm-linux-androideabi-nm"
      cmd << "STRIP=#{@ndk.toolchain}/bin/arm-linux-androideabi-strip"
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
      cmd << "--with-zlib=#{@ndk.sources}/usr/sysroot --with-ssl=#{@ssl.installs} --prefix=#{@installs}"
      execute cmd.join(" ")
   end

   def executeBuild
      execute "cd #{@sources} && make"
   end

   def executeInstall
      execute "cd #{@sources} && make install"
   end

end
