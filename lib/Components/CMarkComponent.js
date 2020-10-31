var Component = require("./Component");
var Revision = require("../Git/Revision");
var Repo = require("../Git/Repo");

module.exports = class CMarkComponent extends Component {
  constructor() {
    super()
    this.sources = "cmark"
    this.name = "cmark"
    this.revision = Revision.cmark
    this.repository = Repo.cmark
  }
};
