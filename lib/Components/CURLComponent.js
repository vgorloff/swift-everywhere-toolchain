var Component = require("./Component");
var Revision = require("../Git/Revision");
var Repo = require("../Git/Repo");

module.exports = class CURLComponent extends Component {
  constructor() {
    super()
    this.sources = "curl"
    this.name = "curl"
    this.revision = Revision.curl
    this.repository = Repo.curl
  }
};
