var Arch = require("./Arch");

module.exports = class HostArch extends Arch {
  constructor() {
    super()
    this.name = "host"
  }
};
