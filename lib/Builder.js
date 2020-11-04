const cp = require("child_process");
var fs = require("fs");

var Tool = require("./Tool");
var Paths = require("./Paths");
var Component = require("./Components/Component");
var Arch = require("./Archs/Arch");
var Config = require("./Config");

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
    } else if (action == "patch") {
      this.patch();
    } else if (action == "unpatch") {
      this.unpatch();
    } else if (action == "reset") {
      this.reset();
    } else if (action == "make") {
      this.make();
    } else if (action == "verify") {
      this.verify();
    } else {
      throw `Unknown action: ${action}`;
    }
  }

  get libs() {
    return [];
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
    this.logCompleted("Build");
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

  verify() {
    var command = "greadelf";
    var aliasValue = "";
    try {
      aliasValue = cp.execSync(`/bin/bash -lc "alias ${command}"`).toString().trim();
      aliasValue = aliasValue.replace(/\s*alias\s+greadelf\s*=\s*/i, "");
    } catch (error) {
      this.logMessage(`Skipping verification of so-files due non existed shell alias to "${command}".`);
      this.logMessage(
        `You can install "binutils" via \`brew install binutils\`, and then make an alias with \`alias greadelf="YOUR_BREW_ROOT/opt/binutils/bin/greadelf"\``
      );
      throw error;
    }
    this.libs.forEach((lib) => this.verifyLibrary(aliasValue, lib));
  }

  /** @private */
  verifyLibrary(executable, lib) {
    this.logMessage(`Checking ${lib}`);
    var command = `${executable} -d ${lib}`;
    var output = cp.execSync(`${command}`).toString().trim();
    var lines = output.split("\n");
    lines = lines.filter((line) => line.includes("NEEDED") || line.includes("SONAME"));
    lines.forEach((line) => {
      console.log(line);
      var match = line.match(/\[(.+)\]/i);
      var fileName = match[1];
      if (!fileName.endsWith(".so")) {
        this.logError("Unexpected library name!");
        this.logError(line);
        throw "Library name should not contain version suffixes.";
      }
    });
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

  reset() {
    this.execute(`cd ${this.paths.sources} && git status && git reset --hard`);
    this.cleanGitRepo();
  }

  findLibs(/** @type {String} */ dirPath) {
    var libs = cp.execSync(`find ${dirPath} -iname *.so -depth 1`).toString().trim().split("\n")
    return libs
  }

  configurePatch(/** @type {String} */ patchFile, /** @type {Boolean} */ shouldApply) {
    var originalFile = patchFile.replace(this.paths.patches, this.paths.sources).replace(".diff", "");
    var backupFile = `${originalFile}.orig`;
    var diffFile = `${originalFile}.diff`;
    if (shouldApply) {
      if (!fs.existsSync(backupFile)) {
        this.logInfo(`Patching \"${this.component.name}\"...`);
        this.execute(`patch --backup ${originalFile} ${patchFile}`);
        this.execute(`diff -u ${backupFile} ${originalFile} > ${diffFile} | true`);
      } else {
        this.logInfo(`Backup file \"${backupFile}\" exists. Seems you already patched \"${this.component.name}\". Skipping...`);
      }
    } else {
      this.logInfo("Removing previously applied patch...");
      this.execute(`cd "${this.paths.sources}" && git checkout ${originalFile}`);
      if (fs.existsSync(backupFile)) {
        this.execute(`rm -fv ${backupFile}`);
      }
      if (fs.existsSync(diffFile)) {
        this.execute(`rm -fv ${diffFile}`);
      }
    }
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
