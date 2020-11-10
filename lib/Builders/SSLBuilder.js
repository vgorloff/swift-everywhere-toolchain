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

module.exports = class SSLBuilder extends Builder {
  constructor(/** @type {Arch} */ arch) {
    super(Component.ssl, arch);
    var ndk = new NDK();
    this.options = `ANDROID_NDK=${ndk.sources} PATH=${ndk.toolchainPath}/bin:$PATH`;
  }

  prepare() {
    // Unused at the moment.
  }

  executeConfigure() {
    this.clean();

    var ndk = new NDK();
    // Seems `-D__ANDROID_API__` not needed. See: #{@sources}/NOTES.ANDROID
    var cmd = `
    ${this.options}
    ./Configure
    -D__ANDROID_API__=${ndk.api}
    --prefix=${this.paths.installs}
    `;
    if (this.arch.name == Archs.arm.name) {
      cmd = `${cmd} android-arm`;
    } else if (this.arch.name == Archs.arm64.name) {
      cmd = `${cmd} android-arm64`;
    } else if (this.arch.name == Archs.x86.name) {
      cmd = `${cmd} android-x86`;
    } else if (this.arch.name == Archs.x86_64.name) {
      cmd = `${cmd} android-x86_64`;
    }
    this.executeCommands(`cd ${this.paths.sources} && ${cmd}`);
  }

  executeBuild() {
    this.executeCommands(`cd ${this.paths.sources} && ${this.options} make SHLIB_VERSION_NUMBER= SHLIB_EXT=.so`);
  }

  executeInstall() {
    this.executeCommands(
      `cd ${this.paths.sources} && ${this.options} make SHLIB_VERSION_NUMBER= SHLIB_EXT=.so install_sw install_ssldirs`
    );
  }

  get libs() {
    return this.findLibs(`${this.paths.installs}/lib`)
  }
};
