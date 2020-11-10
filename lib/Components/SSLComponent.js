var Component = require("./Component");
var Revision = require("../Git/Revision");
var Repo = require("../Git/Repo");

module.exports = class SSLCompoment extends Component {
  constructor() {
    super()
    this.sources = "ssl"
    this.name = "ssl"
    this.revision = Revision.ssl
    this.repository = Repo.ssl
  }
};
