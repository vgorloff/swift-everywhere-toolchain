var ICUBaseBuilder = require("./ICUBaseBuilder");
const Archs = require("../Archs");

module.exports = class ICUHostBuilder extends ICUBaseBuilder {
  constructor() {
    super(Archs.host);
  }

  executeConfigure() {
    var hostSystem = "MacOSX"; // Other option "Linux"

    var cmd = `cd ${this.paths.builds} &&
    CFLAGS='-Os'
    CXXFLAGS='--std=c++11'
    ${this.paths.sources}/source/runConfigureICU ${hostSystem} --prefix=${this.paths.installs}

    // Below option should not be set. Otherwize you will have ICU without embed data.
    // See:
    // - ICU Data - ICU User Guide: http://userguide.icu-project.org/icudata#TOC-Building-and-Linking-against-ICU-data
    // - https://forums.swift.org/t/partial-nightlies-for-android-sdk/25909/43?u=v.gorlov
    // --enable-tools=no

    --enable-static --enable-shared=no --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no
    --enable-layoutex=no --enable-tests=no --enable-samples=no --enable-dyload=no
`;
    this.executeCommands(cmd);
  }

  executeBuild() {
    this.execute(`cd ${this.paths.builds} && make`);
  }

  executeInstall() {
    this.logInfo("ICU Host Build not require to install. It is just used for `Cross Compilation`.");
  }
};
