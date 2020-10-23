var Settings = require("./Settings");
var path = require("path");

module.exports = class NDK {
  constructor() {
    var settings = new Settings();
    this.api = 24;
    this.platformName = `android-${this.api}`;
    this.sources = settings.ndkDir;
    this.toolchainPath = path.join(settings.ndkDir, 'toolchains/llvm/prebuilt/darwin-x86_64')
    this.gcc = "4.9"
  }
};
