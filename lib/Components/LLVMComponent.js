var Component = require("./Component");
var Revision = require("../Git/Revision");
var Repo = require("../Git/Repo");

module.exports = class LLVMComponent extends Component {
  constructor() {
    super()
    this.sources = "llvm-project"
    this.name = "llvm-project"
    this.revision = Revision.llvm
    this.repository = Repo.llvm
  }
};
