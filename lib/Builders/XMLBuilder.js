var Builder = require("../Builder");
var Component = require("../Components");
var Arch = require("../Archs/Arch");
var Archs = require("../Archs");
var NDK = require("../NDK");

module.exports = class XMLBuilder extends Builder {
  constructor(/** @type {Arch} */ arch) {
    super(Component.xml, arch);
  }

  prepare() {
    // Unused at the moment.
  }

  executeConfigure() {
    this.clean();

    var ndk = new NDK();

    // Arguments took from `swift/swift-corelibs-foundation/build-android`

    var archFlags = "";
    var cFlags = "";
    var hostFlag = "";
    if (this.arch.name == Archs.arm.name) {
      hostFlag = "--host=arm-linux-androideabi";
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

    this.executeCommands(`cd ${this.paths.sources} && ${archFlags} autoreconf -i`);

    var cmd = `
      CPPFLAGS="${cFlags} -Os -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing"
      CXXFLAGS="${cFlags} -Os -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -frtti -fexceptions -std=c++11 -Wno-error=unused-command-line-argument"
      CFLAGS="${cFlags} -Os -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing"
    `;

    var args = `
      --with-sysroot=${ndk.sources}/sysroot --with-zlib=${ndk.sources}/sysroot/usr --prefix=${this.paths.installs}
      --without-lzma --disable-static --enable-shared --without-http --without-html --without-ftp
      ${hostFlag}
      `;

    this.executeCommands(`cd ${this.paths.sources} && ${archFlags} ${cmd} ./configure ${args}`);
  }

  executeBuild() {
    this.execute(`cd ${this.paths.sources} && make libxml2.la`);
  }

  executeInstall() {
    this.execute(`cd ${this.paths.sources} && make install-libLTLIBRARIES`);
    this.execute(`cd ${this.paths.sources}/include && make install`);
  }
};
