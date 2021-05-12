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
const SAPBuilder = require("./SAPBuilder")
const SwiftDriverBuilder = require("./SwiftDriverBuilder")

module.exports = class SPMBuilder extends Builder {
  constructor() {
    super(Component.spm, Archs.host);
  }

  // See: ToolChain/Sources/spm/Utilities/build-using-cmake
  executeConfigure() {
    const llb = new LLBBuilder()
    const tsc = new SwiftTSCBuilder()
    const sap = new SAPBuilder()
    const sd = new SwiftDriverBuilder()
    var cmd = `
      cd ${this.paths.builds} && cmake
      -G Ninja
      -D CMAKE_BUILD_TYPE=Release
      -D CMAKE_Swift_FLAGS="-sdk ${this.paths.xcMacOsSdkPath} -Xlinker -rpath -Xlinker @executable_path/../lib"
      -D TSC_DIR=${tsc.paths.builds}/cmake/modules
      -D LLBuild_DIR=${llb.paths.builds}/cmake/modules
      -D ArgumentParser_DIR=${sap.paths.builds}/cmake/modules
      -D SwiftDriver_DIR=${sd.paths.builds}/cmake/modules
      -D USE_CMAKE_INSTALL=TRUE
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
    //> Below not needed starting from v1.0.69. See also option `USE_CMAKE_INSTALL`
    // this.configurePatch(`${this.paths.patches}/Sources/Build/BuildPlan.swift.diff`, shouldEnable)
    //
    // this.configurePatch(`${this.paths.patches}/Sources/Build/CMakeLists.txt.diff`, shouldEnable)
    // this.configurePatch(`${this.paths.patches}/Sources/Commands/CMakeLists.txt.diff`, shouldEnable)
    // this.configurePatch(`${this.paths.patches}/Sources/LLBuildManifest/CMakeLists.txt.diff`, shouldEnable)
    // this.configurePatch(`${this.paths.patches}/Sources/PackageGraph/CMakeLists.txt.diff`, shouldEnable)
    // this.configurePatch(`${this.paths.patches}/Sources/PackageLoading/CMakeLists.txt.diff`, shouldEnable)
    // this.configurePatch(`${this.paths.patches}/Sources/PackageModel/CMakeLists.txt.diff`, shouldEnable)
    // this.configurePatch(`${this.paths.patches}/Sources/SourceControl/CMakeLists.txt.diff`, shouldEnable)
    // this.configurePatch(`${this.paths.patches}/Sources/SPMBuildCore/CMakeLists.txt.diff`, shouldEnable)
    // this.configurePatch(`${this.paths.patches}/Sources/SPMLLBuild/CMakeLists.txt.diff`, shouldEnable)
    // this.configurePatch(`${this.paths.patches}/Sources/swift-build/CMakeLists.txt.diff`, shouldEnable)
    // this.configurePatch(`${this.paths.patches}/Sources/swift-package/CMakeLists.txt.diff`, shouldEnable)
    // this.configurePatch(`${this.paths.patches}/Sources/swift-run/CMakeLists.txt.diff`, shouldEnable)
    // this.configurePatch(`${this.paths.patches}/Sources/swift-test/CMakeLists.txt.diff`, shouldEnable)
    // this.configurePatch(`${this.paths.patches}/Sources/Workspace/CMakeLists.txt.diff`, shouldEnable)
    // this.configurePatch(`${this.paths.patches}/Sources/XCBuildSupport/CMakeLists.txt.diff`, shouldEnable)
    // this.configurePatch(`${this.paths.patches}/Sources/Xcodeproj/CMakeLists.txt.diff`, shouldEnable)
    //<
  }
};
