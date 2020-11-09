var path = require("path");

const Tool = require("../lib/Tool");

module.exports = class ADB extends Tool {
  constructor(/** @type {String} */ executable, /** @type {[String]} */ libs) {
    super();
    this.executable = executable;
    this.libs = libs;
    this.component = path.basename(executable);
    this.destinationDirPath = `/data/local/tmp/sample-${this.component}`;
    this.binary = path.join(this.destinationDirPath, this.component);
  }

  static verify() {
    var tool = new Tool();

    // See: Enable adb debugging on your device – https://developer.android.com/studio/command-line/adb#Enabling
    // On linux `execute "sudo apt-get install android-tools-adb"`

    tool.execute("adb devices"); // To run daemon.
    tool.logMessage(
      'Make sure you are enabled "USB debugging" on Android device (See :https://developer.android.com/studio/command-line/adb#Enabling)'
    );
    tool.execute("adb devices"); // # To list devices.
  }

  deploy() {
    this.undeploy();
    this.logMessage("Deploy of Shared Objects started.");
    this.execute(`adb shell mkdir -p ${this.destinationDirPath}`);
    this.libs.forEach((item) => this.execute(`adb push ${item} ${this.destinationDirPath}`))
    this.execute(`adb push ${this.executable} ${this.destinationDirPath}`);
    this.logMessage("Deploy of Shared Objects completed.");
  }

  run() {
    this.execute(`adb shell ls -l ${this.destinationDirPath}`)
    this.logMessage(`Starting execution of "${this.binary}"...`)
    this.execute(`adb shell LD_LIBRARY_PATH=${this.destinationDirPath} ${this.binary}`)
    this.logMessage(`Execution of "${this.binary}" is completed.`)
  }

  undeploy() {
    this.execute(`adb shell rm -rf ${this.destinationDirPath}`);
  }
};
