const cp = require("child_process");
const Archs = require("./Archs");

module.exports = class Tool {
  constructor() {
    this.platform = "darwin";

    this.archs = [Archs.arm];
    var args = process.argv.slice(2);
    var arg = args.filter((item) => item.startsWith("arch"))[0];
    if (arg) {
      var components = arg.split(":");
      if (components.length == 2) {
        var arch = components[1];
        var archsToBuild = this.archs.filter((item) => item.name == arch);
        if (archsToBuild.length > 0) {
          this.archs = archsToBuild;
        }
      }
    }
  }

  print(message, color) {
    // See: How to change node.js's console font color? - Stack Overflow: https://stackoverflow.com/questions/9781218/how-to-change-node-jss-console-font-color
    console.log(`\x1b[${color}m${message}\x1b[0m`);
  }

  logError(message) {
    this.print(message, 31); // Red color.
  }

  logInfo(message) {
    this.print(message, 36); // Light blue color.
  }

  logMessage(message) {
    this.print(message, 32); // Green color.
  }

  execute(command) {
    this.print(command, 32); // Green color.
    try {
      cp.execSync(command, { stdio: "inherit" });
    } catch (error) {
      this.logInfo("Execution of command is failed:");
      this.logError(command);
      var help = `
If error was due Memory, CPU, or Disk peak resource usage (i.e. missed file while file exists),
then try to run previous command again. Build process will perform "configure" step again,
but most of compilation steps will be skipped.
`;
      this.logMessage(help);
      throw error;
    }
  }

  executeCommands(/** @type {String} */ commands) {
    var lines = commands.split("\n").map((line) => line.trim());
    lines = lines.filter((line) => (line.startsWith("#") || line.startsWith("//") || line.length == 0) != true);
    this.execute(lines.join(" \\\n   "));
  }
};
