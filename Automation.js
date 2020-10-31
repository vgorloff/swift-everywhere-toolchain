var Tool = require("./lib/Tool");
var LLVMBuilder = require("./lib/Builders/LLVMBuilder");
var SwiftStdLibBuilder = require("./lib/Builders/SwiftStdLibBuilder");
var SwiftBuilder = require("./lib/Builders/SwiftBuilder");
var CMarkBuilder = require("./lib/Builders/CMarkBuilder");
var DispatchBuilder = require("./lib/Builders/DispatchBuilder");
var FoundationBuilder = require("./lib/Builders/FoundationBuilder");
var ICUBuilder = require("./lib/Builders/ICUBuilder");
var Checkout = require("./lib/Git/Checkout");
const Paths = require("./lib/Paths");
const Components = require("./lib/Components");

module.exports = class Automation extends Tool {
  run() {
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
    } else {
      this.usage();
    }
  }

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
    } else {
      this.logError(`! Unknown component \"${component}\".`);
      this.usage();
    }
  }

  build() {
    this.runComponentAction("llvm", "build")
    this.runComponentAction("cmark", "build")
    this.runComponentAction("icu", "build")
    this.runComponentAction("xml", "build")
    this.runComponentAction("ssl", "build")
    this.runComponentAction("curl", "build")
    this.runComponentAction("swift", "build")
    this.runComponentAction("stdlib", "build")
    this.runComponentAction("dispatch", "build")
    this.runComponentAction("foundation", "build")
  }

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
};
