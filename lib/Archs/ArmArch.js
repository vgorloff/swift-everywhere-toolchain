var Arch = require("./Arch");

module.exports = class ArmArch extends Arch {
  constructor() {
    super();
    this.name = "armv7a";
    this.ndkABI = "armeabi-v7a";
    this.ndkPlatform = "arch-arm";
    this.swiftArch = "armv7";
    this.swiftTarget = "armv7-unknown-linux-androideabi";
  }
};
