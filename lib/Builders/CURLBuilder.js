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
    } else if (this.arch.name == Archs.arm64.name) {
      hostFlags = "--host=aarch64-linux-android --target=aarch64-linux-android --build=x86_64-unknown-linux-gnu"
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
      hostFlags = "--host=i686-linux-android --target=i686-linux-android --build=x86_64-unknown-linux-gnu"
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
      hostFlags = "--host=x86_64-linux-android --target=x86_64-linux-android --build=x86_64-unknown-linux-gnu"
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
