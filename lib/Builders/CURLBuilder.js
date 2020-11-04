var Builder = require("../Builder");
var Component = require("../Components");
var Arch = require("../Archs/Arch");
var NDK = require("../NDK");
var Archs = require("../Archs");
var SSLBuilder = require("./SSLBuilder");

module.exports = class CURLBuilder extends Builder {
  constructor(/** @type {Arch} */ arch) {
    super(Component.curl, arch);
  }

  prepare() {
    // Unused at the moment.
  }

  executeConfigure() {
    this.clean();
    // Arguments took from `swift/swift-corelibs-foundation/build-android`

    var ndk = new NDK();
    var ssl = new SSLBuilder(this.arch);

    var archFlags = "";
    var cFlags = "";
    var hostFlags = "";
    if (this.arch.name == Archs.arm.name) {
      hostFlags = "--host=arm-linux-androideabi --target=arm-linux-androideabi --build=x86_64-unknown-linux-gnu";
      cFlags = "-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16";
      archFlags = `
        CC=${ndk.toolchainPath}/bin/armv7a-linux-androideabi${ndk.api}-clang
        CXX=${ndk.toolchainPath}/bin/armv7a-linux-androideabi${ndk.api}-clang++
        AR=${ndk.toolchainPath}/bin/arm-linux-androideabi-ar
        AS=${ndk.toolchainPath}/bin/arm-linux-androideabi-as
        LD=${ndk.toolchainPath}/bin/arm-linux-androideabi-ld
        RANLIB=${ndk.toolchainPath}/bin/arm-linux-androideabi-ranlib
        NM=${ndk.toolchainPath}/bin/arm-linux-androideabi-nm
        STRIP=${ndk.toolchainPath}/bin/arm-linux-androideabi-strip
        CHOST=arm-linux-androideabi
        LDFLAGS="-march=armv7-a -Wl,--fix-cortex-a8"
      `;
    }

    this.executeCommands(`cd ${this.paths.sources} && ${archFlags} ./buildconf`);

    var cmd = `
      cd ${this.paths.sources} &&
      ${archFlags}
      CPPFLAGS="${cFlags} -Os -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing"
      CXXFLAGS="${cFlags} -Os -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -frtti -fexceptions -std=c++11 -Wno-error=unused-command-line-argument"
      CFLAGS="${cFlags} -Os -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing"
      ./configure --enable-shared --disable-static
      --disable-dependency-tracking --without-ca-bundle --without-ca-path --enable-ipv6 --enable-http --enable-ftp
      --disable-file --disable-ldap --disable-ldaps --disable-rtsp --disable-proxy --disable-dict --disable-telnet --disable-tftp
      --disable-pop3 --disable-imap --disable-smtp --disable-gopher --disable-sspi --disable-manual
      ${hostFlags}
      --with-zlib=${ndk.sources}/usr/sysroot --with-ssl=${ssl.paths.installs} --prefix=${this.paths.installs}
    `;

    this.executeCommands(cmd);
  }

  executeBuild() {
    this.execute(`cd ${this.paths.sources} && make`);
  }

  executeInstall() {
    this.execute(`cd ${this.paths.sources} && make install`);
  }

  get libs() {
    return this.findLibs(`${this.paths.installs}/lib`)
  }
};
