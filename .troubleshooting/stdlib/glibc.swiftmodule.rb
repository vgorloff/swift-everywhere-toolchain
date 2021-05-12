#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
      @cmd = <<EOM
cd /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/stdlib/public/Platform
&& /usr/local/Cellar/cmake/3.20.2/bin/cmake
-E remove
-f /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./lib/swift/android/Glibc.swiftmodule/armv7-unknown-linux-android.swiftmodule

/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./lib/swift/android/Glibc.swiftmodule/armv7-unknown-linux-android.swiftdoc

/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./lib/swift/android/Glibc.swiftmodule/armv7-unknown-linux-android.swiftinterface

&& /usr/local/Cellar/cmake/3.20.2/bin/cmake
-E make_directory
/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./lib/swift/android
/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./lib/swift/android/Glibc.swiftmodule

&& /usr/local/Frameworks/Python.framework/Versions/3.9/bin/python3.9
/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift/utils/line-directive
@/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/stdlib/public/Platform/d25a9f73a3c8795b4bd2684f6063aac749d2597e.txt
-- /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/swift/bin/swiftc
-emit-module
-o /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./lib/swift/android/Glibc.swiftmodule/armv7-unknown-linux-android.swiftmodule
-v
-avoid-emit-module-source-info
-sdk /Volumes/Shared/Data/Android/sdk/ndk/21.4.7075529/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
-target armv7-unknown-linux-androideabi
-resource-dir /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./lib/swift
-O -D SWIFT_RUNTIME_OS_VERSIONING -module-cache-path /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./module-cache
-no-link-objc-runtime
-enable-library-evolution
-Xfrontend
-enforce-exclusivity=unchecked
-module-name Glibc
-swift-version 5
-swift-version 5
-autolink-force-load
-runtime-compatibility-version none
-disable-autolinking-runtime-compatibility-dynamic-replacements
-warn-swift3-objc-inference-complete
-Xfrontend -verify-syntax-tree
-sdk /Volumes/Shared/Data/Android/sdk/ndk/21.4.7075529/sysroot
-warn-implicit-overrides
-module-link-name swiftGlibc
-whole-module-optimization
-parse-as-library -I /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./lib/swift/android
-emit-module-interface-path /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./lib/swift/android/Glibc.swiftmodule/armv7-unknown-linux-android.swiftinterface
-Xfrontend -experimental-skip-non-inlinable-function-bodies @/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/stdlib/public/Platform/d25a9f73a3c8795b4bd2684f6063aac749d2597e.txt
EOM

@cmd = <<EOM
/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/swift/bin/swift-frontend
-frontend
-emit-module
/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift/stdlib/public/Platform/Platform.swift
/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift/stdlib/public/Platform/TiocConstants.swift
/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift/stdlib/public/Platform/POSIXError.swift
/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/stdlib/public/Platform/4/tgmath.swift
/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/stdlib/public/Platform/4/Glibc.swift

# -supplementary-output-file-map /var/folders/7l/skdbvw8s5jx0g9vs5_qrkync0000gt/T/supplementaryOutputs-6a423e
-target armv7-unknown-linux-android
-disable-objc-interop
-sdk /Volumes/Shared/Data/Android/sdk/ndk/21.4.7075529/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
-I /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./lib/swift/android
-autolink-force-load
-warn-swift3-objc-inference-complete
-warn-implicit-overrides
-enable-library-evolution
-module-cache-path /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./module-cache
-module-link-name swiftGlibc
-resource-dir /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./lib/swift
-swift-version 5
-O
-D SWIFT_RUNTIME_OS_VERSIONING
-enforce-exclusivity=unchecked
-verify-syntax-tree
-experimental-skip-non-inlinable-function-bodies
-parse-as-library
-module-name Glibc
-o /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./lib/swift/android/Glibc.swiftmodule/armv7-unknown-linux-android.swiftmodule
-runtime-compatibility-version none
-disable-autolinking-runtime-compatibility-dynamic-replacements

EOM
   end

end

Builder.new().build()
