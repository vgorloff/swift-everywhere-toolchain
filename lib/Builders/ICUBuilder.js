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
  }

  configurePatches(/** @type {Boolean} */ shouldEnable) {
    this.configurePatch(`${this.paths.patches}/source/configure.diff`, shouldEnable);
    this.configurePatch(`${this.paths.patches}/source/config/mh-linux.diff`, shouldEnable);
    this.configurePatch(`${this.paths.patches}/source/data/Makefile.in.diff`, shouldEnable);
  }

  get libs() {
    return this.findLibs(`${this.paths.installs}/lib`)
  }
};
