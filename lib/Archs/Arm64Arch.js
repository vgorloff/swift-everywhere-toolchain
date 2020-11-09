var Arch = require("./Arch");

module.exports = class Arm64Arch extends Arch {
  constructor() {
    super();
    this.name = "aarch64";
    this.ndkABI = "arm64-v8a";
    this.ndkPlatform = "arch-arm64";
    this.ndkLibArchName = "aarch64-linux-android";
    this.swiftArch = "aarch64";
    this.swiftTarget = "aarch64-unknown-linux-android";
  }
};
