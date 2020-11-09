var Arch = require("./Arch");

module.exports = class x86Arch extends Arch {
  constructor() {
    super();
    this.name = "x86";
    this.ndkABI = "x86";
    this.ndkPlatform = "arch-x86";
    this.ndkLibArchName = "i686-linux-android";
    this.swiftArch = "i686";
    this.swiftTarget = "i686-unknown-linux-android";
  }
};
