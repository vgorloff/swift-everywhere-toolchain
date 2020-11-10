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
    this.execute(`cd ${this.paths.builds} && ninja -C ${this.paths.builds} -j${this.numberOfJobs} llvm-tblgen clang-tblgen llvm-libraries clang-libraries`);
  }

  executeInstall() {
    //this.execute(`DESTDIR=${this.paths.installs} cmake --build ${this.paths.builds} --target install`);
  }
};
