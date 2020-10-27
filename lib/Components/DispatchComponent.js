var Component = require("./Component");

module.exports = class DispatchComponent extends Component {
  constructor() {
    super()
    this.sources = "swift-corelibs-libdispatch"
    this.name = "swift-corelibs-libdispatch"
  }
};
