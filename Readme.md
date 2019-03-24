Requirements
============

- Xcode 10.1
- Android Studio 3.3
- Android NDK 19 (Comes with Android Studio as downloadable package).
- Ruby 2.5 (Comes with macOS)


Setup and Build
===============

1. Copy file `local.properties.yml.template` to `local.properties.yml`
2. Edit file `local.properties.yml` and configure following settings:

   - `ndk.dir`: Path to NDK installation directory.

3. Install Rake (Make-like program implemented in Ruby).

   ```bash
   bash$ gem install rake
   ```

4. Clone this repository.

    ```bash
    bash$ git clone https://github.com/vgorloff/Android-On-Swift.git
    bash$ cd Android-On-Swift
    ```

5. Start a build.

   ```bash
   bash$ rake
   ```

6. Once build completed, open sample project `Projects/Hello-NDK` in Android Studio, update file `local.properties` with actual paths and launch sample app on ARMv7 Android Device.
