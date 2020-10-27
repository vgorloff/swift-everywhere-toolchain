var Builder = require("../Builder");
var Component = require("../Components");
var Arch = require("../Archs/Arch");

module.exports = class XMLBuilder extends Builder {
  constructor(/** @type {Arch} */ arch) {
    super(Component.xml, arch);
  }

  executeConfigure() {}

  executeBuild() {}

  executeInstall() {}
};
