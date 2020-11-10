var Component = require("./Component");
var Revision = require("../Git/Revision");
var Repo = require("../Git/Repo");

module.exports = class DispatchComponent extends Component {
  constructor() {
    super()
    this.sources = "swift-corelibs-libdispatch"
    this.name = "swift-corelibs-libdispatch"
    this.revision = Revision.dispatch
    this.repository = Repo.dispatch
  }
};
