# Requirements

- Xcode 10.2.1
- Android Studio 3.4.1
- Android NDK 20 (Comes with Android Studio as downloadable package).
- Ruby 2.5 (Comes with macOS)
- CMake 3.14.5
- Ninja 1.9.0

# Important

Toolchain build may fail if macOS headers installed under `/usr/include`. This usually happens if you previously installed package `/Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg`. See details in [Xcode Command Line Tools](https://developer.apple.com/documentation/xcode_release_notes/xcode_10_release_notes#3035624) notes. See following [SuperUser question](https://superuser.com/questions/36567/how-do-i-uninstall-any-apple-pkg-package-file) about how to uninstall package.

Keep tools like `Cmake` and `ninja` up to date.

# Using pre-built toolchain

Build of complete tollchain takes ~1.5h. Instead of building it you can just download and use already pre-built package from [Releases](https://github.com/vgorloff/swift-everywhere-toolchain/releases) page.

# Setup and Build (macOS)

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

4. Clone this repository.

   ```bash
   git clone https://github.com/vgorloff/swift-everywhere-toolchain.git
   cd swift-everywhere-toolchain
   ```

5. Copy file `local.properties.yml.template` to `local.properties.yml`

6. Edit file `local.properties.yml` and configure following settings:

   - `ndk.dir.macos`: Path to NDK installation directory.

7. Start a build.

   ```bash
   make
   ```

8. Once build completed, toolchain will be saved to folder `ToolChain/swift-android-toolchain` and complessed into archive `ToolChain/swift-android-toolchain.tar.gz`.

# Setup and Build (Vagrant Linux)

1. Clone this repository.

   ```bash
   git clone https://github.com/vgorloff/swift-everywhere-toolchain.git
   cd swift-everywhere-toolchain
   ```

2. Copy file `local.properties.yml.template` to `local.properties.yml`

3. Edit file `local.properties.yml` and configure following settings:

   - `ndk.dir.linux-vagrant`: Path to NDK installation directory.

4. Launch Box.

   ```bash
   vagrant up
   ```

5. Login to Box.

   ```bash
   vagrant ssh
   ```

6. Start a build.

   ```bash
   cd /vagrant
   make
   ```

7. Once build completed, toolchain will be saved to folder `ToolChain/swift-android-toolchain` and complessed into archive `ToolChain/swift-android-toolchain.tar.gz`.

# Sample Projects

Sample projects can be found in separate [swift-everywhere-samples](https://github.com/vgorloff/swift-everywhere-samples) repository. Please look into `Readme.md` in that repository to get information about how to configure and build sample projects.
