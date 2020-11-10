const Tool = require("../lib/Tool");
const ExecutableBuilder = require("./sample-exe/Builder");
const LibraryBuilder = require("./sample-lib/Builder");
const PackageBuilder = require("./sample-package/Builder");
const ADB = require("./ADB")

module.exports = class TestAutomation extends Tool {
  constructor() {
    super();
  }

  run() {
    var args = process.argv.slice(2);
    var action = args[0];
    if (!action) {
      this.usage();
      process.exit(1);
    } else {
      if (action == "verify") {
        this.verify()
      } else if (action == "clean") {
        this.clean()
      } else {
        var components = action.split(":");
        if (components.length == 2) {
          this.runComponentAction(components[0], components[1]);
        } else {
          this.usage();
          process.exit(1);
        }
      }
    }
  }

  /** @private */
  runComponentAction(component, action) {
    if (component == "exe") {
      this.archs.forEach((item) => new ExecutableBuilder(component, item).runAction(action));
    } else if (component == "lib") {
      this.archs.forEach((item) => new LibraryBuilder(component, item).runAction(action));
    } else if (component == "package") {
      this.archs.forEach((item) => new PackageBuilder(component, item).runAction(action));
    } else {
      this.logError(`! Unknown component \"${component}\".`);
      this.usage();
      process.exit(1);
    }
  }

  verify() {
    ADB.verify()
  }

  build() {
    this.runComponentAction("exe", "build")
    this.runComponentAction("lib", "build")
    this.runComponentAction("package", "build")
  }

  clean() {
    this.runComponentAction("exe", "clean")
    this.runComponentAction("lib", "clean")
    this.runComponentAction("package", "clean")
  }

  /** @private */
  usage() {
    this.print("\n1. Build project:", 32);
    this.print("   $ node main.js project:build\n", 36);
    this.print("   Where the `project` is one of: exe, lib, package\n", 36);

    this.print(
      "2. Enable USB Debugging on Android device. Install Android Tools for macOS. Connect Android device and Verify ADB shell setup.",
      32
    );
    var help = `
   $ node main.js verify

   References:
   - How to Install Android Tools for macOS: https://stackoverflow.com/questions/17901692/set-up-adb-on-mac-os-x
   - How to Enable USB Debugging on Android device: https://developer.android.com/studio/debug/dev-options
`;
    this.print(help, 36);

    this.print("3. Deploy and run project on Android Device or Simulator.", 32);
    var help = `
   $ node main.js project:deploy arch:armv7a
   $ node main.js project:deploy arch:aarch64
   $ node main.js project:deploy arch:x86
   $ node main.js project:deploy arch:x86_64
`;
    this.print(help, 36);

    this.print("4. (Optional) Clean deployed project:", 32);
    this.print("   $ node main.js project:undeploy arch:armv7a", 36);
    this.print("   $ node main.js project:undeploy arch:aarch64", 36);
    this.print("   $ node main.js project:undeploy arch:x86", 36);
    this.print("   $ node main.js project:undeploy arch:x86_64", 36);

    this.print("\n5. (Optional) Clean project:", 32);
    this.print("   $ node main.js project:clean\n", 36);
  }
};
