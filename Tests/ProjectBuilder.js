var path = require("path");
const cp = require("child_process");

const Tool = require("../lib/Tool");
const Arch = require("../lib/Archs/Arch");
const Config = require("../lib/Config");
const ADB = require("./ADB");

module.exports = class ProjectBuilder extends Tool {
  constructor(/** @type {String} */ component, /** @type {Arch} */ arch) {
    super();
    var args = process.argv.slice(2);
    this.isVerbose = args.filter((item) => item == "--verbose").length > 0;

    this.arch = arch;
    this.component = component;
    this.rootPath = path.join(Config.root, "Tests", `sample-${component}`);
    this.sourcesPath = path.join(this.rootPath, "Sources");
    this.buildPath = path.join(this.rootPath, "build", arch.name);
    this.binariesDirPath = path.join(Config.root, "Assets");
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
    this.swftcCmdPath = `${this.binariesDirPath}/swiftc-${this.ndkArchPath} -module-cache-path ${this.buildPath}/ModuleCache`;
    this.copyLibsCmdPath = `${this.binariesDirPath}/copy-libs-${this.ndkArchPath}`;

    this.swiftBuildCmd = `${this.binariesDirPath}/swift-build-${this.ndkArchPath} --build-path "${this.buildPath}"`;

    if (this.isVerbose) {
      this.swftcCmdPath += " -v -Xcc -v";
      this.copyLibsCmdPath += " -v";
      this.swiftBuildCmd += " -v";
    }

    this.binary = `${this.buildPath}/${this.component}`;
    this.libsDirPath = path.join(this.buildPath, "libs");
  }

  runAction(/** @type {String} */ action) {
    if (action == "build") {
      this.build();
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

  copyLibs() {
    this.execute(`rm -rf "${this.libsDirPath}"`);
    this.execute(`${this.copyLibsCmdPath} -output "${this.libsDirPath}"`);
  }

  get libs() {
    var libs = cp.execSync(`find "${this.libsDirPath}" -iname *.so -depth 1 || true`).toString().trim().split("\n");
    return libs;
  }

  deploy() {
    let adb = new ADB(this.binary, this.libs);
    adb.deploy();
    adb.run();
  }

  undeploy() {
    new ADB(this.binary, this.libs).undeploy();
  }

  build() {
    this.clean();
    this.execute(`mkdir -p "${this.buildPath}"`);
    this.executeBuild();
  }

  clean() {
    this.execute(`rm -rf "${this.buildPath}"`);
  }
};
