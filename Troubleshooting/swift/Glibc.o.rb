#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
      @cmd = <<EOM
      cd /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/stdlib/public/Platform && /usr/bin/python3 /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift/utils/line-directive @/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/stdlib/public/Platform/xZO5g.txt -- /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/swift/bin/swiftc

      -v
      -sdk #{@ndk}/sysroot

      -c -target armv7-none-linux-androideabi
      "-I/Volumes/Shared/Data/Android/sdk/ndk/20.1.5948944/sources/android/support/include"
      "-I/Volumes/Shared/Data/Android/sdk/ndk/20.1.5948944/sysroot/usr/include"
      "-I/Volumes/Shared/Data/Android/sdk/ndk/20.1.5948944/sysroot/usr/include/arm-linux-androideabi"
      -resource-dir /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./lib/swift
      -O -module-cache-path /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./module-cache
      -no-link-objc-runtime -enable-library-evolution
      -Xfrontend -enable-ownership-stripping-after-serialization
      -Xfrontend -enforce-exclusivity=unchecked
      -module-name Glibc -swift-version 5 -swift-version 5 -autolink-force-load
      -runtime-compatibility-version none -disable-autolinking-runtime-compatibility-dynamic-replacements -warn-swift3-objc-inference-complete
      -Xfrontend -verify-syntax-tree -warn-implicit-overrides -module-link-name swiftGlibc -force-single-frontend-invocation -parse-as-library
      -I /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./lib/swift/android/armv7
      -o /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/stdlib/public/Platform/ANDROID/armv7/Glibc.o
      @/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/stdlib/public/Platform/xZO5g.txt
EOM
   end

end

Builder.new().build()
