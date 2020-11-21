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
const LLBBuilder = require("./LLBBuilder")
const SwiftTSCBuilder = require("./SwiftTSCBuilder")

module.exports = class SPMBuilder extends Builder {
  constructor() {
    super(Component.spm, Archs.host);
  }

  // See: ToolChain/Sources/spm/Utilities/build-using-cmake
  executeConfigure() {
    const llb = new LLBBuilder()
    const tsc = new SwiftTSCBuilder()
    var cmd = `
      cd ${this.paths.builds} && cmake
      -G Ninja
      -D CMAKE_BUILD_TYPE=Release
      -D CMAKE_Swift_FLAGS="-sdk ${this.paths.xcMacOsSdkPath} -Xlinker -rpath -Xlinker @executable_path/../lib"
      -D TSC_DIR=${tsc.paths.builds}/cmake/modules
      -D LLBuild_DIR=${llb.paths.builds}/cmake/modules
      -D CMAKE_BUILD_WITH_INSTALL_RPATH=true
      -D CMAKE_INSTALL_PREFIX=/
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

  configurePatches(/** @type {Boolean} */ shouldEnable) {
    this.configurePatch(`${this.paths.patches}/Sources/Build/BuildPlan.swift.diff`, shouldEnable)
  }
};
