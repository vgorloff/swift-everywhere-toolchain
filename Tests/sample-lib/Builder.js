const ProjectBuilder = require("../ProjectBuilder")

module.exports = class Builder extends ProjectBuilder {

  constructor(component, arch) {
    super(component, arch)
    this.moduleName = "HelloMessages"
    this.libFilePath = `${this.buildPath}/lib${this.moduleName}.so`
  }

  executeBuild() {
    // Lib
    var cmd = `
      cd "${this.buildPath}" &&
      ${this.swftcCmdPath} -emit-library -emit-module -parse-as-library -module-name ${this.moduleName}
      -o "${this.libFilePath}" "${this.sourcesPath}/HelloMessage.swift"
    `;
    this.executeCommands(cmd);

    var cmd = `
      cd "${this.buildPath}" &&
      ${this.swftcCmdPath} -emit-executable -I ${this.buildPath} -L ${this.buildPath} -l${this.moduleName}
      -o "${this.binary}" ${this.sourcesPath}/main.swift
    `
    this.executeCommands(cmd);

    // Swift Libs
    this.copyLibs()

    this.execute(`file "${this.binary}"`)
    this.execute(`file "${this.libFilePath}"`)

  }

  get libs() {
    var value = super.libs
    value.push(this.libFilePath)
    return value
  }

};
