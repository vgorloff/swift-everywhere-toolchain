var Builder = require("../Builder");
var Component = require("../Components");
var Arch = require("../Archs/Arch");
var NDK = require("../NDK");
var Archs = require("../Archs");

module.exports = class SSLBuilder extends Builder {
  constructor(/** @type {Arch} */ arch) {
    super(Component.ssl, arch);
    var ndk = new NDK();
    this.options = `ANDROID_NDK=${ndk.sources} PATH=${ndk.toolchainPath}/bin:$PATH`;
  }

  prepare() {
    // Unused at the moment.
  }

  executeConfigure() {
    this.clean();

    var ndk = new NDK();
    // Seems `-D__ANDROID_API__` not needed. See: #{@sources}/NOTES.ANDROID
    var cmd = `
    ${this.options}
    ./Configure
    -D__ANDROID_API__=${ndk.api}
    --prefix=${this.paths.installs}
    `;
    if (this.arch.name == Archs.arm.name) {
      cmd = `${cmd} android-arm`;
    } else if (this.arch.name == Archs.arm64.name) {
      cmd = `${cmd} android-arm64`;
    } else if (this.arch.name == Archs.x86.name) {
      cmd = `${cmd} android-x86`;
    } else if (this.arch.name == Archs.x86_64.name) {
      cmd = `${cmd} android-x86_64`;
    }
    this.executeCommands(`cd ${this.paths.sources} && ${cmd}`);
  }

  executeBuild() {
    this.executeCommands(`cd ${this.paths.sources} && ${this.options} make SHLIB_VERSION_NUMBER= SHLIB_EXT=.so`);
  }

  executeInstall() {
    this.executeCommands(
      `cd ${this.paths.sources} && ${this.options} make SHLIB_VERSION_NUMBER= SHLIB_EXT=.so install_sw install_ssldirs`
    );
  }

  get libs() {
    return this.findLibs(`${this.paths.installs}/lib`)
  }
};
