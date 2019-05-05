Requirements
============

- Xcode 10.1
- Android Studio 3.3
- Android NDK 19 (Comes with Android Studio as downloadable package).
- Ruby 2.5 (Comes with macOS)

Setup and Build
===============

1. Check that Cmake is installed. Install Cmake if Needed.

   ```bash
   $ which cmake
   $ brew install cmake
   ```

2. Check that Ninja is installed. Install Ninja if Needed.

   ```bash
   $ which ninja
   $ brew install ninja
   ```

3. Check that Autotools is installed. Install Autotools if Needed.

   ```bash
   $ which autoconf
   $ brew install autoconf

   $ which aclocal
   $ brew install automake
 
   $ which glibtool
   $ brew install libtool
   
   $ which pkg-config
   $ brew install pkg-config
   ```

4. Clone this repository.

    ```bash
    $ git clone https://github.com/vgorloff/Android-On-Swift.git
    $ cd Android-On-Swift
    ```
5. Copy file `local.properties.yml.template` to `local.properties.yml`

6. Edit file `local.properties.yml` and configure following settings:

   - `ndk.dir`: Path to NDK installation directory.

7. Start a build.

   ```bash
   $ make
   ```

8. Once build completed, open sample project `Projects/Hello-NDK` in Android Studio, update file `local.properties` with actual paths and launch sample app on ARMv7 Android Device.
