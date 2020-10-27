var Builder = require("../Builder");
var Component = require("../Components");
var Arch = require("../Archs/Arch");

module.exports = class CURLBuilder extends Builder {
  constructor(/** @type {Arch} */ arch) {
    super(Component.curl, arch);
  }

  executeConfigure() {}

  executeBuild() {}

  executeInstall() {}
};
