var Builder = require("../Builder");
var Component = require("../Components");
var NDK = require("../NDK");
var SwiftBuilder = require("./SwiftBuilder");
var SwiftStdLibBuilder = require("./SwiftStdLibBuilder");

module.exports = class FoundationBuilder extends Builder {
  constructor(/** @type {Arch} */ arch) {
    super(Component.foundation, arch);
  }

  executeConfigure() {
    var ndk = new NDK();
    var swift = new SwiftBuilder();
    var stdlib = new SwiftStdLibBuilder(this.arch);

    var cmd = `
    cd ${this.paths.builds} && cmake
    -G Ninja
    # --debug-output

    ${this.paths.sources}
`;

    this.executeCommands(cmd);
  }
};
