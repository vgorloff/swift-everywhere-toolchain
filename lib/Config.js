var path = require("path");
var Location = require("./Location");

var projectDirPath = path.dirname(path.resolve(__dirname));

module.exports = {
  root: projectDirPath,
  toolChain: path.join(projectDirPath, Location.toolChain),
  toolChainBuildOutput: path.join(projectDirPath, Location.toolChain, "swift-android-toolchain"),
};
