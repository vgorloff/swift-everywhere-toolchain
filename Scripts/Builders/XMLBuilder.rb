require_relative "../Common/Builder.rb"

class XMLBuilder < Builder

   def initialize(target = "armv7a")
      super()
      @target = target
      @sourcesDir = Config.xmlSourcesRoot
      @buildDir = Config.buildRoot + "/xml/" + @target
      @installDir = Config.installRoot + "/xml/" + @target
   end

   def checkout
      downloader = Downloader.new(Config.sourcesRoot, Config.xmlSourcesRoot, "https://github.com/GNOME/libxml2/archive/v2.9.8.tar.gz", 'libxml2-*')
      downloader.bootstrap()
   end

   def prepare
      execute "mkdir -p #{@buildDir}"
      execute "mkdir -p #{@installDir}"
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

      args = "--with-sysroot=#{ndkToolchainSysPath} --with-zlib=#{ndkToolchainSysPath}/usr --prefix=#{@installDir} --host=arm-linux-androideabi --without-lzma --disable-static --enable-shared --without-http --without-html --without-ftp"
      execute cmd.join(" ") + " ./configure " + args
   end

   def build
      execute "cd #{@sourcesDir} && make libxml2.la"
      execute "cd #{@sourcesDir} && make install-libLTLIBRARIES"
      execute "cd #{@sourcesDir}/include && make install"
   end

   def make
      checkout
      prepare
      configure
      build
   end

end
