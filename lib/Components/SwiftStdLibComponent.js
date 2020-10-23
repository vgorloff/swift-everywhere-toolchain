var Component = require("./Component");

module.exports = class SwiftStdLibComponent extends Component {
  constructor() {
    super()
    this.sources = "swift"
    this.name = "swift-stdlib"
  }
};
