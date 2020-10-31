var Component = require("./Component");
var Revision = require("../Git/Revision");
var Repo = require("../Git/Repo");

module.exports = class FoundationComponent extends Component {
  constructor() {
    super()
    this.sources = "swift-corelibs-foundation"
    this.name = "swift-corelibs-foundation"
    this.revision = Revision.foundation
    this.repository = Repo.foundation
  }
};
