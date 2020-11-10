var HostArch = require("./Archs/HostArch");
var ArmArch = require("./Archs/ArmArch");
var Arm64Arch = require("./Archs/Arm64Arch");
var x86Arch = require("./Archs/x86Arch");
var x86_64Arch = require("./Archs/x86_64Arch");

module.exports = {
  host: new HostArch(),
  arm: new ArmArch(),
  arm64: new Arm64Arch(),
  x86: new x86Arch(),
  x86_64: new x86_64Arch(),
};
