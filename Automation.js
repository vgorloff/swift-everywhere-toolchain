/*
 * The MIT License
 *
 * Copyright (c) 2019 Volodymyr Gorlov (https://github.com/vgorloff)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

const cp = require("child_process");
const path = require("path");
const fs = require("fs");

const Tool = require("./lib/Tool");
const Checkout = require("./lib/Git/Checkout");
const Paths = require("./lib/Paths");
const Components = require("./lib/Components");
const Config = require("./lib/Config");
const Installer = require("./lib/Installer");
const Settings = require("./lib/Settings");
const NDK = require("./lib/NDK");
const TestAutomation = require("./Tests/TestAutomation");

const LLVMBuilder = require("./lib/Builders/LLVMBuilder");
const SwiftStdLibBuilder = require("./lib/Builders/SwiftStdLibBuilder");
const SwiftBuilder = require("./lib/Builders/SwiftBuilder");
const CMarkBuilder = require("./lib/Builders/CMarkBuilder");
const DispatchBuilder = require("./lib/Builders/DispatchBuilder");
const FoundationBuilder = require("./lib/Builders/FoundationBuilder");
const ICUBuilder = require("./lib/Builders/ICUBuilder");
const ICUHostBuilder = require("./lib/Builders/ICUHostBuilder");
const XMLBuilder = require("./lib/Builders/XMLBuilder");
const CURLBuilder = require("./lib/Builders/CURLBuilder");
const SSLBuilder = require("./lib/Builders/SSLBuilder");
const SwiftTSCBuilder = require("./lib/Builders/SwiftTSCBuilder");
const LLBBuilder = require("./lib/Builders/LLBBuilder");
const SPMBuilder = require("./lib/Builders/SPMBuilder");
const SAPBuilder = require("./lib/Builders/SAPBuilder");
const YAMSBuilder = require("./lib/Builders/YAMSBuilder");
const SwiftDriverBuilder = require("./lib/Builders/SwiftDriverBuilder");
const SwiftCryptoBuilder = require("./lib/Builders/SwiftCryptoBuilder");

module.exports = class Automation extends Tool {
  run() {
    this.verifyXcodeAndExitIfNeeded();
    this.verifyNDKAndExitIfNeeded();
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
      this.build();
    } else if (action == "clean") {
      this.clean();
    } else if (action == "status") {
      this.status();
    } else if (action == "verify") {
      this.verify();
    } else if (action == "bootstrap") {
      this.bootstrap();
    } else if (action == "archive") {
      this.archive();
    } else if (action == "test") {
      this.test();
    } else if (action == "install") {
      this.install();
    } else if (action == "assets") {
      this.assets();
    } else if (action == "stage2") {
      this.stage2();
    } else if (action == "stage3") {
      this.stage3();
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
      new ICUHostBuilder().runAction(action);
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
    } else if (component == "tsc") {
      new SwiftTSCBuilder().runAction(action);
    } else if (component == "llb") {
      new LLBBuilder().runAction(action);
    } else if (component == "spm") {
      new SPMBuilder().runAction(action);
    } else if (component == "sap") {
      new SAPBuilder().runAction(action);
    } else if (component == "yams") {
      new YAMSBuilder().runAction(action);
    } else if (component == "sd") {
      new SwiftDriverBuilder().runAction(action);
    } else if (component == "sc") {
      new SwiftCryptoBuilder().runAction(action);
    } else {
      this.logError(`! Unknown component \"${component}\".`);
      this.usage();
    }
  }

  /** @private */
  build() {
    this.stage1();
    this.stage2();
    this.stage3();
  }

  /** @private */
  stage1() {
    this.runComponentAction("llvm", "make");
    this.runComponentAction("icu", "make");
    this.runComponentAction("xml", "make");
    this.runComponentAction("ssl", "make");
    this.runComponentAction("curl", "make");
  }

  /** @private */
  stage2() {
    this.runComponentAction("cmark", "make");
    this.runComponentAction("yams", "make");
    this.runComponentAction("sap", "make");
    this.runComponentAction("tsc", "make");
    this.runComponentAction("llb", "make");
    this.runComponentAction("sd", "make");
    this.runComponentAction("sc", "make");
    this.runComponentAction("spm", "make");
  }

  /** @private */
  stage3() {
    this.runComponentAction("swift", "make");
    this.runComponentAction("stdlib", "make");
    this.runComponentAction("dispatch", "make");
    this.runComponentAction("foundation", "make");
  }

  /** @private */
  clean() {
    this.runComponentAction("llvm", "clean");
    this.runComponentAction("cmark", "clean");
    this.runComponentAction("icu", "clean");
    this.runComponentAction("xml", "clean");
    this.runComponentAction("ssl", "clean");
    this.runComponentAction("curl", "clean");
    this.runComponentAction("swift", "clean");
    this.runComponentAction("stdlib", "clean");
    this.runComponentAction("dispatch", "clean");
    this.runComponentAction("foundation", "clean");
    this.runComponentAction("tsc", "clean");
    this.runComponentAction("llb", "clean");
    this.runComponentAction("spm", "clean");
    this.runComponentAction("sd", "clean");
    this.runComponentAction("sap", "clean");
    this.runComponentAction("yams", "clean");
  }

  /** @private */
  status() {
    var paths = [];
    paths.push(Paths.sourcesDirPath(Components.llvm));
    paths.push(Paths.sourcesDirPath(Components.cmark));
    paths.push(Paths.sourcesDirPath(Components.icu));
    paths.push(Paths.sourcesDirPath(Components.xml));
    paths.push(Paths.sourcesDirPath(Components.ssl));
    paths.push(Paths.sourcesDirPath(Components.curl));
    paths.push(Paths.sourcesDirPath(Components.swift));
    paths.push(Paths.sourcesDirPath(Components.dispatch));
    paths.push(Paths.sourcesDirPath(Components.foundation));
    paths.push(Paths.sourcesDirPath(Components.tsc));
    paths.push(Paths.sourcesDirPath(Components.llb));
    paths.push(Paths.sourcesDirPath(Components.spm));
    paths.forEach((path) => this.execute(`cd "${path}" && git status`));
  }

  /** @private */
  verify() {
    this.runComponentAction("icu", "verify");
    this.runComponentAction("xml", "verify");
    this.runComponentAction("ssl", "verify");
    this.runComponentAction("curl", "verify");
    this.runComponentAction("stdlib", "verify");
    this.runComponentAction("dispatch", "verify");
    this.runComponentAction("foundation", "verify");
  }

  /** @private */
  bootstrap() {
    this.runSimpleAction("checkout");
    this.build();
    this.install();
    this.archive();
    console.log("");
    this.print('"Swift Toolchain for Android" build is completed.', 33);
    this.print(`It can be found in "${Config.toolChainBuildOutput}".`, 33);
    console.log("");
  }

  /** @private */
  install() {
    new Installer().install();
  }

  /** @private */
  assets() {
    new Installer().copyAssets();
  }

  /** @private */
  archive() {
    this.print(`Compressing "${Config.toolChainBuildOutput}"`, 32);
    var baseName = path.basename(Config.toolChainBuildOutput);
    var extName = "tar.gz";
    var fileName = `${baseName}.${extName}`;
    this.execute(
      `cd "${path.dirname(Config.toolChainBuildOutput)}" && tar -czf ${fileName} --options='compression-level=9' ${baseName}`
    );
    this.print(`Archive saved to "${Config.toolChainBuildOutput}.${extName}"`, 36);
  }

  /** @private */
  test() {
    const tests = new TestAutomation();
    tests.build();
    tests.clean();
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

    this.print("Advanced:\n", 33);
    this.print("To see which commands will be executed for build without running build:", 32);
    this.print("   $ node main.js build --dry-run\n", 36);
  }

  /** @private */
  verifyXcodeAndExitIfNeeded() {
    var xcodeVersion = cp.execSync("xcodebuild -version").toString().trim();
    let version = xcodeVersion.split("\n").filter((comp) => comp.includes("Xcode"))[0];
    if (!version.includes(13)) {
      this.print("Please use Xcode 13.", 31);
      this.print("Your Xcode version seems too old or too new:", 36);
      this.print(xcodeVersion, 32);
      process.exit(1);
    }
  }

  /** @private */
  verifyNDKAndExitIfNeeded() {
    var ndkDir = Settings.ndkDir;
    var toolchainPath = new NDK().toolchainPath;
    if (!fs.existsSync(toolchainPath)) {
      this.logError(
        `! Please create symbolic link "${ndkDir}" which points to Android NDK installation version ${Settings.ndkVersion}.`
      );
      this.logMessage(`Usually Android NDK installation can be found at "~/Library/Android/sdk/ndk".`);
      this.logMessage(`Refer to files "Readme.md" and "NDK_VERSION" for details.`);
      process.exit(1);
    }
  }
};
