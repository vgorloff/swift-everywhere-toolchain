var Settings = require("./Settings");
var path = require("path");

module.exports = class NDK {
  constructor() {
    this.api = 24;
    this.platformName = `android-${this.api}`;
    this.sources = Settings.ndkDir;
    this.toolchainPath = path.join(Settings.ndkDir, 'toolchains/llvm/prebuilt/darwin-x86_64')
    this.gcc = "4.9"
  }
};
