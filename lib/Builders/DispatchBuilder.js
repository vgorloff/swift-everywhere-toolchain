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

var path = require("path");

var Builder = require("../Builder");
var Component = require("../Components");
var NDK = require("../NDK");
var SwiftBuilder = require("./SwiftBuilder");
var SwiftStdLibBuilder = require("./SwiftStdLibBuilder");

module.exports = class DispatchBuilder extends Builder {
  constructor(/** @type {Arch} */ arch) {
    super(Component.dispatch, arch);
  }

  executeConfigure() {
    var ndk = new NDK();
    var swift = new SwiftBuilder();
    var stdlib = new SwiftStdLibBuilder(this.arch);

    var cFlags = "";
    // cFlags += "-v"
    var swiftFlags = "";
    // swiftFlags += " -v"
    swiftFlags += ` -resource-dir ${stdlib.paths.builds}/lib/swift -Xcc --sysroot=${ndk.sources}/sysroot -Xclang-linker --sysroot=${ndk.sources}/platforms/android-${ndk.api}/${this.arch.ndkPlatform} -Xclang-linker --gcc-toolchain=${ndk.toolchainPath}`;

    var cmd = `
      cd ${this.paths.builds} && cmake
      -G Ninja
      # --debug-output

      -D ANDROID_ABI=${this.arch.ndkABI}
      -D ANDROID_PLATFORM=${ndk.platformName}
      -D CMAKE_TOOLCHAIN_FILE=${ndk.sources}/build/cmake/android.toolchain.cmake

      -D CMAKE_INSTALL_PREFIX=/
      -D CMAKE_BUILD_TYPE=${this.buildConfiguration}
      -D CMAKE_OSX_DEPLOYMENT_TARGET=10.15

      -D ENABLE_TESTING=NO
      -D ENABLE_SWIFT=YES

      -D CMAKE_Swift_COMPILER=${swift.paths.builds}/bin/swiftc
      # Skipping Swift compiler check. See: /usr/local/Cellar/cmake/3.16.2/share/cmake/Modules/CMakeTestSwiftCompiler.cmake
      -D CMAKE_Swift_COMPILER_FORCED=true

      -D CMAKE_Swift_COMPILER_TARGET=${this.arch.swiftTarget}
      -D CMAKE_Swift_FLAGS="${swiftFlags}"
      -D CMAKE_C_FLAGS="${cFlags}"
      -D CMAKE_CXX_FLAGS="${cFlags}"

      -D CMAKE_BUILD_WITH_INSTALL_RPATH=true
      ${this.paths.sources}
`;
    this.executeCommands(cmd);
  }

  executeBuild() {
    this.execute(`cd ${this.paths.builds} && ninja -j${this.numberOfJobs}`);
  }

  executeInstall() {
    this.execute(`DESTDIR=${this.paths.installs} cmake --build ${this.paths.builds} --target install`);
    var libs = this.findLibs(`${this.paths.installs}/usr/lib/swift/android`);
    libs.forEach((item) => this.execute(`mv -f "${item}" "${path.dirname(item)}/${this.arch.swiftArch}"`));
    this.execute(`mv -f "${this.paths.installs}/usr/lib" "${this.paths.installs}/lib"`);
    this.execute(`rm -rf "${this.paths.installs}/usr"`);
  }

  configurePatches(/** @type {Boolean} */ shouldEnable) {
    this.configurePatch(`${this.paths.patches}/cmake/modules/DispatchCompilerWarnings.cmake.diff`, shouldEnable);
  }

  get libs() {
    return this.findLibs(`${this.paths.installs}/lib/swift/android/${this.arch.swiftArch}`);
  }
};
