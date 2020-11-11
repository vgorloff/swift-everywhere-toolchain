/*
 * The MIT License
 *
 * Copyright (c) 2019 Volodymyr Gorlov (https://github.com/vgorloff)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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
    } else if (this.arch.name == Archs.arm64.name) {
      hostFlag = "--host=aarch64-linux-android"
      cFlags = ""
      archFlags = `
        CC=${ndk.toolchainPath}/bin/aarch64-linux-android${ndk.api}-clang
        CXX=${ndk.toolchainPath}/bin/aarch64-linux-android${ndk.api}-clang++
        AR=${ndk.toolchainPath}/bin/aarch64-linux-android-ar
        AS=${ndk.toolchainPath}/bin/aarch64-linux-android-as
        LD=${ndk.toolchainPath}/bin/aarch64-linux-android-ld
        RANLIB=${ndk.toolchainPath}/bin/aarch64-linux-android-ranlib
        NM=${ndk.toolchainPath}/bin/aarch64-linux-android-nm
        STRIP=${ndk.toolchainPath}/bin/aarch64-linux-android-strip
        CHOST=aarch64-linux-android
      `
    } else if (this.arch.name == Archs.x86.name) {
      hostFlag = "--host=i686-linux-android"
      cFlags = "-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"
      archFlags = `
      CC=${ndk.toolchainPath}/bin/i686-linux-android${ndk.api}-clang
      CXX=${ndk.toolchainPath}/bin/i686-linux-android${ndk.api}-clang++
      AR=${ndk.toolchainPath}/bin/i686-linux-android-ar
      AS=${ndk.toolchainPath}/bin/i686-linux-android-as
      LD=${ndk.toolchainPath}/bin/i686-linux-android-ld
      RANLIB=${ndk.toolchainPath}/bin/i686-linux-android-ranlib
      NM=${ndk.toolchainPath}/bin/i686-linux-android-nm
      STRIP=${ndk.toolchainPath}/bin/i686-linux-android-strip
      CHOST=i686-linux-android
      `
    } else if (this.arch.name == Archs.x86_64.name) {
      hostFlag = "--host=x86_64-linux-android"
      cFlags = "-march=x86-64"
      archFlags = `
        CC=${ndk.toolchainPath}/bin/x86_64-linux-android${ndk.api}-clang
        CXX=${ndk.toolchainPath}/bin/x86_64-linux-android${ndk.api}-clang++
        AR=${ndk.toolchainPath}/bin/x86_64-linux-android-ar
        AS=${ndk.toolchainPath}/bin/x86_64-linux-android-as
        LD=${ndk.toolchainPath}/bin/x86_64-linux-android-ld
        RANLIB=${ndk.toolchainPath}/bin/x86_64-linux-android-ranlib
        NM=${ndk.toolchainPath}/bin/x86_64-linux-android-nm
        STRIP=${ndk.toolchainPath}/bin/x86_64-linux-android-strip
        CHOST=x86_64-linux-android
      `
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

  get libs() {
    return this.findLibs(`${this.paths.installs}/lib`);
  }
};
