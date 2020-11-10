var Component = require("./Component");
var Revision = require("../Git/Revision");
var Repo = require("../Git/Repo");

module.exports = class SwiftStdLibComponent extends Component {
  constructor() {
    super()
    this.sources = "swift"
    this.name = "swift-stdlib"
    this.revision = Revision.swift
    this.repository = Repo.swift
  }
};
