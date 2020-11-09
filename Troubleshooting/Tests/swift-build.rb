#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))

@cmd = <<EOM

/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/swift-android-toolchain/usr/bin/swiftc
-v -Xcc -v
-swift-version 5 -target armv7-none-linux-androideabi

# -Xcc -DDEPLOYMENT_TARGET_ANDROID -Xcc -DDEPLOYMENT_TARGET_LINUX -Xcc -DDEPLOYMENT_RUNTIME_SWIFT
# -Xcc -D__ANDROID_API__=24 -D __ANDROID__

-tools-directory /usr/local/ndk/20.1.5948944/toolchains/llvm/prebuilt/darwin-x86_64/bin
# -Xcc --sysroot=/usr/local/ndk/20.1.5948944/sysroot
# -Xcc --sysroot=/usr/local/ndk/20.1.5948944/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
# -Xcc --sysroot=/usr/local/ndk/20.1.5948944/platforms/android-24/arch-arm
-Xclang-linker --sysroot=/usr/local/ndk/20.1.5948944/platforms/android-24/arch-arm
-Xclang-linker --gcc-toolchain=/usr/local/ndk/20.1.5948944/toolchains/llvm/prebuilt/darwin-x86_64
# -Xcc -I/usr/local/ndk/20.1.5948944/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/include/arm-linux-androideabi/asm
-Xcc -I/usr/local/ndk/20.1.5948944/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/include
-Xcc -I/usr/local/ndk/20.1.5948944/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/include/arm-linux-androideabi

-L /usr/local/ndk/20.1.5948944/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a
-L /usr/local/ndk/20.1.5948944/toolchains/llvm/prebuilt/darwin-x86_64/lib/gcc/arm-linux-androideabi/4.9.x
-L /usr/local/ndk/20.1.5948944/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi/24
-L /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/swift-android-toolchain/usr/lib/swift/android/armv7

-module-cache-path /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/Tests/sample-exe/build/ModuleCache
-emit-executable
-o /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/Tests/sample-exe/build/exe

/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/Tests/sample-exe/Sources/main.swift

EOM
   end
end

Builder.new().build()
