# Requirements

- Xcode 12
- Android Studio 4.1
- Android NDK 20.1.5948944. **Note**: NDK 21.0.6113669 or above cannot be used with libDispatch at the moment due compile errors addressed clang/libc++ update.
- Node 12.18 (node -v). Never versions may also work, but not tested.
- CMake 3.18 (cmake --version)
- Ninja 1.10 (ninja --version)

# Important

- Toolchain build may fail if macOS headers installed under `/usr/include`. This usually happens if you previously installed package `/Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg`. See details in [Xcode Command Line Tools](https://developer.apple.com/documentation/xcode_release_notes/xcode_10_release_notes#3035624) notes. See following [SuperUser question](https://superuser.com/questions/36567/how-do-i-uninstall-any-apple-pkg-package-file) about how to uninstall package.
- Toolchain build may fail if the command line tools are present in `/Library/Developer/CommandLineTools`. Remove them if you are not using them. See: [macos - How do I uninstall the command line tools for Xcode? - Ask Different](https://apple.stackexchange.com/questions/308943/how-do-i-uninstall-the-command-line-tools-for-xcode)

Keep tools like `Cmake` and `ninja` up to date.

# Using pre-built toolchain

Build of complete toolchain takes ~1.5h. Instead of building it you can just download and use already pre-built package from [Releases](https://github.com/vgorloff/swift-everywhere-toolchain/releases) page.

# Setup and Build

1. Check that Cmake is installed. Install Cmake if Needed.

   ```bash
   which cmake
   brew install cmake
   ```

2. Check that Ninja is installed. Install Ninja if Needed.

   ```bash
   which ninja
   brew install ninja
   ```

3. Check that Autotools is installed. Install Autotools if Needed.

   ```bash
   which autoconf
   brew install autoconf

   which aclocal
   brew install automake

   which glibtool
   brew install libtool

   which pkg-config
   brew install pkg-config
   ```

4. Check that git-lfs is installed. Install git-lfs if Needed.

   ```bash
   which git-lfs
   brew install git-lfs
   ```

5. Make sure that `Xcode Build Tools` properly configured.

   ```bash
   xcode-select --print-path
   ```

6. Clone this repository.

   ```bash
   git clone https://github.com/vgorloff/swift-everywhere-toolchain.git
   cd swift-everywhere-toolchain
   ```

7. Create a symbolic link to NDK installation directory.

   ```bash
   sudo mkdir -p /usr/local/ndk
   sudo ln -vsi ~/Library/Android/sdk/ndk/$VERSION /usr/local/ndk/$VERSION
   `

   The placeholder `$VERSION` needs to be replaced with a version mentioned in file `NDK_VERSION` at the root of cloned repository.

8. Start a build.

   ```bash
   node main.js
   ```

9. Once build completed, toolchain will be saved to folder `ToolChain/swift-android-toolchain` and complessed into archive `ToolChain/swift-android-toolchain.tar.gz`.

# Sample Projects

Sample projects can be found in separate [swift-everywhere-samples](https://github.com/vgorloff/swift-everywhere-samples) repository. Please look into `Readme.md` in that repository to get information about how to configure and build sample projects.
