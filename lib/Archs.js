var HostArch = require("./Archs/HostArch");
var ArmArch = require("./Archs/ArmArch");

module.exports = {
  host: new HostArch(),
  arm: new ArmArch(),
};
