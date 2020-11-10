var path = require("path");
const cp = require("child_process");
var fs = require("fs");

var Tool = require("../Tool");
var Components = require("../Components");
var Component = require("../Components/Component");
var Paths = require("../Paths");
var Config = require("../Config");

module.exports = class Checkout extends Tool {
  constructor() {
    super();
  }

  checkout() {
    this.checkoutIfNeeded(Components.llvm);
    this.checkoutIfNeeded(Components.swift);
    this.checkoutIfNeeded(Components.foundation);
    this.checkoutIfNeeded(Components.dispatch);
    this.checkoutIfNeeded(Components.cmark);
    this.checkoutIfNeeded(Components.icu);
    this.checkoutIfNeeded(Components.ssl);
    this.checkoutIfNeeded(Components.curl);
    this.checkoutIfNeeded(Components.xml);
    // this.checkoutIfNeeded("#{Config.sources}/#{Lib.spm}", "https://github.com/apple/swift-package-manager.git", Revision.spm)
    // this.checkoutIfNeeded("#{Config.sources}/#{Lib.llb}", "https://github.com/apple/swift-llbuild.git", Revision.llb)
  }

  fetch() {
    this.fetchIfNeeded(Components.llvm);
    this.fetchIfNeeded(Components.swift);
    this.fetchIfNeeded(Components.foundation);
    this.fetchIfNeeded(Components.dispatch);
    this.fetchIfNeeded(Components.cmark);
    this.fetchIfNeeded(Components.icu);
    this.fetchIfNeeded(Components.ssl);
    this.fetchIfNeeded(Components.curl);
    this.fetchIfNeeded(Components.xml);
  }

  /** @private */
  fetchIfNeeded(/** @type {Component} */ component) {
    this.logInfo(`Fetching [${component.name}]...`);
    var localPath = Paths.sourcesDirPath(component);
    if (fs.existsSync(localPath)) {
      this.execute(`cd "${localPath}" && git fetch --prune --prune-tags origin`);
    } else {
      this.checkoutIfNeeded(component);
    }
  }

  /** @private */
  checkoutIfNeeded(/** @type {Component} */ component) {
    // this.logInfo(`Checking out [${component.name}]...`);
    var localPath = Paths.sourcesDirPath(component);
    if (fs.existsSync(localPath)) {
      var cmd = `cd "${localPath}" && git rev-parse --verify HEAD`;
      var sha = cp.execSync(cmd).toString().trim();
      var cmd = `cd "${localPath}" && git branch | grep \\* | cut -d ' ' -f2`;
      var branch = cp.execSync(cmd).toString().trim();
      var expectedBranchName = this.branchName(component.revision);
      if (component.revision == sha && expectedBranchName == branch) {
        this.logMessage(`Repository "${component.repository}" already checked out to "${localPath}".`);
      } else {
        this.checkoutRevision(localPath, component.revision);
        this.logMessage(`${localPath} updated to revision ${component.revision}.`);
      }
    } else {
      this.execute(`mkdir -p "${localPath}"`);
      // Checking out specific SHA - https://stackoverflow.com/a/43136160/1418981
      this.execute(`cd "${localPath}" && git init && git remote add origin "${component.repository}"`);
      this.checkoutRevision(localPath, component.revision);
      this.logMessage(`${component.repository} checkout to \"${localPath}\" is completed.`);
    }
  }

  /** @private */
  checkoutRevision(localPath, revision) {
    var branch = this.branchName(revision);
    this.logMessage(`Checking out revision ${revision}`);
    this.execute(`cd "${localPath}" && git fetch --prune --prune-tags origin`);
    // Disable warning about detached HEAD - https://stackoverflow.com/a/45652159/1418981
    this.execute(`cd "${localPath}" && git -c advice.detachedHead=false checkout ${revision}`);
    this.execute(`cd "${localPath}" && git branch -f ${branch}`);
    this.execute(`cd "${localPath}" && git checkout ${branch}`);
  }

  /** @private */
  branchName(/** @type {String} */ revision) {
    var version = fs.readFileSync(path.join(Config.root, "VERSION"), "utf8").toString().trim();
    return `st-v${version}@sha-` + revision.substring(0, 16);
  }
};
