var Builder = require("../Builder");
var Component = require("../Components");
var NDK = require("../NDK");
var SwiftBuilder = require("./SwiftBuilder");
var SwiftStdLibBuilder = require("./SwiftStdLibBuilder");

module.exports = class DispatchBuilder extends Builder {
  constructor(/** @type {Arch} */ arch) {
    super(Component.dispatch, arch);
  }

  executeConfigure() {
    var ndk = new NDK();
    var swift = new SwiftBuilder();
    var stdlib = new SwiftStdLibBuilder(this.arch);

    var cFlags = ""
    // cFlags += "-v"
    var swiftFlags = ""
    // swiftFlags += " -v"
    swiftFlags += ` -resource-dir ${stdlib.paths.builds}/lib/swift -Xcc --sysroot=${ndk.sources}/sysroot -Xclang-linker --sysroot=${ndk.sources}/platforms/android-${ndk.api}/${this.arch.ndkPlatform} -Xclang-linker --gcc-toolchain=${ndk.toolchainPath}`

    var cmd = `
      cd ${this.paths.builds} && cmake
      -G Ninja
      # --debug-output

      -D ANDROID_ABI=${this.arch.ndkABI}
      -D ANDROID_PLATFORM=${ndk.platformName}
      -D CMAKE_TOOLCHAIN_FILE=${ndk.sources}/build/cmake/android.toolchain.cmake

      -D CMAKE_INSTALL_PREFIX=/
      -D CMAKE_BUILD_TYPE=Release

      -D ENABLE_TESTING=NO
      -D ENABLE_SWIFT=YES

      -D CMAKE_Swift_COMPILER=${swift.paths.builds}/bin/swiftc
      # Skipping Swift compiler check. See: /usr/local/Cellar/cmake/3.16.2/share/cmake/Modules/CMakeTestSwiftCompiler.cmake
      -D CMAKE_Swift_COMPILER_FORCED=true

      -D CMAKE_Swift_COMPILER_TARGET=${this.arch.swiftTarget}
      -D CMAKE_Swift_FLAGS="${swiftFlags}"
      -D CMAKE_C_FLAGS="${cFlags}"
      -D CMAKE_CXX_FLAGS="${cFlags}"

      -D CMAKE_BUILD_WITH_INSTALL_RPATH=true
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

  get libs() {
    return this.findLibs(`${this.paths.installs}/usr/lib/swift/android`)
  }
};
