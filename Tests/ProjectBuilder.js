var path = require("path");

const Tool = require("../lib/Tool");
const Arch = require("../lib/Archs/Arch");
const Config = require("../lib/Config");
const { join } = require("path");

module.exports = class ProjectBuilder extends Tool {
  constructor(/** @type {String} */ component, /** @type {Arch} */ arch) {
    super();
    var args = process.argv.slice(2);
    this.isVerbose = args.filter((item) => item == "--verbose").length > 0

    this.arch = arch;
    this.component = component;
    this.rootPath = path.join(Config.root, "Tests", `sample-${component}`);
    this.sourcesPath = path.join(this.rootPath, "Sources");
    this.buildPath = path.join(this.rootPath, "build");
    this.toolchainPath = Config.toolChainBuildOutput;
    if (arch.name == "armv7a") {
      this.ndkArchPath = "arm-linux-androideabi";
      this.swiftTarget = "armv7-none-linux-androideabi";
    } else if (arch.name == "x86") {
      this.ndkArchPath = "i686-linux-android";
      this.swiftTarget = "i686-unknown-linux-android";
    } else if (arch.name == "aarch64") {
      this.ndkArchPath = "aarch64-linux-android";
      this.swiftTarget = "aarch64-unknown-linux-android";
    } else if (arch.name == "x86_64") {
      this.ndkArchPath = "x86_64-linux-android";
      this.swiftTarget = "x86_64-unknown-linux-android";
    }
    this.swftcCmdPath = path.join(this.toolchainPath, `/usr/bin/swiftc-${this.ndkArchPath}`);
    this.copyLibsCmdPath = path.join(this.toolchainPath, `/usr/bin/copy-libs-${this.ndkArchPath}`)
    this.swiftBuildCmdPath = path.join(this.toolchainPath, "/usr/bin/android-swift-build") + ` --android-target ${this.swiftTarget} -c release --build-path "${this.buildPath}"`

    if (this.isVerbose) {
      this.swftcCmdPath += " -v"
      this.copyLibsCmdPath += " -v"
      this.swiftBuildCmdPath += " -v"
    }
  }

  runAction(/** @type {String} */ action) {
    if (action == "build") {
      this.build();
    } else if (action == "verify") {
      this.verify();
    } else if (action == "deploy") {
      this.deploy();
    } else if (action == "undeploy") {
      this.undeploy();
    } else if (action == "clean") {
      this.clean();
    } else {
      this.logError(`! Unknown action \"${action}\".`);
      process.exit(1);
    }
  }

  executeBuild() {}

  build() {
    this.clean();
    this.execute(`mkdir -p "${this.buildPath}"`);
    this.executeBuild();
  }

  verify() {
    console.log("verify");
  }

  deploy() {
    console.log("deploy");
  }

  undeploy() {
    console.log("undeploy");
  }

  clean() {
    this.execute(`rm -rf "${this.buildPath}"`);
  }
};
