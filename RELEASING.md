# Releasing

1. Update version in file `/VERSION`
2. Add new record in a `/CHANGELOG.md` file.
3. If Android NDK version (in file `NDK_VERSION`) is changed, then update following files:

   - Readme.md
   - Assets/android-copy-libs
   - Assets/android-swift-build
   - Assets/android-swiftc
   - Assets/Readme.md

4. Test toolchain:

   1. Run `node main.js verify`
   2. Run `node main.js test`
   3. Compare in Diff-Tool contents of the Toolchain with contents of the Toolchain from previous build.
   4. Run samples from [swift-everywhere-samples](https://github.com/vgorloff/swift-everywhere-samples) repository.
