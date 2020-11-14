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

const Builder = require("../Builder");
const Component = require("../Components");
const Archs = require("../Archs");
const SwiftBuilder = require("./SwiftBuilder");

module.exports = class LLBBuilder extends Builder {
  constructor() {
    super(Component.llb, Archs.host);
  }

  // See: ToolChain/Sources/spm/Utilities/build-using-cmake
  executeConfigure() {
    const swift = new SwiftBuilder();

    var cmd = `
      cd ${this.paths.builds} && cmake
      -G Ninja
      -D CMAKE_BUILD_TYPE=Release

      -D CMAKE_Swift_FLAGS="-Xlinker -v -Xfrontend -target -Xfrontend x86_64-apple-macos10.10 -target x86_64-apple-macos10.10 -v"

      // -D CMAKE_Swift_FLAGS="-Xfrontend -target-cpu -Xfrontend x86-64 -target-cpu x86-64 -Xlinker -v -Xlinker -arch -Xlinker x86_64 -Xfrontend -target -Xfrontend x86_64-apple-macos10.10 -target x86_64-apple-macos10.10 -sdk ${this.paths.xcMacOsSdkPath} -v"

      -D LLBUILD_SUPPORT_BINDINGS=Swift

      // Otherwise it fails to link one of dylib.
      -D BUILD_SHARED_LIBS=false

      // Otherwise it will pick "tdb" file instead of "dylib"
      -D SQLite3_INCLUDE_DIR=${this.paths.xcMacOsSdkPath}/usr/include
      -D SQLite3_LIBRARY=/usr/lib/libsqlite3.dylib

      // -D CMAKE_Swift_COMPILER=${swift.paths.builds}/bin/swiftc
      # Skipping Swift compiler check. See: /usr/local/Cellar/cmake/3.16.2/share/cmake/Modules/CMakeTestSwiftCompiler.cmake
      // -D CMAKE_Swift_COMPILER_FORCED=true
      ${this.paths.sources}
`;
    this.executeCommands(cmd);
  }

  executeBuild() {
    this.execute(`cd ${this.paths.builds} && ninja -j${this.numberOfJobs}`);
  }

  configurePatches(/** @type {Boolean} */ shouldEnable) {
    this.configurePatch(`${this.paths.patches}/CMakeLists.txt.diff`, shouldEnable)
  }
};
