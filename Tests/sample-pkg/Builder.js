const ProjectBuilder = require("../ProjectBuilder")

module.exports = class Builder extends ProjectBuilder {

  constructor(component, arch) {
    super(component, arch)
    this.binary = `${this.buildPath}/release/Exe`
    this.libFilePath = `${this.buildPath}/release/libLib.so`
  }

  executeBuild() {
    this.execute(`cd "${this.rootPath}" && ${this.swiftBuildCmd}`);
    this.execute(`cd "${this.rootPath}" && ${this.swiftBuildCmd} -c release`);

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
