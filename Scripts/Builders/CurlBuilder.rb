require_relative "../Common/Builder.rb"

# See also:
# - Build Curl for Android NDK: https://gist.github.com/bertrandmartel/d964444f4a85c2598053
# - Static libcurl to be used in Android and iOS apps: https://github.com/gcesarmza/curl-android-ios

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
      cmd = ["cd #{@sources} &&"]
      if @arch == Arch.armv7a
         archFlags = "-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
         cmd << "CC=#{@ndk.toolchain}/bin/armv7a-linux-androideabi#{@ndk.api}-clang"
         cmd << "CXX=#{@ndk.toolchain}/bin/armv7a-linux-androideabi#{@ndk.api}-clang++"
         cmd << "AR=#{@ndk.toolchain}/bin/arm-linux-androideabi-ar"
         cmd << "AS=#{@ndk.toolchain}/bin/arm-linux-androideabi-as"
         cmd << "LD=#{@ndk.toolchain}/bin/arm-linux-androideabi-ld"
         cmd << "RANLIB=#{@ndk.toolchain}/bin/arm-linux-androideabi-ranlib"
         cmd << "NM=#{@ndk.toolchain}/bin/arm-linux-androideabi-nm"
         cmd << "STRIP=#{@ndk.toolchain}/bin/arm-linux-androideabi-strip"
         cmd << "CHOST=arm-linux-androideabi"
         cmd << "LDFLAGS=\"-march=armv7-a -Wl,--fix-cortex-a8\""
      elsif @arch == Arch.x86
         archFlags = "-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"
         cmd << "CC=#{@ndk.toolchain}/bin/i686-linux-android#{@ndk.api}-clang"
         cmd << "CXX=#{@ndk.toolchain}/bin/i686-linux-android#{@ndk.api}-clang++"
         cmd << "AR=#{@ndk.toolchain}/bin/i686-linux-android-ar"
         cmd << "AS=#{@ndk.toolchain}/bin/i686-linux-android-as"
         cmd << "LD=#{@ndk.toolchain}/bin/i686-linux-android-ld"
         cmd << "RANLIB=#{@ndk.toolchain}/bin/i686-linux-android-ranlib"
         cmd << "NM=#{@ndk.toolchain}/bin/i686-linux-android-nm"
         cmd << "STRIP=#{@ndk.toolchain}/bin/i686-linux-android-strip"
         cmd << "CHOST=i686-linux-android"
      elsif @arch == Arch.aarch64
         archFlags = ""
         cmd << "CC=#{@ndk.toolchain}/bin/aarch64-linux-android#{@ndk.api}-clang"
         cmd << "CXX=#{@ndk.toolchain}/bin/aarch64-linux-android#{@ndk.api}-clang++"
         cmd << "AR=#{@ndk.toolchain}/bin/aarch64-linux-android-ar"
         cmd << "AS=#{@ndk.toolchain}/bin/aarch64-linux-android-as"
         cmd << "LD=#{@ndk.toolchain}/bin/aarch64-linux-android-ld"
         cmd << "RANLIB=#{@ndk.toolchain}/bin/aarch64-linux-android-ranlib"
         cmd << "NM=#{@ndk.toolchain}/bin/aarch64-linux-android-nm"
         cmd << "STRIP=#{@ndk.toolchain}/bin/aarch64-linux-android-strip"
         cmd << "CHOST=aarch64-linux-android"
      end
      execute cmd.join(" ") + " ./buildconf"

      cmd << "CPPFLAGS=\"#{archFlags} -Os -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing\""
      cmd << "CXXFLAGS=\"#{archFlags} -Os -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -frtti -fexceptions -std=c++11 -Wno-error=unused-command-line-argument\""
      cmd << "CFLAGS=\"#{archFlags} -Os -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing\""
      cmd << "./configure --enable-shared --disable-static"
      cmd << "--disable-dependency-tracking --without-ca-bundle --without-ca-path --enable-ipv6 --enable-http --enable-ftp"
      cmd << "--disable-file --disable-ldap --disable-ldaps --disable-rtsp --disable-proxy --disable-dict --disable-telnet --disable-tftp"
      cmd << "--disable-pop3 --disable-imap --disable-smtp --disable-gopher --disable-sspi --disable-manual"
      if @arch == Arch.armv7a
         cmd << "--host=arm-linux-androideabi --target=arm-linux-androideabi --build=x86_64-unknown-linux-gnu"
      elsif @arch == Arch.x86
         cmd << "--host=i686-linux-android --target=i686-linux-android --build=x86_64-unknown-linux-gnu"
      elsif @arch == Arch.aarch64
         cmd << "--host=aarch64-linux-android --target=aarch64-linux-android --build=x86_64-unknown-linux-gnu"
      end
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
