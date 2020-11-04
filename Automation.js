const cp = require("child_process");
var path = require('path');

var Tool = require("./lib/Tool");
var Checkout = require("./lib/Git/Checkout");
const Paths = require("./lib/Paths");
const Components = require("./lib/Components");
var Config = require("./lib/Config");

var LLVMBuilder = require("./lib/Builders/LLVMBuilder");
var SwiftStdLibBuilder = require("./lib/Builders/SwiftStdLibBuilder");
var SwiftBuilder = require("./lib/Builders/SwiftBuilder");
var CMarkBuilder = require("./lib/Builders/CMarkBuilder");
var DispatchBuilder = require("./lib/Builders/DispatchBuilder");
var FoundationBuilder = require("./lib/Builders/FoundationBuilder");
var ICUBuilder = require("./lib/Builders/ICUBuilder");
var ICUHostBuilder = require("./lib/Builders/ICUHostBuilder");
var XMLBuilder = require("./lib/Builders/XMLBuilder");
var CURLBuilder = require("./lib/Builders/CURLBuilder");
var SSLBuilder = require("./lib/Builders/SSLBuilder");

module.exports = class Automation extends Tool {
  run() {
    this.verifyXcodeAndExitIfNeeded()
    var args = process.argv.slice(2);
    var action = args[0];
    if (!action) {
      this.usage();
    } else {
      var components = action.split(":");
      if (components.length == 2) {
        this.runComponentAction(components[0], components[1]);
      } else {
        this.runSimpleAction(action);
      }
    }
  }

  /** @private */
  runSimpleAction(action) {
    if (action == "fetch") {
      new Checkout().fetch();
    } else if (action == "checkout") {
      new Checkout().checkout();
    } else if (action == "build") {
      this.build()
    } else if (action == "clean") {
      this.clean()
    } else if (action == "status") {
      this.status()
    } else if (action == "verify") {
      this.verify()
    } else if (action == "bootstrap") {
      this.bootstrap()
    } else if (action == "archive") {
      this.archive()
    } else if (action == "test") {
      this.test()
    } else {
      this.usage();
    }
  }

  /** @private */
  runComponentAction(component, action) {
    if (component == "llvm") {
      new LLVMBuilder().runAction(action);
    } else if (component == "stdlib") {
      this.archs.forEach((item) => new SwiftStdLibBuilder(item).runAction(action));
    } else if (component == "dispatch") {
      this.archs.forEach((item) => new DispatchBuilder(item).runAction(action));
    } else if (component == "foundation") {
      this.archs.forEach((item) => new FoundationBuilder(item).runAction(action));
    } else if (component == "icu") {
      new ICUHostBuilder().runAction(action)
      this.archs.forEach((item) => new ICUBuilder(item).runAction(action));
    } else if (component == "swift") {
      new SwiftBuilder().runAction(action);
    } else if (component == "cmark") {
      new CMarkBuilder().runAction(action);
    } else if (component == "xml") {
      this.archs.forEach((item) => new XMLBuilder(item).runAction(action));
    } else if (component == "ssl") {
      this.archs.forEach((item) => new SSLBuilder(item).runAction(action));
    } else if (component == "curl") {
      this.archs.forEach((item) => new CURLBuilder(item).runAction(action));
    } else {
      this.logError(`! Unknown component \"${component}\".`);
      this.usage();
    }
  }

  /** @private */
  build() {
    this.runComponentAction("llvm", "make")
    this.runComponentAction("cmark", "make")
    this.runComponentAction("icu", "make")
    this.runComponentAction("xml", "make")
    this.runComponentAction("ssl", "make")
    this.runComponentAction("curl", "make")
    this.runComponentAction("swift", "make")
    this.runComponentAction("stdlib", "make")
    this.runComponentAction("dispatch", "make")
    this.runComponentAction("foundation", "make")
  }

  /** @private */
  clean() {
    this.runComponentAction("llvm", "clean")
    this.runComponentAction("cmark", "clean")
    this.runComponentAction("icu", "clean")
    this.runComponentAction("xml", "clean")
    this.runComponentAction("ssl", "clean")
    this.runComponentAction("curl", "clean")
    this.runComponentAction("swift", "clean")
    this.runComponentAction("stdlib", "clean")
    this.runComponentAction("dispatch", "clean")
    this.runComponentAction("foundation", "clean")
  }

  /** @private */
  status() {
    var paths = []
    paths.push(Paths.sourcesDirPath(Components.llvm))
    paths.push(Paths.sourcesDirPath(Components.cmark))
    paths.push(Paths.sourcesDirPath(Components.icu))
    paths.push(Paths.sourcesDirPath(Components.xml))
    paths.push(Paths.sourcesDirPath(Components.ssl))
    paths.push(Paths.sourcesDirPath(Components.curl))
    paths.push(Paths.sourcesDirPath(Components.swift))
    paths.push(Paths.sourcesDirPath(Components.dispatch))
    paths.push(Paths.sourcesDirPath(Components.foundation))
    paths.forEach((path) => this.execute(`cd "${path}" && git status`))
  }

  /** @private */
  verify() {
    this.runComponentAction("icu", "verify")
    this.runComponentAction("xml", "verify")
    this.runComponentAction("ssl", "verify")
    this.runComponentAction("curl", "verify")
    this.runComponentAction("stdlib", "verify")
    this.runComponentAction("dispatch", "verify")
    this.runComponentAction("foundation", "verify")
  }

  /** @private */
  bootstrap() {
    this.runSimpleAction("checkout")
    this.build()
    this.install()
    this.archive()
    console.log("")
    this.print("\"Swift Toolchain for Android\" build is completed.", 33)
    this.print(`It can be found in "${Config.toolChainBuildOutput}".`, 33)
    console.log("")
  }

  /** @private */
  install() {

  }

  /** @private */
  archive() {
    this.print(`Compressing "${Config.toolChainBuildOutput}"`, 32)
    var baseName = path.basename(Config.toolChainBuildOutput)
    var extName = 'tar.gz'
    var fileName = `${baseName}.${extName}`
    this.execute(`cd "${path.dirname(Config.toolChainBuildOutput)}" && tar -czf ${fileName} --options='compression-level=9' ${baseName}`)
    this.print(`Archive saved to "${Config.toolChainBuildOutput}.${extName}"`, 36)
  }

  /** @private */
  test() {
    console.log("Test")
  }

  /** @private */
  usage() {
    this.print("\nBuilding Toolchain with One Action:\n", 33);

    this.print("   $ node main.js bootstrap\n", 36);

    this.print("Building Toolchain Step-by-Step:\n", 33);

    this.print("1. Checkout sources:", 32);
    this.print("   $ node main.js checkout\n", 36);

    this.print("2. Build toolchain:", 32);
    this.print("   $ node main.js build\n", 36);

    this.print("3. Install toolchain:", 32);
    this.print("   $ node main.js install\n", 36);

    this.print("4. Archive toolchain:", 32);
    this.print("   $ node main.js archive\n", 36);

    this.print("5. (Optional) Verify toolchain build:", 32);
    this.print("   $ node main.js test\n", 36);

    this.print("6. (Optional) Clean toolchain build:", 32);
    this.print("   $ node main.js clean\n", 36);

    this.print("Building certain component (i.e. llvm, icu, xml, ssl, curl, swift, stdlib, dispatch, foundation):\n", 33);

    this.print("To build only certain component:", 32);
    this.print("   $ node main.js llvm:build\n", 36);

    this.print("To clean only certain component:", 32);
    this.print("   $ node main.js llvm:clean\n", 36);
  }

  /** @private */
  verifyXcodeAndExitIfNeeded() {
    var xcodeVersion = cp.execSync("xcodebuild -version").toString().trim()
    let version = xcodeVersion.split("\n").filter((comp) => comp.includes("Xcode"))[0]
    if (!version.includes(12)) {
      this.print("Please use Xcode 12.", 31)
      this.print("Your Xcode version seems too old or too new:", 36)
      this.print(xcodeVersion, 32)
      process.exit(1)
    }
  }
};
