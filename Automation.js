var Tool = require("./lib/Tool");
var LLVMBuilder = require("./lib/Builders/LLVMBuilder")
var SwiftStdLibBuilder = require("./lib/Builders/SwiftStdLibBuilder")
var SwiftBuilder = require("./lib/Builders/SwiftBuilder")
var CMarkBuilder = require("./lib/Builders/CMarkBuilder")

module.exports = class Automation extends Tool {
  run() {
    var args = process.argv.slice(2);
    var action = args[0];
    if (!action) {
      this.usage();
    } else {
      var components = action.split(":");
      if (components.length == 2) {
        this.runAction(components[0], components[1]);
      } else {
        this.usage();
      }
    }
  }

  runAction(component, action) {
    if (component == "llvm") {
      new LLVMBuilder().runAction(action)
    } else if (component == "stdlib") {
      this.archs.forEach(item => new SwiftStdLibBuilder(item).runAction(action))
    } else if (component == "swift") {
      new SwiftBuilder().runAction(action)
    } else if (component == "cmark") {
      new CMarkBuilder().runAction(action)
    } else {
      this.logError(`! Unknown component \"${component}\".`);
      this.usage();
    }
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

    this.print("Building certain component (i.e. llvm, icu, xml, ssl, curl, swift, dispatch, foundation):\n", 33);

    this.print("To build only certain component:", 32);
    this.print("   $ node main.js llvm:build\n", 36);

    this.print("To clean only certain component:", 32);
    this.print("   $ node main.js llvm:clean\n", 36);
  }
};
