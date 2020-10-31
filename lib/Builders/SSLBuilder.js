var Builder = require("../Builder");
var Component = require("../Components");
var Arch = require("../Archs/Arch");

module.exports = class SSLBuilder extends Builder {
  constructor(/** @type {Arch} */ arch) {
    super(Component.ssl, arch);
  }

  executeConfigure() {}

  executeBuild() {}

  executeInstall() {}
};
