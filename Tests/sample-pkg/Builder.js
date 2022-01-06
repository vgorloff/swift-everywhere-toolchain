const ProjectBuilder = require("../ProjectBuilder")

module.exports = class Builder extends ProjectBuilder {

  constructor(component, arch) {
    super(component, arch)
    this.buildConfig = "release"
    this.binary = `${this.buildPath}/${this.buildConfig}/Exe`
    this.libFilePath = `${this.buildPath}/${this.buildConfig}/libLib.so`
  }

  executeBuild() {
    this.execute(`cd "${this.rootPath}" && ${this.swiftBuildCmd}`);
    this.execute(`cd "${this.rootPath}" && ${this.swiftBuildCmd} -c ${this.buildConfig}`);

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
