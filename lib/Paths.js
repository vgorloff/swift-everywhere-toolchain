var path = require("path");
const cp = require("child_process");

var Config = require("./Config");
var Folder = require("./Folder");
var Component = require("./Components/Component");
var Arch = require("./Archs/Arch");

module.exports = class Paths {
  static sourcesDirPath(/** @type {Component} */ component) {
    return path.join(Config.toolChain, Folder.sources, component.sources);
  }
  constructor(/** @type {String} */ platform, /** @type {Component} */ component, /** @type {Arch} */ arch) {
    this.sources = Paths.sourcesDirPath(component)
    this.patches = path.join(Config.root, Folder.patches, component.name);
    this.builds = path.join(Config.toolChain, Folder.build, `${platform}-${arch.name}`, component.name);
    this.installs = path.join(Config.toolChain, Folder.install, `${platform}-${arch.name}`, component.name);
    this.lib = path.join(this.installs, 'lib')
    this.developerDir = cp.execSync("xcode-select --print-path").toString().trim()
    this.xcToolchainPath = path.join(this.developerDir, 'Toolchains/XcodeDefault.xctoolchain')
    this.xcMacOsSdkPath = path.join(this.developerDir, 'Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk') // The `xcrun --show-sdk-path` can be used instead.
  }
};
