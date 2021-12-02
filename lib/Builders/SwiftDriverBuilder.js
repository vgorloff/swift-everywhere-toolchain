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

var SwiftTSCBuilder = require("./SwiftTSCBuilder");
var LLBBuilder = require("./LLBBuilder");
var YAMSBuilder = require("./YAMSBuilder");
var SAPBuilder = require("./SAPBuilder");

module.exports = class SwiftDriverBuilder extends Builder {
  constructor() {
    super(Component.sd, Archs.host);
  }

  // See: https://github.com/apple/swift-driver#building-with-cmake
  executeConfigure() {
    const tsc = new SwiftTSCBuilder()
    const llb = new LLBBuilder()
    const yams = new YAMSBuilder()
    const sap = new SAPBuilder()
    var cmd = `
      cd ${this.paths.builds} && cmake
      -G Ninja
      -D CMAKE_INSTALL_PREFIX=/
      -D CMAKE_BUILD_TYPE=Release
      -D CMAKE_OSX_DEPLOYMENT_TARGET=10.15

      -D TSC_DIR=${tsc.paths.builds}/cmake/modules
      -D LLBuild_DIR=${llb.paths.builds}/cmake/modules
      -D Yams_DIR=${yams.paths.builds}/cmake/modules
      -D ArgumentParser_DIR=${sap.paths.builds}/cmake/modules

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
