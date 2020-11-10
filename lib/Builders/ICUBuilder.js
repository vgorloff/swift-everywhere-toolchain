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

const cp = require("child_process");
var fs = require("fs");

var ICUBaseBuilder = require("./ICUBaseBuilder");
var ICUHostBuilder = require("./ICUHostBuilder");
var NDK = require("../NDK");
var Archs = require("../Archs");

module.exports = class ICUBuilder extends ICUBaseBuilder {
  executeConfigure() {
    var host = new ICUHostBuilder();
    var ndk = new NDK();
    var archFlags = "";
    if (this.arch.name == Archs.arm.name) {
      archFlags = `
        CFLAGS='-Os -march=armv7-a -mfloat-abi=softfp -mfpu=neon'
        CXXFLAGS='--std=c++11 -march=armv7-a -mfloat-abi=softfp -mfpu=neon'
        LDFLAGS='-march=armv7-a -Wl,--fix-cortex-a8'
        CC=${ndk.toolchainPath}/bin/armv7a-linux-androideabi${ndk.api}-clang
        CXX=${ndk.toolchainPath}/bin/armv7a-linux-androideabi${ndk.api}-clang++
        AR=${ndk.toolchainPath}/bin/arm-linux-androideabi-ar
        RINLIB=${ndk.toolchainPath}/bin/arm-linux-androideabi-ranlib
        ${this.paths.sources}/source/configure --prefix=${this.paths.installs}
        --host=arm-linux-androideabi
      `;
    } else if (this.arch.name == Archs.arm64.name) {
      archFlags = `
        CFLAGS='-Os'
        CXXFLAGS='--std=c++11'
        CC=${ndk.toolchainPath}/bin/aarch64-linux-android${ndk.api}-clang
        CXX=${ndk.toolchainPath}/bin/aarch64-linux-android${ndk.api}-clang++
        AR=${ndk.toolchainPath}/bin/aarch64-linux-android-ar
        RINLIB=${ndk.toolchainPath}/bin/aarch64-linux-android-ranlib
        ${this.paths.sources}/source/configure --prefix=${this.paths.installs}
        --host=aarch64-linux-android
      `;
    } else if (this.arch.name == Archs.x86.name) {
      archFlags = `
        CFLAGS='-Os -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32'
        CXXFLAGS='--std=c++11 -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32'
        CC=${ndk.toolchainPath}/bin/i686-linux-android${ndk.api}-clang
        CXX=${ndk.toolchainPath}/bin/i686-linux-android${ndk.api}-clang++
        AR=${ndk.toolchainPath}/bin/i686-linux-android-ar
        RINLIB=${ndk.toolchainPath}/bin/i686-linux-android-ranlib
        ${this.paths.sources}/source/configure --prefix=${this.paths.installs}
        --host=i686-linux-android
      `

    } else if (this.arch.name == Archs.x86_64.name) {
      archFlags = `
        CFLAGS='-Os -march=x86-64'
        CXXFLAGS='--std=c++11'
        CC=${ndk.toolchainPath}/bin/x86_64-linux-android${ndk.api}-clang
        CXX=${ndk.toolchainPath}/bin/x86_64-linux-android${ndk.api}-clang++
        AR=${ndk.toolchainPath}/bin/x86_64-linux-android-ar
        RINLIB=${ndk.toolchainPath}/bin/x86_64-linux-android-ranlib
        ${this.paths.sources}/source/configure --prefix=${this.paths.installs}
        --host=x86_64-linux-android
      `
    }

    var cmd = `cd ${this.paths.builds} &&

      ${archFlags}

      // Below option should not be set. Otherwize you will have ICU without embed data.
      // See:
      // - ICU Data - ICU User Guide: http://userguide.icu-project.org/icudata#TOC-Building-and-Linking-against-ICU-data
      // - https://forums.swift.org/t/partial-nightlies-for-android-sdk/25909/43?u=v.gorlov
      // --enable-tools=no

      --with-library-suffix=swift
      --enable-static=no --enable-shared --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no --enable-layoutex=no
      --enable-tests=no --enable-samples=no --enable-dyload=no
      --with-cross-build=${host.paths.builds}
      --with-data-packaging=library
    `;
    this.executeCommands(cmd);
  }

  executeBuild() {}

  executeInstall() {
    this.execute(`cd ${this.paths.builds} && make install`);
    this.execute(`find "${this.paths.installs}/lib" -iname *.so* -type l -depth 1 | xargs -I{} rm -f "{}"`)
    var libs = cp.execSync(`find "${this.paths.installs}/lib" -iname *.so.* -depth 1`).toString().trim().split("\n")
    libs.forEach((item) => {
      var newName = item.replace(/\.so.*/, '.so')
      if (!fs.existsSync(newName)) {
        this.execute(`mv -f "${item}" "${newName}"`)
      }
    })
    this.execute(`find "${this.paths.installs}/lib" -iname *.so.* -depth 1 | xargs -I{} rm -f "{}"`)
  }

  configurePatches(/** @type {Boolean} */ shouldEnable) {
    this.configurePatch(`${this.paths.patches}/source/configure.diff`, shouldEnable);
    this.configurePatch(`${this.paths.patches}/source/config/mh-linux.diff`, shouldEnable);
    this.configurePatch(`${this.paths.patches}/source/data/Makefile.in.diff`, shouldEnable);
  }

  get libs() {
    return this.findLibs(`${this.paths.installs}/lib`).filter((item) => !item.endsWith("libicutestswift.so"))
  }
};
