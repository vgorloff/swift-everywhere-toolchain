module.exports = class Arch {
  constructor() {
    this.name = "";
    /** Used inside `cmake` configurations. */
    this.ndkABI = "";
    this.ndkPlatform = "";
    this.ndkLibArchName = "";
    this.swiftArch = "";
    this.swiftTarget = "";
  }
};
