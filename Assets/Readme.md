# Usage

1. Make sure that symbolic link with name `/usr/local/ndk/20.1.5948944` points to right `Android NDK` location (usually `~/Library/Android/sdk/ndk/20.1.5948944`). Create symbolic link if needed.

   ```bash
   sudo mkdir -p /usr/local/ndk && sudo ln -vsi ~/Library/Android/sdk/ndk/20.1.5948944 /usr/local/ndk/20.1.5948944
   ```

2. Compile Swift sources for `armv7a`:

   ```bash
   # Compile executable.
   $ToolChain/usr/bin/swiftc-arm-linux-androideabi -emit-executable -o hello main.swift

   # Copy dependencies (so-files) to [destination] directory.
   $ToolChain/usr/bin/copy-libs-arm-linux-androideabi [destination]
   ```

3. Compile Swift sources for `aarch64`, `x86`, `x86_64`:

   ```bash
   # To build for aarch64
   $ToolChain/usr/bin/swiftc-aarch64-linux-android -emit-executable -o hello main.swift
   $ToolChain/usr/bin/copy-libs-aarch64-linux-android [destination]

   # To build for x86
   $ToolChain/usr/bin/swiftc-i686-linux-android -emit-executable -o hello main.swift
   $ToolChain/usr/bin/copy-libs-i686-linux-android [destination]

   # To build for x86_64
   $ToolChain/usr/bin/swiftc-x86_64-linux-android -emit-executable -o hello main.swift
   $ToolChain/usr/bin/copy-libs-x86_64-linux-android [destination]
   ```
