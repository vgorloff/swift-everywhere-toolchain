var path = require("path");

var Builder = require("../Builder");
var Component = require("../Components");
var NDK = require("../NDK");
var SwiftBuilder = require("./SwiftBuilder");
var SwiftStdLibBuilder = require("./SwiftStdLibBuilder");
var DispatchBuilder = require("./DispatchBuilder");
var XMLBuilder = require("./XMLBuilder");
var CURLBuilder = require("./CURLBuilder");
var ICUBuilder = require("./ICUBuilder");

module.exports = class FoundationBuilder extends Builder {
  constructor(/** @type {Arch} */ arch) {
    super(Component.foundation, arch);
  }

  executeConfigure() {
    var ndk = new NDK();
    var swift = new SwiftBuilder();
    var stdlib = new SwiftStdLibBuilder(this.arch);
    var dispatch = new DispatchBuilder(this.arch);
    var xml = new XMLBuilder(this.arch);
    var curl = new CURLBuilder(this.arch);
    var icu = new ICUBuilder(this.arch);

    var cFlags = "";
    // cFlags += "-v -Xlinker -v"
    // cFlags += " -Xlinker --exclude-libs -Xlinker ALL"
    var swiftFlags = "";
    // swiftFlags += " -v"
    swiftFlags += ` -resource-dir ${stdlib.paths.builds}/lib/swift -Xcc --sysroot=${ndk.sources}/sysroot -Xclang-linker --sysroot=${ndk.sources}/platforms/android-${ndk.api}/${this.arch.ndkPlatform} -Xclang-linker --gcc-toolchain=${ndk.toolchainPath}`
    // swiftFlags += ` -L ${ndk.toolchainPath}/sysroot/usr/lib/${this.arch.ndkLibArchName}`

    var cmd = `
    cd ${this.paths.builds} && cmake
    -G Ninja
    # --debug-output

    // -D CMAKE_SYSTEM_NAME=Android
    -D ANDROID_ABI=${this.arch.ndkABI}
    -D ANDROID_PLATFORM=${ndk.platformName}
    -D CMAKE_TOOLCHAIN_FILE=${ndk.sources}/build/cmake/android.toolchain.cmake
    // -D CMAKE_ANDROID_STL_TYPE=c++_shared
    // -D ANDROID_STL=c++_shared
    // -D CMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang

    -D CMAKE_INSTALL_PREFIX=/
    -D CMAKE_BUILD_TYPE=Release
    -D ENABLE_TESTING=NO

    -D CMAKE_Swift_COMPILER=${swift.paths.builds}/bin/swiftc
    # Skipping Swift compiler check. See: /usr/local/Cellar/cmake/3.16.2/share/cmake/Modules/CMakeTestSwiftCompiler.cmake
    -D CMAKE_Swift_COMPILER_FORCED=true

    -D CMAKE_Swift_COMPILER_TARGET=${this.arch.swiftTarget}
    -D CMAKE_Swift_FLAGS="${swiftFlags}"
    -D CMAKE_C_FLAGS="${cFlags}"
    -D CMAKE_CXX_FLAGS="${cFlags}"

    -D CMAKE_BUILD_WITH_INSTALL_RPATH=true
    -D CMAKE_HAVE_LIBC_PTHREAD=YES

    // Dispatch
    -D dispatch_DIR=${dispatch.paths.builds}/cmake/modules

    // XML
    -D LIBXML2_INCLUDE_DIR=${xml.paths.installs}/include/libxml2
    -D LIBXML2_LIBRARY=${xml.paths.installs}/lib/libxml2.so

    // CURL
    -D CURL_INCLUDE_DIR=${curl.paths.installs}/include
    -D CURL_LIBRARY=${curl.paths.installs}/lib/libcurl.so

    // ICU
    -D ICU_INCLUDE_DIR=${icu.paths.installs}/include
    -D ICU_I18N_LIBRARY_RELEASE=${icu.paths.installs}/lib/libicui18nswift.so
    -D ICU_UC_LIBRARY_RELEASE=${icu.paths.installs}/lib/libicuucswift.so

    ${this.paths.sources}
`;

    this.executeCommands(cmd);
  }

  configurePatches(/** @type {Boolean} */ shouldEnable) {
    this.configurePatch(`${this.paths.patches}/Sources/CMakeLists.txt.diff`, shouldEnable)
  }

  executeBuild() {
    this.execute(`cd ${this.paths.builds} && ninja -j${this.numberOfJobs}`);
  }

  executeInstall() {
    this.patch()
    this.execute(`DESTDIR=${this.paths.installs} cmake --build ${this.paths.builds} --target install`);
    this.unpatch()
    var libs = this.findLibs(`${this.paths.installs}/lib/swift/android`)
    libs.forEach((item) => this.execute(`mv -f "${item}" "${path.dirname(item)}/${this.arch.swiftArch}"`))
  }

  get libs() {
    return this.findLibs(`${this.paths.installs}/lib/swift/android/${this.arch.swiftArch}`)
  }
};
