var Arch = require("./Arch");

module.exports = class ArmArch extends Arch {
  constructor() {
    super()
    this.name = "armv7a"
    this.ndkABI = "armeabi-v7a"
    this.swiftArch = "armv7"
  }
};
