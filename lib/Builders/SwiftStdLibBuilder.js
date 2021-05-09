/*
 * The MIT License
 *
 * Copyright (c) 2019 Volodymyr Gorlov (https://github.com/vgorloff)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

var path = require("path");

var Builder = require("../Builder");
var Component = require("../Components");
var Arch = require("../Archs/Arch");
var ICUBuilder = require("./ICUBuilder");
var LLVMBuilder = require("./LLVMBuilder");
var SwiftBuilder = require("./SwiftBuilder");
var NDK = require("../NDK");

module.exports = class SwiftStdLibBuilder extends Builder {
  constructor(/** @type {Arch} */ arch) {
    super(Component.stdlib, arch);
  }

  executeConfigure() {
    var icu = new ICUBuilder(this.arch);
    var ndk = new NDK();
    var llvm = new LLVMBuilder();
    var swift = new SwiftBuilder();
    var cFlags = ""; // -D__ANDROID_API__=21
    // cFlags += " -v";
    // cFlags += " -Xcc -v ";
    // cFlags += `-isystem ${this.paths.xcToolchainPath}/usr/include/c++/v1 -isysroot ${this.paths.xcMacOsSdkPath}`
    // cFlags += " -Xcc -v ";
    cFlags += ` -L${ndk.toolchainPath}/sysroot/usr/lib/${this.arch.ndkLibArchName}/${ndk.api}`;
    // cFlags += ` -I${ndk.toolchainPath}/sysroot/usr/include`;

    var swiftCompileFlags = `-sdk;${ndk.sources}/sysroot`;
    // swiftCompileFlags += ";-v"

    var cmd = `
    cd ${this.paths.builds} && cmake -G Ninja
    -D ANDROID_ABI=${this.arch.ndkABI}
    -D ANDROID_PLATFORM=${ndk.platformName}
    // -D ANDROID_TOOLCHAIN=clang
    // -D ANDROID_STL=c++_static
    -D CMAKE_TOOLCHAIN_FILE=${ndk.sources}/build/cmake/android.toolchain.cmake

    -D CMAKE_C_FLAGS="${cFlags}"
    -D CMAKE_CXX_FLAGS="${cFlags}"

    # LLVM
    -D LLVM_DIR=${llvm.paths.builds}/lib/cmake/llvm

    -D SWIFT_HOST_VARIANT_SDK=ANDROID
    -D SWIFT_HOST_VARIANT_ARCH=${this.arch.swiftArch}
    -D SWIFT_SDKS="ANDROID"
    -D SWIFT_STANDARD_LIBRARY_SWIFT_FLAGS="${swiftCompileFlags}"

    # Disabling builds of Darwin Overlays.
    -D SWIFT_BUILD_DYNAMIC_SDK_OVERLAY=TRUE
    -D SWIFT_BUILD_STATIC_SDK_OVERLAY=FALSE

    # build just the standard library
    -D SWIFT_INCLUDE_TOOLS=NO
    -D SWIFT_INCLUDE_TESTS=NO
    -D SWIFT_INCLUDE_DOCS=NO

    -D SWIFT_BUILD_SYNTAXPARSERLIB=NO
    -D SWIFT_BUILD_SOURCEKIT=NO

    # android configuration
    -D SWIFT_ANDROID_API_LEVEL=${ndk.api}
    -D SWIFT_ANDROID_NDK_PATH=${ndk.sources}
    -D SWIFT_ANDROID_NDK_GCC_VERSION=${ndk.gcc}

    # TODO(compnerd) we should fix the lld.exe spelling
    -D SWIFT_ENABLE_LLD_LINKER=FALSE
    -D SWIFT_ENABLE_GOLD_LINKER=TRUE

    -D SWIFT_ANDROID_${this.arch.swiftArch}_ICU_UC=${icu.paths.lib}/libicuucswift.so
    -D SWIFT_ANDROID_${this.arch.swiftArch}_ICU_UC_INCLUDE=${icu.paths.sources}/source/common
    -D SWIFT_ANDROID_${this.arch.swiftArch}_ICU_I18N=${icu.paths.lib}/libicui18nswift.so
    -D SWIFT_ANDROID_${this.arch.swiftArch}_ICU_I18N_INCLUDE=${icu.paths.sources}/source/i18n
    -D SWIFT_ANDROID_${this.arch.swiftArch}_ICU_DATA=${icu.paths.lib}/libicudataswift.so

    -D CMAKE_BUILD_TYPE=Release

    # build with the host compiler
    -D SWIFT_BUILD_RUNTIME_WITH_HOST_COMPILER=YES
    -D SWIFT_NATIVE_SWIFT_TOOLS_PATH=${swift.paths.builds}/bin

    // Workaround for build issue introduced in Swift 5.4
    // See file: Sources/swift/stdlib/public/runtime/CMakeLists.txt:214
    // Value "TRUE" doesn't make sense as we are not building static library, but it fixes build failure.
    -D SWIFT_ANDROID_${this.arch.swiftArch}_ICU_STATICLIB=TRUE

    -D CMAKE_INSTALL_PREFIX=/

    ${this.paths.sources}
`;

    this.executeCommands(cmd);
  }

  executeBuild() {
    this.execute(`cd ${this.paths.builds} && ninja -j${this.numberOfJobs}`);
  }

  executeInstall() {
    this.execute(`DESTDIR=${this.paths.installs} cmake --build ${this.paths.builds} --target install`);
    var libs = this.findLibs(`${this.paths.installs}/lib/swift/android`)
    libs.forEach((item) => this.execute(`mv -f "${item}" "${path.dirname(item)}/${this.arch.swiftArch}"`))
  }

  get libs() {
    return this.findLibs(`${this.paths.installs}/lib/swift/android/${this.arch.swiftArch}`)
  }
};
