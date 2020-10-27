var Component = require("./Component");

module.exports = class CURLComponent extends Component {
  constructor() {
    super()
    this.sources = "curl"
    this.name = "curl"
  }
};
