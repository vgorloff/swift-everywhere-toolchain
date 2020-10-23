var path = require("path");

module.exports = class Settings {
  constructor() {
    var localProperties = require("../local.properties.json")
    this.ndkDir = path.resolve(localProperties["ndk.dir.macos"])
  }
};
