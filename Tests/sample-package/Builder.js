const ProjectBuilder = require("../ProjectBuilder")

module.exports = class Builder extends ProjectBuilder {

  constructor(component, arch) {
    super(component, arch)
    this.binary = `${this.buildPath}/${this.buildConfig}/Exe`
    this.libFilePath = `${this.buildPath}/${this.buildConfig}/libLib.so`
  }

  executeBuild() {
    var cmd = `
      cd "${this.rootPath}" && ${this.swiftBuildCmdPath}
    `;
    this.executeCommands(cmd);

    // Swift Libs
    this.copyLibs()

    this.execute(`file ${this.binary}`)
    this.execute(`file ${this.libFilePath}`)
  }

  get libs() {
    var value = super.libs
    value.push(this.libFilePath)
    return value
  }
};
