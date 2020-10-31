var Component = require("./Component");
var Revision = require("../Git/Revision");
var Repo = require("../Git/Repo");

module.exports = class SwiftComponent extends Component {
  constructor() {
    super()
    this.sources = "swift"
    this.name = "swift"
    this.revision = Revision.swift
    this.repository = Repo.swift
  }
};
