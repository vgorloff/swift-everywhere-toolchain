var fs = require("fs");
var path = require("path");
const cp = require("child_process");

var Tool = require("./Tool");
var Config = require("./Config");
var Paths = require("./Paths");
var Components = require("./Components");
var Folder = require("./Folder");
var DispatchBuilder = require("./Builders/DispatchBuilder");
var FoundationBuilder = require("./Builders/FoundationBuilder");
var SwiftStdLibBuilder = require("./Builders/SwiftStdLibBuilder");
var SwiftBuilder = require("./Builders/SwiftBuilder");
var XMLBuilder = require("./Builders/XMLBuilder");
var SSLBuilder = require("./Builders/SSLBuilder");
var CURLBuilder = require("./Builders/CURLBuilder");
var ICUBuilder = require("./Builders/ICUBuilder");

module.exports = class Installer extends Tool {
  install() {
    var toolchainDir = Config.toolChainBuildOutput;
    this.print(`Installing toolchain into "${toolchainDir}"`, 32);

    if (fs.existsSync(toolchainDir)) {
      fs.rmdirSync(toolchainDir, { recursive: true });
    }
    fs.mkdirSync(toolchainDir, { recursive: true });

    this.copyToolchainFiles();
    // this.fixModuleMaps(); // Not needed anymore.
    this.copyAssets();
    this.copyLicenses();
    this.print(`Toolchain installed into "${toolchainDir}"`, 36);
  }

  copyToolchainFiles() {
    var dstDir = path.join(Config.toolChainBuildOutput, "usr");
    this.archs.forEach((arch) => {
      new DispatchBuilder(arch).copyTo(dstDir);
      new FoundationBuilder(arch).copyTo(dstDir);
      new SwiftStdLibBuilder(arch).copyTo(dstDir);
      new SwiftBuilder(arch).copyTo(dstDir);
      new XMLBuilder(arch).copyLibsTo(dstDir);
      new SSLBuilder(arch).copyLibsTo(dstDir);
      new CURLBuilder(arch).copyLibsTo(dstDir);
      new ICUBuilder(arch).copyLibsTo(dstDir);
    });
  }

  fixModuleMaps() {
    var moduleMaps = cp
      .execSync(`find "${Config.toolChainBuildOutput}/usr/lib/swift" -iname glibc.modulemap`)
      .toString()
      .trim()
      .split("\n");
    moduleMaps.forEach((file) => {
      this.logMessage(`* Correcting "${file}"`);
      var contents = fs.readFileSync(file, "utf8").toString();
      contents = contents.replace(/header\s+\".+sysroot/g, `header \"/usr/local/ndk/${Config.ndkVersion}/sysroot`)
      fs.writeFileSync(file, contents)
    });
  }

  copyAssets() {
    var toolchainDir = Config.toolChainBuildOutput;
    this.execute(`cp -f "${Config.root}/CHANGELOG" ${toolchainDir}`);
    this.execute(`cp -f "${Config.root}/VERSION" ${toolchainDir}`);
    this.execute(`cp -f "${Config.root}/LICENSE.txt" ${toolchainDir}`);
    this.execute(`cp -f "${Config.root}/Assets/Readme.md" ${toolchainDir}`);
    this.execute(`mkdir -p "${toolchainDir}/usr/bin"`);

    var output = cp.execSync(`find "${Config.root}/Assets" -type f`).toString().trim().split("\n");
    output = output.filter((item) => !item.endsWith("Readme.md"));
    output.forEach((item) => {
      this.execute(`cp -f "${item}" "${toolchainDir}/usr/bin"`);
    });
  }

  copyLicenses() {
    var toolchainDir = Config.toolChainBuildOutput;
    var sourcesDir = path.join(Config.toolChain, Folder.sources);
    var files = [];
    files.push(`${Paths.sourcesDirPath(Components.cmark)}/COPYING`);
    files.push(`${Paths.sourcesDirPath(Components.curl)}/COPYING`);
    files.push(`${Paths.sourcesDirPath(Components.icu)}/icu4c/LICENSE`);
    files.push(`${Paths.sourcesDirPath(Components.llvm)}/LICENSE.TXT`);
    files.push(`${Paths.sourcesDirPath(Components.llvm)}/clang/LICENSE.TXT`);
    files.push(`${Paths.sourcesDirPath(Components.llvm)}/compiler-rt/LICENSE.TXT`);
    files.push(`${Paths.sourcesDirPath(Components.ssl)}/LICENSE`);
    files.push(`${Paths.sourcesDirPath(Components.dispatch)}/LICENSE`);
    files.push(`${Paths.sourcesDirPath(Components.foundation)}/LICENSE`);
    files.push(`${Paths.sourcesDirPath(Components.xml)}/Copyright`);
    // files.push(`${Paths.sourcesDirPath(Components.swift)}/LICENSE.txt`) // Already copied by StdLib builder.
    files.forEach((file) => {
      var dst = file.replace(sourcesDir, `${toolchainDir}/usr/share`);
      fs.mkdirSync(path.dirname(dst), { recursive: true });
      this.execute(`cp -f "${file}" ${dst}`);
    });
  }
};