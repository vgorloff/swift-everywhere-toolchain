var Arch = require("./Arch");

module.exports = class x86_64Arch extends Arch {
  constructor() {
    super();
    this.name = "x64";
    this.ndkABI = "x86_64";
    this.ndkPlatform = "arch-x86_64";
    this.ndkLibArchName = "x86_64-linux-android";
    this.swiftArch = "x86_64";
    this.swiftTarget = "x86_64-unknown-linux-android";
  }
};
