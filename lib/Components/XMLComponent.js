var Component = require("./Component");
var Revision = require("../Git/Revision");
var Repo = require("../Git/Repo");

module.exports = class XMLComponent extends Component {
  constructor() {
    super();
    this.sources = "xml";
    this.name = "xml";
    this.revision = Revision.xml;
    this.repository = Repo.xml;
  }
};
