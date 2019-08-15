#
# The MIT License
#
# Copyright (c) 2019 Volodymyr Gorlov (https://github.com/vgorloff)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

require_relative "../Common/Builder.rb"

=begin

Swift for Linux:
- Compiling swift on Linux: https://akrabat.com/compiling-swift-on-linux/
- Build Swift for Android from your Mac: https://github.com/flowkey/swift-android-toolchain

Swift for Android:
- See ./Sources/Swift/swift/utils/android/build-toolchain
- Running Swift code on Android https://romain.goyet.com/articles/running_swift_code_on_android/
- Building a Development Environment for Swift on Android: https://medium.com/@michiamling/building-a-development-environment-for-swift-on-android-4bb652d2c938
- Java and Swift interoperability: https://medium.com/@michiamling/android-app-with-java-native-interface-for-swift-c9c322609e08
- Android App with Java native interface for Swift: http://michis.culture-blog.org/2017/04/android-app-with-java-native-interface.html
- Building the Swift stdlib for Android – https://github.com/amraboelela/swift/blob/android/docs/Android.md
- fuchsia build – https://fuchsia.googlesource.com/third_party/swift-corelibs-foundation/+/upstream/google/build-android
- https://www.reddit.com/r/swift/comments/3w0xrd/im_patching_the_opensource_swift_compiler_to/
- https://github.com/flowkey/UIKit-cross-platform
- https://blog.readdle.com/why-we-use-swift-for-android-db449feeacaf
- Swift on Android: The Future of Cross-Platform Programming?: https://academy.realm.io/posts/swift-on-android/

Pull Requests and Patches:
- Port to Android Patch: https://github.com/SwiftAndroid/swift/commit/7c502b6344a240c8e06c5e48e5ab6fa32c887ab3

Issues:
- Issue with lg.gold – https://bugs.swift.org/browse/SR-1264
- Issue with ld.gold – https://github.com/apple/swift/commit/d49d88e53d15b6cba00950ec7985df4631e24312

Cross compile:
- Cross compile Apps on Mac for Linux: https://github.com/apple/swift-package-manager/blob/master/Utilities/build_ubuntu_cross_compilation_toolchain
- Swift cross compile on Rasperi Pi: https://stackoverflow.com/a/44003655/1418981

=end

class SwiftBuilder < Builder

   def initialize()
      super(Lib.swift, Arch.host)
      @ndk = NDK.new()
      @cmark = CMarkBuilder.new()
      @llvm = LLVMBuilder.new()
      @clang = ClangBuilder.new(@arch)
   end

   def executeConfigure
      setupToolsSymLinks(Arch.host)
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja" # --trace --debug-output"

      cmd << "-DCMAKE_AR=#{@builds}/cmake-ar"
      cmd << "-DCMAKE_RANLIB=#{@builds}/cmake-ranlib"
      cmd << "-DCMAKE_LIBTOOL=#{toolchainPath}/usr/bin/libtool"
      cmd << "-DSWIFT_LIPO=#{toolchainPath}/usr/bin/lipo"
      if isMacOS?
         cmd << "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.9"
         cmd << "-DCMAKE_OSX_SYSROOT=#{macOSSDK}"
         cmd << "-DSWIFT_DARWIN_DEPLOYMENT_VERSION_OSX=10.9"
      else
         cmd << "-DCMAKE_C_COMPILER=\"#{@llvm.builds}/bin/clang\" -DCMAKE_CXX_COMPILER=\"#{@llvm.builds}/bin/clang++\""
      end

      cmd << "-DSWIFT_STDLIB_ENABLE_SIL_OWNERSHIP=FALSE"
      cmd << "-DSWIFT_ENABLE_GUARANTEED_NORMAL_ARGUMENTS=TRUE"
      cmd << "-DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE"
      cmd << "-DSWIFT_STDLIB_ENABLE_STDLIBCORE_EXCLUSIVITY_CHECKING=FALSE"

      cmd << "-DSWIFT_ANDROID_NDK_PATH=#{@ndk.sources}"
      cmd << "-DSWIFT_ANDROID_NDK_GCC_VERSION=#{@ndk.gcc}"
      cmd << "-DSWIFT_ANDROID_API_LEVEL=#{@ndk.api}"
      cmd << "-DSWIFT_ANDROID_DEPLOY_DEVICE_PATH=/data/local/tmp"
      archs = []
      @archsToBuild.each { |arch|
         if arch == "x86"
            archs << "i686"
         elsif arch == "armv7a"
            archs << "armv7"
         else
            archs << arch
         end
      }
      cmd << "-DSWIFT_SDK_ANDROID_ARCHITECTURES=\"#{archs.join(";")}\""

      icu = ICUBuilder.new(Arch.armv7a)
      cmd << "-DSWIFT_ANDROID_armv7_ICU_UC=#{icu.lib}/libicuucswift.so"
      cmd << "-DSWIFT_ANDROID_armv7_ICU_UC_INCLUDE=#{icu.sources}/source/common"
      cmd << "-DSWIFT_ANDROID_armv7_ICU_I18N=#{icu.lib}/libicui18nswift.so"
      cmd << "-DSWIFT_ANDROID_armv7_ICU_I18N_INCLUDE=#{icu.sources}/source/i18n"
      cmd << "-DSWIFT_ANDROID_armv7_ICU_DATA=#{icu.lib}/libicudataswift.so"
      icu = ICUBuilder.new(Arch.aarch64)
      cmd << "-DSWIFT_ANDROID_aarch64_ICU_UC=#{icu.lib}/libicuucswift.so"
      cmd << "-DSWIFT_ANDROID_aarch64_ICU_UC_INCLUDE=#{icu.sources}/source/common"
      cmd << "-DSWIFT_ANDROID_aarch64_ICU_I18N=#{icu.lib}/libicui18nswift.so"
      cmd << "-DSWIFT_ANDROID_aarch64_ICU_I18N_INCLUDE=#{icu.sources}/source/i18n"
      cmd << "-DSWIFT_ANDROID_aarch64_ICU_DATA=#{icu.lib}/libicudataswift.so"
      icu = ICUBuilder.new(Arch.x86)
      cmd << "-DSWIFT_ANDROID_i686_ICU_UC=#{icu.lib}/libicuucswift.so"
      cmd << "-DSWIFT_ANDROID_i686_ICU_UC_INCLUDE=#{icu.sources}/source/common"
      cmd << "-DSWIFT_ANDROID_i686_ICU_I18N=#{icu.lib}/libicui18nswift.so"
      cmd << "-DSWIFT_ANDROID_i686_ICU_I18N_INCLUDE=#{icu.sources}/source/i18n"
      cmd << "-DSWIFT_ANDROID_i686_ICU_DATA=#{icu.lib}/libicudataswift.so"
      icu = ICUBuilder.new(Arch.x64)
      cmd << "-DSWIFT_ANDROID_x86_64_ICU_UC=#{icu.lib}/libicuucswift.so"
      cmd << "-DSWIFT_ANDROID_x86_64_ICU_UC_INCLUDE=#{icu.sources}/source/common"
      cmd << "-DSWIFT_ANDROID_x86_64_ICU_I18N=#{icu.lib}/libicui18nswift.so"
      cmd << "-DSWIFT_ANDROID_x86_64_ICU_I18N_INCLUDE=#{icu.sources}/source/i18n"
      cmd << "-DSWIFT_ANDROID_x86_64_ICU_DATA=#{icu.lib}/libicudataswift.so"

      cFlags = "-Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector"
      cmd << "-DCMAKE_C_FLAGS='#{cFlags}'"
      cmd << "-DCMAKE_CXX_FLAGS='#{cFlags}'"
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DSWIFT_BUILD_SOURCEKIT=FALSE"
      cmd << "-DLLVM_ENABLE_ASSERTIONS=TRUE"
      cmd << "-DSWIFT_STDLIB_ASSERTIONS=FALSE"
      cmd << "-DSWIFT_INCLUDE_TOOLS=TRUE"
      cmd << "-DSWIFT_BUILD_REMOTE_MIRROR=TRUE"
      cmd << "-DSWIFT_STDLIB_SIL_DEBUGGING=FALSE"
      cmd << "-DSWIFT_BUILD_DYNAMIC_STDLIB=TRUE"
      cmd << "-DSWIFT_BUILD_STATIC_STDLIB=FALSE"

      cmd << "-DSWIFT_BUILD_DYNAMIC_SDK_OVERLAY=TRUE"
      cmd << "-DSWIFT_BUILD_STATIC_SDK_OVERLAY=FALSE"

      # Disable Benchmarks
      cmd << "-DSWIFT_BUILD_PERF_TESTSUITE=FALSE"
      cmd << "-DSWIFT_BUILD_EXTERNAL_PERF_TESTSUITE=FALSE"

      cmd << "-DSWIFT_BUILD_EXAMPLES=FALSE"
      cmd << "-DSWIFT_INCLUDE_TESTS=FALSE"
      cmd << "-DSWIFT_INCLUDE_DOCS=FALSE"
      cmd << "-DSWIFT_ENABLE_SOURCEKIT_TESTS=FALSE"
      cmd << "-DSWIFT_INSTALL_COMPONENTS='autolink-driver;compiler;clang-builtin-headers;stdlib;swift-remote-mirror;sdk-overlay;license'"
      cmd << "-DLIBDISPATCH_CMAKE_BUILD_TYPE=Release"
      cmd << "-DSWIFT_ENABLE_LLD_LINKER=FALSE"

      if isMacOS?
         cmd << "-DSWIFT_OVERLAY_TARGETS=''" # Disabling builds of Darwin Overlays.
         cmd << "-DSWIFT_HOST_VARIANT=macosx"
         cmd << "-DSWIFT_HOST_VARIANT_SDK=OSX"
         cmd << "-DSWIFT_ENABLE_IOS32=false"
         cmd << "-DSWIFT_SDK_OSX_PATH=#{macOSSDK}"
         cmd << "-DSWIFT_HOST_TRIPLE=x86_64-apple-macosx10.9"
         cmd << "-DSWIFT_SDKS='ANDROID;OSX'"
      else
         cmd << "-DSWIFT_HOST_VARIANT=linux"
         cmd << "-DSWIFT_HOST_VARIANT_SDK=LINUX"
         cmd << "-DSWIFT_HOST_TRIPLE=x86_64-unknown-linux-gnu"
         # Workaround for error: Cannot add target-level dependencies to non-existent target "swift-stdlib-linux-x86_64".
         # Fix it later so that it should be possible to build Swift for android only
         cmd << "-DSWIFT_SDKS='ANDROID;LINUX'"
      end

      cmd << "-DSWIFT_PRIMARY_VARIANT_SDK=ANDROID"
      cmd << "-DSWIFT_PATH_TO_LIBICU_BUILD=#{@builds}" # Value at the moment not really used in build process, but used in Cmake logic routines.

      cmd << "-DSWIFT_HOST_VARIANT_ARCH=x86_64"
      cmd << "-DLLVM_LIT_ARGS=-sv"
      cmd << "-DCOVERAGE_DB="
      cmd << "-DSWIFT_SOURCEKIT_USE_INPROC_LIBRARY=TRUE"
      cmd << "-DSWIFT_AST_VERIFIER=FALSE"
      cmd << "-DSWIFT_RUNTIME_ENABLE_LEAK_CHECKER=FALSE"
      cmd << "-DCMAKE_INSTALL_PREFIX=/"


      # Dependencies
      # See: https://cmake.org/cmake/help/v3.14/command/find_package.html

      # LLVM
      cmd << "-DLLVM_DIR=#{@llvm.builds}/lib/cmake/llvm"
      # In Swift 5.0 the following settings was used:
      # cmd << "-DSWIFT_PATH_TO_LLVM_SOURCE=#{@llvm.sources}"
      # cmd << "-DSWIFT_PATH_TO_LLVM_BUILD=#{@llvm.builds}"

      # CLANG
      cmd << "-DClang_DIR=#{@llvm.builds}/lib/cmake/clang"
      # In Swift 5.0 the following settings was used:
      # cmd << "-DSWIFT_PATH_TO_CLANG_SOURCE=#{@clang.sources}"
      # cmd << "-DSWIFT_PATH_TO_CLANG_BUILD=#{@llvm.builds}"

      # CMark
      cmd << "-DSWIFT_PATH_TO_CMARK_SOURCE=#{@cmark.sources}"
      cmd << "-DSWIFT_PATH_TO_CMARK_BUILD=#{@cmark.builds}"

      # See: https://gitlab.kitware.com/cmake/community/wikis/doc/cmake/Graphviz
      # cmd << "--graphviz=#{@builds}/graph.dot"
      cmd << @sources
      execute cmd.join(" \\\n   ")
   end

   def executeBuild
      # Seems link to `#{@ndk}/sources/cxx-stl/llvm-libc++/include` is proper solution.
      setupSymLinks(true)
      setupToolsSymLinks(Arch.host)
      execute "cd #{@builds} && ninja -j#{numberOfJobs}"
      setupSymLinks(false)

      @archsToBuild.each { |arch|
         setupToolsSymLinks(arch)
         if arch == "x86"
            targets = "swiftGlibc-android-i686 swiftCore-android-i686 swiftSwiftOnoneSupport-android-i686 swiftRemoteMirror-android-i686"
         elsif arch == "armv7a"
            targets = "swiftGlibc-android-armv7 swiftCore-android-armv7 swiftSwiftOnoneSupport-android-armv7 swiftRemoteMirror-android-armv7"
         elsif arch == "aarch64"
            targets = "swiftGlibc-android-aarch64 swiftCore-android-aarch64 swiftSwiftOnoneSupport-android-aarch64 swiftRemoteMirror-android-aarch64"
         else
            targets = "swiftGlibc-android-x86_64 swiftCore-android-x86_64 swiftSwiftOnoneSupport-android-x86_64 swiftRemoteMirror-android-x86_64"
         end
         execute "cd #{@builds} && ninja -j#{numberOfJobs} #{targets}"
      }
      setupToolsSymLinks(Arch.host)
   end

   def executeInstall
      setupSymLinks(true)
      execute "DESTDIR=#{@installs} cmake --build #{@builds} --target install"
      setupSymLinks(false)
   end

   def configurePatches(shouldEnable = true)
      configurePatchFile("#{@patches}/stdlib/public/SwiftShims/Visibility.h.diff", shouldEnable)
      configurePatchFile("#{@patches}/stdlib/CMakeLists.txt.diff", shouldEnable)

      # Fixes wrong path to `swiftrt.o` after PR merge: https://github.com/apple/swift/pull/25990
      # See also: [Driver: honour `-sdk` even on Darwin by compnerd · Pull Request #26361 · apple/swift](https://github.com/apple/swift/pull/26361)
      configurePatchFile("#{@patches}/lib/Driver/ToolChains.cpp.diff", shouldEnable)

      # Fixes wrong install locations and unneded logic related to `lipo` and fat binaries.
      configurePatchFile("#{@patches}/cmake/modules/AddSwift.cmake.diff", shouldEnable)
   end

   def setupSymLinks(enable)
      # Seems like a workaround. Try to configure include paths in CMAKE settings.
      if enable
         setupSymLink("#{toolchainPath}/usr/include/c++", "#{@llvm.builds}/include/c++")
      else
         removeSymLink("#{@llvm.builds}/include/c++")
      end
   end

   def setupToolsSymLinks(arch)
      if arch == "x86"
         setupSymLink("#{@ndk.toolchain}/i686-linux-android/bin/ar", "#{@builds}/cmake-ar")
         setupSymLink("#{@ndk.toolchain}/i686-linux-android/bin/ranlib", "#{@builds}/cmake-ranlib")
      elsif arch == "armv7a"
         setupSymLink("#{@ndk.toolchain}/arm-linux-androideabi/bin/ar", "#{@builds}/cmake-ar")
         setupSymLink("#{@ndk.toolchain}/arm-linux-androideabi/bin/ranlib", "#{@builds}/cmake-ranlib")
      elsif arch == "aarch64"
         setupSymLink("#{@ndk.toolchain}/aarch64-linux-android/bin/ar", "#{@builds}/cmake-ar")
         setupSymLink("#{@ndk.toolchain}/aarch64-linux-android/bin/ranlib", "#{@builds}/cmake-ranlib")
      elsif arch == "x86_64"
         setupSymLink("#{@ndk.toolchain}/x86_64-linux-android/bin/ar", "#{@builds}/cmake-ar")
         setupSymLink("#{@ndk.toolchain}/x86_64-linux-android/bin/ranlib", "#{@builds}/cmake-ranlib")
      else
         setupSymLink("#{toolchainPath}/usr/bin/ar", "#{@builds}/cmake-ar")
         setupSymLink("#{toolchainPath}/usr/bin/ranlib", "#{@builds}/cmake-ranlib")
      end
   end

end
