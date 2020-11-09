const ProjectBuilder = require("../ProjectBuilder");

module.exports = class Builder extends ProjectBuilder {
  executeBuild() {
    this.binary = `${this.buildPath}/${this.component}`;
    var cmd = `
      cd "${this.buildPath}" &&
      ${this.swftcCmdPath} -emit-executable -o "${this.binary}"
      "${this.sourcesPath}/main.swift"
    `;
    this.executeCommands(cmd);
    this.copyLibs();
    this.execute(`file ${this.binary}`);
  }
};
