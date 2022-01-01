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

var Builder = require("../Builder");
var Component = require("../Components");
var Archs = require("../Archs");
var NDK = require("../NDK");
var LLVMBuilder = require("./LLVMBuilder");
var CMarkBuilder = require("./CMarkBuilder");
var ICUBuilder = require("./ICUBuilder");

module.exports = class SwiftBuilder extends Builder {
  constructor() {
    super(Component.swift, Archs.host);
  }

  executeConfigure() {
    var ndk = new NDK();
    var cmark = new CMarkBuilder();
    var llvm = new LLVMBuilder();

    const DispatchBuilder = require("./DispatchBuilder");
    const dispatch = new DispatchBuilder(Archs.arm); // Any arch is OK. We are interesting only in Sources location.

    var swiftArchsToBuild = this.archs.map((arch) => arch.swiftArch).join(";");
    var icuArgs = this.archs
      .map((arch) => {
        var icu = new ICUBuilder(arch);
        var arg = `
        -D SWIFT_ANDROID_${arch.swiftArch}_ICU_UC=${icu.paths.installs}/lib/libicuucswift.so
        -D SWIFT_ANDROID_${arch.swiftArch}_ICU_UC_INCLUDE=${icu.paths.sources}/source/common
        -D SWIFT_ANDROID_${arch.swiftArch}_ICU_I18N=${icu.paths.installs}/lib/libicui18nswift.so
        -D SWIFT_ANDROID_${arch.swiftArch}_ICU_I18N_INCLUDE=${icu.paths.sources}/source/i18n
        -D SWIFT_ANDROID_${arch.swiftArch}_ICU_DATA=${icu.paths.installs}/lib/libicudataswift.so
    `;
        return arg;
      })
      .join("\n");

    var cFlags = "";
    // cFlags += " -v -Xcc -v ";
    cFlags += `-isystem ${this.paths.xcToolchainPath}/usr/include/c++/v1 -isysroot ${this.paths.xcMacOsSdkPath}`;

    var cmd = `
      cd ${this.paths.builds} && cmake
      -G Ninja
      # --trace --debug-output

      -D CMAKE_OSX_DEPLOYMENT_TARGET=10.15
      -D CMAKE_OSX_SYSROOT=${this.paths.xcMacOsSdkPath}
      -D SWIFT_DARWIN_DEPLOYMENT_VERSION_OSX=10.15

      -D SWIFT_STDLIB_ENABLE_SIL_OWNERSHIP=FALSE
      -D SWIFT_ENABLE_GUARANTEED_NORMAL_ARGUMENTS=TRUE
      -D CMAKE_EXPORT_COMPILE_COMMANDS=TRUE
      -D SWIFT_STDLIB_ENABLE_STDLIBCORE_EXCLUSIVITY_CHECKING=FALSE

      -D SWIFT_ANDROID_NDK_PATH=${ndk.sources}
      -D SWIFT_ANDROID_NDK_GCC_VERSION=${ndk.gcc}
      -D SWIFT_ANDROID_API_LEVEL=${ndk.api}
      -D SWIFT_ANDROID_DEPLOY_DEVICE_PATH=/data/local/tmp
      -D SWIFT_SDK_ANDROID_ARCHITECTURES="${swiftArchsToBuild}"

      ${icuArgs}

      // Below lines have to be disabled when building on macOS 11.3 with Xcode 12.5
      // Otherwise the will be an error addressed unknown C symbol definitions.
      // -D CMAKE_C_FLAGS="${cFlags}"
      // -D CMAKE_CXX_FLAGS="${cFlags}"

      -D CMAKE_BUILD_TYPE=Release
      -D SWIFT_BUILD_SOURCEKIT=FALSE
      -D LLVM_ENABLE_ASSERTIONS=TRUE
      -D SWIFT_STDLIB_ASSERTIONS=FALSE
      -D SWIFT_INCLUDE_TOOLS=TRUE
      -D SWIFT_BUILD_REMOTE_MIRROR=TRUE
      -D SWIFT_STDLIB_SIL_DEBUGGING=FALSE

      # StdLib - Concurrency
      -D SWIFT_ENABLE_EXPERIMENTAL_CONCURRENCY=TRUE
      # Below lines can be both present, but they are mutually exclusive.
      -D SWIFT_STDLIB_SINGLE_THREADED_RUNTIME=FALSE
      -D SWIFT_PATH_TO_LIBDISPATCH_SOURCE="${dispatch.paths.sources}"

      // StdLib
      -D SWIFT_BUILD_DYNAMIC_STDLIB=FALSE
      -D SWIFT_BUILD_STATIC_STDLIB=FALSE

      -D SWIFT_BUILD_DYNAMIC_SDK_OVERLAY=FALSE
      -D SWIFT_BUILD_STATIC_SDK_OVERLAY=FALSE

      # Disable Benchmarks
      -D SWIFT_BUILD_PERF_TESTSUITE=FALSE
      -D SWIFT_BUILD_EXTERNAL_PERF_TESTSUITE=FALSE

      -D SWIFT_BUILD_EXAMPLES=FALSE
      -D SWIFT_INCLUDE_TESTS=FALSE
      -D SWIFT_INCLUDE_DOCS=FALSE
      -D SWIFT_ENABLE_SOURCEKIT_TESTS=FALSE
      -D SWIFT_INSTALL_COMPONENTS='autolink-driver;compiler;clang-builtin-headers;stdlib;swift-remote-mirror;sdk-overlay;license'
      -D LIBDISPATCH_CMAKE_BUILD_TYPE=Release
      -D SWIFT_ENABLE_LLD_LINKER=FALSE
      -D SWIFT_ENABLE_GOLD_LINKER=TRUE

      # See: https://github.com/vgorloff/swift-everywhere-toolchain/issues/129#issuecomment-932598732
      -D SWIFT_ENABLE_DISPATCH=true

      # Disabling builds of Darwin Overlays.
      -D SWIFT_OVERLAY_TARGETS=''

      -D SWIFT_HOST_VARIANT=macosx
      -D SWIFT_HOST_VARIANT_SDK=OSX
      -D SWIFT_ENABLE_IOS32=false
      -D SWIFT_SDK_OSX_PATH=${this.paths.xcMacOsSdkPath}
      -D SWIFT_HOST_TRIPLE=x86_64-apple-macosx10.15
      -D SWIFT_SDKS='ANDROID;OSX'

      -D SWIFT_PRIMARY_VARIANT_SDK=ANDROID
      # Value at the moment not really used in build process, but used in Cmake logic routines.
      -D SWIFT_PATH_TO_LIBICU_BUILD=${this.paths.builds}

      -D SWIFT_HOST_VARIANT_ARCH=x86_64
      -D LLVM_LIT_ARGS=-sv
      -D COVERAGE_DB=
      -D SWIFT_SOURCEKIT_USE_INPROC_LIBRARY=TRUE
      -D SWIFT_AST_VERIFIER=FALSE
      -D SWIFT_RUNTIME_ENABLE_LEAK_CHECKER=FALSE
      -D CMAKE_INSTALL_PREFIX=/


      # Dependencies
      # See: https://cmake.org/cmake/help/v3.14/command/find_package.html

      # LLVM
      -D LLVM_DIR=${llvm.paths.builds}/lib/cmake/llvm
      # In Swift 5.0 the following settings was used:
      # -DSWIFT_PATH_TO_LLVM_SOURCE=#{@llvm.sources}
      # -DSWIFT_PATH_TO_LLVM_BUILD=#{@llvm.builds}

      # CLANG
      -D Clang_DIR=${llvm.paths.builds}/lib/cmake/clang

      # CMark
      -D SWIFT_PATH_TO_CMARK_SOURCE=${cmark.paths.sources}
      -D SWIFT_PATH_TO_CMARK_BUILD=${cmark.paths.builds}

      # For Fun
      # -D SWIFT_VENDOR="Swift_Everywhere"

      # See: https://gitlab.kitware.com/cmake/community/wikis/doc/cmake/Graphviz
      # --graphviz=#{@builds}/graph.dot
      ${this.paths.sources}
`;
    this.executeCommands(cmd);
  }

  configurePatches(/** @type {Boolean} */ shouldEnable) {
    // Below is not needed since v1.0.74.
    // this.configurePatch(`${this.paths.patches}/stdlib/cmake/modules/AddSwiftStdlib.cmake.diff`, shouldEnable)
  }

  executeBuild() {
    this.execute(`cd ${this.paths.builds} && ninja -j${this.numberOfJobs}`);
  }

  executeInstall() {
    this.execute(`DESTDIR=${this.paths.installs} cmake --build ${this.paths.builds} --target install`);
  }
};
