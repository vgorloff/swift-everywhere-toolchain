const cp = require("child_process");

var Tool = require("./Tool");
var Paths = require("./Paths");
var Component = require("./Components/Component");
var Arch = require("./Archs/Arch");

module.exports = class Builder extends Tool {
  constructor(/** @type {Component} */ component, /** @type {Arch} */ arch) {
    super();
    this.component = component;
    this.arch = arch;
    this.paths = new Paths(this.platform, component, arch);

    var physicalCPUs = parseInt(cp.execSync("sysctl -n hw.physicalcpu").toString().trim());
    this.numberOfJobs = Math.max(physicalCPUs - 1, 1);
  }

  runAction(action) {
    if (action == "build") {
      this.build();
    } else if (action == "install") {
      this.install();
    } else if (action == "configure") {
      this.configure();
    } else if (action == "clean") {
      this.clean();
    } else if (action == "rebuild") {
      this.rebuild();
    } else {
      throw `Unknown action: ${action}`;
    }
  }

  configure() {
    this.logStarted("Configure");
    this.prepare();
    this.unpatch();
    this.patch();
    this.executeConfigure();
    this.logCompleted("Configure");
  }

  build() {
    this.logStarted("Build");
    this.prepare();
    this.executeBuild();
    this.this.logCompleted("Build");
  }

  rebuild() {
    this.clean();
    this.make();
  }

  make() {
    this.configure();
    this.build();
    this.install();
    this.unpatch();
  }

  install() {
    this.logStarted("Install");
    this.removeInstalls();
    this.executeInstall();
    this.logCompleted("Install");
  }

  clean() {
    this.logStarted("Clean");
    this.unpatch();
    this.executeClean();
    this.removeBuilds();
    this.cleanGitRepo();
    this.logCompleted("Clean");
  }

  prepare() {
    this.execute(`mkdir -p "${this.paths.builds}"`);
  }

  /** @private */
  removeInstalls() {
    this.execute(`rm -rf "${this.paths.installs}"`);
  }

  /** @private */
  removeBuilds() {
    this.execute(`rm -rf "${this.paths.builds}/"*`);
    this.execute(`find "${this.paths.builds}" -type f | xargs -I{} rm -rf "{}"`);
  }

  /** @private */
  cleanGitRepo() {
    // See: https://stackoverflow.com/a/64966/1418981
    this.execute(`cd ${this.paths.sources} && git clean --quiet -f -x -d`);
    this.execute(`cd ${this.paths.sources} && git clean --quiet -f -X`);
  }

  patch() {
    this.configurePatches(true);
  }

  unpatch() {
    this.configurePatches(false);
  }

  configurePatches(/** @type {Boolean} */ shouldEnable) {
    // Base class does nothing
  }

  executeBuild() {}

  executeInstall() {}

  executeConfigure() {}

  executeClean() {}

  /** @private */
  logStarted(action) {
    console.log("");
    var startSpacer = ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>";
    this.print(startSpacer, 33);
    this.print(`"${this.component.name}" ${action} [${this.arch.name}] is started.`, 36);
  }

  /** @private */
  logCompleted(action) {
    var endSpacer = "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<";
    this.print(`"${this.component.name}" ${action} [${this.arch.name}] is completed.`, 36);
    this.print(endSpacer, 33);
    console.log("");
  }
};
