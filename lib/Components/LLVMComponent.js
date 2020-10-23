var Component = require("./Component");

module.exports = class LLVMComponent extends Component {
  constructor() {
    super()
    this.sources = "llvm-project"
    this.name = "llvm-project"
  }
};
