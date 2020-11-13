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

module.exports = class LLVMBuilder extends Builder {
  constructor() {
    super(Component.llvm, Archs.host);
  }

  executeConfigure() {
    var cFlags = "";
    // cFlags += " -v -Xcc -v ";
    cFlags += `-isystem ${this.paths.xcToolchainPath}/usr/include/c++/v1 -isysroot ${this.paths.xcMacOsSdkPath}`
    var cmd = `
      cd ${this.paths.builds} && cmake
      -G Ninja
      -S ${this.paths.sources}/llvm
      -B ${this.paths.builds}
      -D CMAKE_BUILD_TYPE=Release
      -D LLVM_INCLUDE_EXAMPLES=false
      -D LLVM_INCLUDE_TESTS=false
      -D LLVM_INCLUDE_DOCS=false
      -D LLVM_BUILD_TOOLS=false
      -D LLVM_INSTALL_BINUTILS_SYMLINKS=false

      # See also: https://groups.google.com/forum/#!topic/llvm-dev/5qSTO3VUUe4
      -D LLVM_TARGETS_TO_BUILD="ARM;AArch64;X86"

      -D LLVM_ENABLE_ASSERTIONS=TRUE
      -D LLVM_BUILD_EXTERNAL_COMPILER_RT=TRUE
      -D CMAKE_INSTALL_PREFIX=/
      -D LLVM_ENABLE_PROJECTS="clang"

      -D CMAKE_C_FLAGS="${cFlags}"
      -D CMAKE_CXX_FLAGS="${cFlags}"
`;
    this.executeCommands(cmd);
  }

  executeBuild() {
    // https://github.com/vgorloff/swift-everywhere-toolchain/issues/81
    // Se need to include clang for SPM.
    this.execute(`cd ${this.paths.builds} && ninja -C ${this.paths.builds} -j${this.numberOfJobs} clang llvm-tblgen clang-tblgen llvm-libraries clang-libraries`);
  }

  executeInstall() {
    //this.execute(`DESTDIR=${this.paths.installs} cmake --build ${this.paths.builds} --target install`);
  }
};
