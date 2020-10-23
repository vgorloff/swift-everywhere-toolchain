var Builder = require("../Builder");
var Component = require("../Components");
var Archs = require("../Archs");

module.exports = class LLVMBuilder extends Builder {

  constructor() {
    super(Component.llvm, Archs.host)
  }

  executeBuild() {
    this.execute("cmake -S /sdsd")
  }

  executeInstall() {
    this.execute(`cd ${this.paths.builds} && cmake --build ${this.paths.builds} --target install-distribution`)
  }
}
