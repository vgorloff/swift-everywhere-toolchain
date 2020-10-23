var Builder = require("../Builder");
var Component = require("../Components");
var Archs = require("../Archs");
var NDK = require("../NDK");

module.exports = class SwiftBuilder extends Builder {
  constructor() {
    super(Component.swift, Archs.host);
  }

  executeConfigure() {
    var cmd = `
      cd ${this.paths.builds} && cmake
      -G Ninja

`;
    this.executeCommands(cmd);
  }

  executeBuild() {
    this.execute(`cd ${this.paths.builds} && ninja -C ${this.paths.builds} -j${this.numberOfJobs}`);
  }

  executeInstall() {
    this.execute(`DESTDIR=${this.paths.installs} cmake --build ${this.paths.builds} --target install`);
  }
};
