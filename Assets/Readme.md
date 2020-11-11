# Usage

1. Make sure that symbolic link with name `/usr/local/ndk/20.1.5948944` points to right `Android NDK` location (usually `~/Library/Android/sdk/ndk/20.1.5948944`). Create symbolic link if needed.

   ```bash
   sudo mkdir -p /usr/local/ndk
   sudo ln -vsi ~/Library/Android/sdk/ndk/20.1.5948944 /usr/local/ndk/20.1.5948944
   ```

2. Compile Swift sources for `armv7a`, `aarch64`, `x86` or `x86_64` architectures:

   ```bash
   # Compile executable for armv7a architecture.
   $ToolChain/usr/bin/swiftc-arm-linux-androideabi -emit-executable -o hello main.swift

   # Copy dependencies (so-files) for armv7a architecture to [destination] directory.
   $ToolChain/usr/bin/copy-libs-arm-linux-androideabi -output [destination]
   ```

3. Or build Swift package:

   ```bash
   cd /Path/To/Your/Swift/Package

   # Build for armv7a architecture.
   $ToolChain/usr/bin/swift-build-arm-linux-androideabi -c release

   # Copy dependencies (so-files) for armv7a architecture to [destination] directory.
   $ToolChain/usr/bin/copy-libs-arm-linux-androideabi -output [destination]
   ```

   **Note**: Building Swift packages for `debug` build configuration still not supported due error `error: unknown argument: '-modulewrap'`.
