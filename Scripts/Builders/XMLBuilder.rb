require_relative "../Common/Builder.rb"

class XMLBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.xml, arch)
      @ndk = NDK.new()
   end

   def prepare
      # Not used at the moment.
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
      elsif @arch == Arch.x64
         archFlags = "-march=x86-64"
         cmd << "CC=#{@ndk.toolchain}/bin/x86_64-linux-android#{@ndk.api}-clang"
         cmd << "CXX=#{@ndk.toolchain}/bin/x86_64-linux-android#{@ndk.api}-clang++"
         cmd << "AR=#{@ndk.toolchain}/bin/x86_64-linux-android-ar"
         cmd << "AS=#{@ndk.toolchain}/bin/x86_64-linux-android-as"
         cmd << "LD=#{@ndk.toolchain}/bin/x86_64-linux-android-ld"
         cmd << "RANLIB=#{@ndk.toolchain}/bin/x86_64-linux-android-ranlib"
         cmd << "NM=#{@ndk.toolchain}/bin/x86_64-linux-android-nm"
         cmd << "STRIP=#{@ndk.toolchain}/bin/x86_64-linux-android-strip"
         cmd << "CHOST=x86_64-linux-android"
      end

      execute cmd.join(" ") + " autoreconf -i"
      
      cmd << "CPPFLAGS=\"#{archFlags} -Os -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing\""
      cmd << "CXXFLAGS=\"#{archFlags} -Os -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -frtti -fexceptions -std=c++11 -Wno-error=unused-command-line-argument\""
      cmd << "CFLAGS=\"#{archFlags} -Os -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing\""

      args = ["--with-sysroot=#{@ndk.sources}/sysroot --with-zlib=#{@ndk.sources}/sysroot/usr --prefix=#{@installs}"]
      args << "--without-lzma --disable-static --enable-shared --without-http --without-html --without-ftp"
      if @arch == Arch.armv7a
         args << "--host=arm-linux-androideabi"
      elsif @arch == Arch.x86
         args << "--host=i686-linux-android"
      elsif @arch == Arch.aarch64
         args << "--host=aarch64-linux-android"
      elsif @arch == Arch.x64
         args << "--host=x86_64-linux-android"
      end
      execute cmd.join(" ") + " ./configure " + args.join(" ")
   end

   def executeBuild
      execute "cd #{@sources} && make libxml2.la"
   end

   def executeInstall
      execute "cd #{@sources} && make install-libLTLIBRARIES"
      execute "cd #{@sources}/include && make install"
   end

end
