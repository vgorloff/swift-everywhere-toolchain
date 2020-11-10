var Component = require("./Component");
var Revision = require("../Git/Revision");
var Repo = require("../Git/Repo");

module.exports = class ICUCompoment extends Component {
  constructor() {
    super()
    this.sources = "icu"
    this.name = "icu"
    this.revision = Revision.icu
    this.repository = Repo.icu
  }
};
