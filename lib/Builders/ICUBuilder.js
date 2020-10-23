var Builder = require("../Builder");
var Component = require("../Components");
var Arch = require("../Archs/Arch");
var path = require("path");

module.exports = class ICUBuilder extends Builder {
  constructor(/** @type {Arch} */ arch) {
    super(Component.icu, arch);
    this.paths.sources = path.join(this.paths.sources, 'icu4c')
  }

  executeBuild() {}

  executeInstall() {}
};
