var Component = require("./Component");

module.exports = class CMarkComponent extends Component {
  constructor() {
    super()
    this.sources = "cmark"
    this.name = "cmark"
  }
};
