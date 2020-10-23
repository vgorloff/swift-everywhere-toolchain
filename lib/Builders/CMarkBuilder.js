var Builder = require("../Builder");
var Component = require("../Components");
var Archs = require("../Archs");

module.exports = class CMarkBuilder extends Builder {
  constructor() {
    super(Component.cmark, Archs.host);
  }

  // See: $SWIFT_REPO/docs/WindowsBuild.md
  executeConfigure() {
    var cFlags = '-Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector'
    var cmd = `
      cd ${this.paths.builds} && cmake
      -G Ninja
      -D CMAKE_INSTALL_PREFIX=/
      -D CMAKE_BUILD_TYPE=Release
      -D CMARK_TESTS=false
      -D CMAKE_C_FLAGS="${cFlags}"
      -D CMAKE_CXX_FLAGS="${cFlags}"
      -D CMAKE_OSX_DEPLOYMENT_TARGET=10.9
      -D CMAKE_OSX_SYSROOT=${this.paths.xcMacOsSdkPath}
      ${this.paths.sources}
`;
    this.executeCommands(cmd);
  }

  executeBuild() {
    this.execute(`cd ${this.paths.builds} && ninja -j${this.numberOfJobs}`);
  }

  executeInstall() {
    this.execute(`DESTDIR=${this.paths.installs} cmake --build ${this.paths.builds} --target install`);
  }
};
