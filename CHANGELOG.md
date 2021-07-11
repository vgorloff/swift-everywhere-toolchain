# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.71] - 2021-07-11
* #124 Updated to use Swift 5.4.2

## [1.0.70] - 2021-06-08
* #118 Updated to use Swift 5.4.1

## [1.0.69] - 2021-05-12
* #113 Updated to use Swift 5.4

## [1.0.68] - 2021-05-08
* #114 Updated to use last LTS release of NDK – 21.4.7075529

## [1.0.67] - 2021-05-03
* [#111] Fixes LLVM build failures on macOS 11.3 with Xcode 12.5
* [#111] CURL updated to v7_76_1

## [1.0.66] - 2021-01-29
* [#107] Swift and related components updated to v.5.3.3

## [1.0.65] - 2020-11-29
* [#102] Allow to provide custom -D__ANDROID_API__ definition.

## [1.0.64] - 2020-11-28
* [#99] Used NDK API level downgraded to 21 (__ANDROID_API_M__)

## [1.0.63] - 2020-11-28
* [#97] Used NDK API level downgraded to 23 (__ANDROID_API_M__)

## [1.0.62] - 2020-11-27
* [#95] Swift and related components updated to v.5.3.1

## [1.0.61] - 2020-11-26
* [#92] Android NDK updated to v.21.3.6528147

## [1.0.60] - 2020-11-23
* [#89] Fixes compile error when building C++ sources using SPM.

## [1.0.59] - 2020-11-22
* [#89] Fixed wrong LC_RPATH settings for spm libraries.

## [1.0.58] - 2020-11-17
### Changed
* Fixed installer to copy forgotten licenses for llbuild and spm.
* Fixed SPMBuilder to copy forgotten libraries.

## [1.0.57] - 2020-11-14
### Added
+ SPM and LLB Builders.
+ Toolchain now contains `swift-build` binary.
### Changed
* Fixed error "unknown argument: '-modulewrap'" when building sources using Swift Package Manager.

## [1.0.56] - 2020-11-10
### Changed
* Build scripts converted from Ruby to JS
* Introduced Swift 5.3 support.

## [1.0.55] - 2020-06-06
### Changed
* Updated libFoundation
### Fixed
* Fixes Swift 5.2 checkout.
* Fixes libFoundation link error due unknown option `-pthread` passed to swiftc.

## [1.0.54] - 2020-03-25
### Changed
* Swift updated to version 5.2.
* libDispatch, libFoundation, LLVM, Cmark updated to match Swift version 5.2.

## [1.0.53] - 2020-01-16
### Changed
* libFoundation switched to recent version.
* OpenSSL updated to OpenSSL_1_1_1d.
* CURL updated to curl-7_68_0.

## [1.0.52] - 2020-01-15
### Changed
* libDispatch switched to recent version.

## [1.0.51] - 2020-01-15
### Changed
* Switched to monolithic LLVM project.

## [1.0.50] - 2020-01-14
### Changed
* Updated LLVM dependencies to latest non-monolithic LLVM project.

## [1.0.49] - 2020-01-13
### Changed
* Updated to support NDK r20b.

## [1.0.48] - 2019-08-19
### Changed
* Updated compiler settings to fit recent changes in Swift.

## [1.0.47] - 2019-08-15
### Changed
* Swift updated to latest version.

## [1.0.46] - 2019-08-12
### Changed
* Scripting: Avoid copying files if destination up to date.
* libFoundation updated to latest version.

## [1.0.45] - 2019-08-09
### Added
+ Test targets to quickly test Toolchain after build.
### Fixed
* Fixed wrong paths in Module map file.

## [1.0.44] - 2019-08-08
### Added
+ Scripts which allow to use toolchain with Swift Package Manager from Xcode 11.
### Removed
- llbuild and Swift Package Manager now NOT a part or toolchain.

## [1.0.43] - 2019-08-06
### Added
+ llbuild and Swift Package Manager now part or toolchain.

## [1.0.42] - 2019-08-05
### Changed
* libDispatch and libFoundation updated to latest versions.

## [1.0.41] - 2019-08-04
### Fixed
* Fixed libFoundation build error when Cmake v.3.15.x is used.

## [1.0.40] - 2019-07-24
### Changed
* Updated Swift, libFoundation to latest revisions.

## [1.0.38] - 2019-07-16
### Changed
* Updated Dispatch to latest revision.

## [1.0.37] - 2019-07-10
### Changed
+ Added SPM and LLBuild builders. They are not used in toolchain yet.

## [1.0.36] - 2019-06-26
### Changed
- Removed patch as it now part of libFoundation. [See](https://github.com/apple/swift-corelibs-foundation/pull/2376)

## [1.0.35] - 2019-06-25
### Changed
* Replaced patch for `cmake/modules/AddSwift.cmake` according to [PR review notes](https://github.com/apple/swift/pull/25682)
