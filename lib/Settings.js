var path = require("path");
const Config = require("./Config");
var fs = require("fs");

const ndkVersion = fs.readFileSync(path.join(Config.root, "NDK_VERSION"), "utf8").toString().trim();
module.exports = {
  version: fs.readFileSync(path.join(Config.root, "VERSION"), "utf8").toString().trim(),
  ndkVersion: ndkVersion,
  ndkDir: `/usr/local/ndk/${ndkVersion}`,
};
