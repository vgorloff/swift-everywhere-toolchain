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
var Archs = require("../Archs");

module.exports = class CMarkBuilder extends Builder {
  constructor() {
    super(Component.cmark, Archs.host);
  }

  // See: $SWIFT_REPO/docs/WindowsBuild.md
  executeConfigure() {
    var cFlags = '-Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector'
    var cmd = `
      cd ${this.paths.builds} && cmake
      -G Ninja
      -D CMAKE_INSTALL_PREFIX=/
      -D CMAKE_BUILD_TYPE=Release
      -D CMARK_TESTS=false
      -D CMAKE_C_FLAGS="${cFlags}"
      -D CMAKE_CXX_FLAGS="${cFlags}"
      -D CMAKE_OSX_DEPLOYMENT_TARGET=10.9
      -D CMAKE_OSX_SYSROOT=${this.paths.xcMacOsSdkPath}
      ${this.paths.sources}
`;
    this.executeCommands(cmd);
  }

  executeBuild() {
    this.execute(`cd ${this.paths.builds} && ninja -j${this.numberOfJobs}`);
  }

  executeInstall() {
    this.execute(`DESTDIR=${this.paths.installs} cmake --build ${this.paths.builds} --target install`);
  }
};
