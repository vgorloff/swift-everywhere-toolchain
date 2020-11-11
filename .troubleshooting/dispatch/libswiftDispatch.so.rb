#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
      @cmd = <<EOM
      cd /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src &&
      /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/darwin/swift/bin/swiftc
      -v
      -emit-library -target armv7-none-linux-androideabi24 -use-ld=gold
      -L /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/darwin/swift/lib/swift/android/armv7
      -tools-directory /Users/vova/Library/Android/sdk/ndk-bundle/toolchains/llvm/prebuilt/darwin-x86_64/bin
      -lDispatchStubs
      -L /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch
      -lBlocksRuntime
      -L /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src
      -ldispatch
      -o /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/libswiftDispatch.so
      /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/Block.swift.o
      /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/Data.swift.o
      /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/Dispatch.swift.o
      /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/IO.swift.o
      /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/Private.swift.o
      /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/Queue.swift.o
      /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/Source.swift.o
      /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/Time.swift.o
      /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/Wrapper.swift.o
EOM
@cmd_ = <<EOM
/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/darwin/swift/bin/swift-autolink-extract
/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/Block.swift.o
/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/Data.swift.o
/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/Dispatch.swift.o
/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/IO.swift.o
/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/Private.swift.o
/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/Queue.swift.o
/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/Source.swift.o
/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/Time.swift.o
/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swiftDispatch.dir/Wrapper.swift.o
-o #{@build}/Block.swift.autolink
EOM

@cmd = <<EOM
cd /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-corelibs-libdispatch &&

/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/swift/bin/swiftc
-target armv7-unknown-linux-androideabi
-output-file-map src/swift/CMakeFiles/swiftDispatch.dir/Release/output-file-map.json -incremental
-j 12 -emit-library -o libswiftDispatch.so
-module-name Dispatch -module-link-name swiftDispatch -emit-module -emit-module-path
src/swift/swift/Dispatch.swiftmodule -emit-dependencies -DswiftDispatch_EXPORTS
-v -resource-dir /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/lib/swift
-Xcc --sysroot=/Volumes/Shared/Data/Android/sdk/ndk/20.1.5948944/sysroot

-Xclang-linker --gcc-toolchain=#{@ndk}/toolchains/llvm/prebuilt/darwin-x86_64
-Xclang-linker --sysroot=#{@ndk}/platforms/android-24/arch-arm
# -sdk #{@ndk}/sysroot

-O -Xcc -fblocks -Xcc -fmodule-map-file=/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch/dispatch/module.modulemap
-Xcc -I/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch
-I /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch/src/BlocksRuntime
-I . -I /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch
-I /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch/src
-I src
/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch/src/swift/Block.swift /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch/src/swift/Data.swift /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch/src/swift/Dispatch.swift /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch/src/swift/IO.swift /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch/src/swift/Private.swift /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch/src/swift/Queue.swift /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch/src/swift/Source.swift /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch/src/swift/Time.swift /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch/src/swift/Wrapper.swift -no-toolchain-stdlib-rpath -Xlinker -soname -Xlinker libswiftDispatch.so
-L /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-corelibs-libdispatch/src/swift
-L /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-corelibs-libdispatch  -L /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-corelibs-libdispatch   -L /Volumes/Shared/Data/Android/sdk/ndk/20.1.5948944/toolchains/llvm/prebuilt/darwin-x86_64/lib64/clang/8.0.7/lib/linux/arm
-L /Volumes/Shared/Data/Android/sdk/ndk/20.1.5948944/toolchains/llvm/prebuilt/darwin-x86_64/lib/gcc/arm-linux-androideabi/4.9.x/armv7-a/thumb   -L /Volumes/Shared/Data/Android/sdk/ndk/20.1.5948944/toolchains/llvm/prebuilt/darwin-x86_64/arm-linux-androideabi/lib/armv7-a/thumb
-L /Volumes/Shared/Data/Android/sdk/ndk/20.1.5948944/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi/24
-L /Volumes/Shared/Data/Android/sdk/ndk/20.1.5948944/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi
-L /Volumes/Shared/Data/Android/sdk/ndk/20.1.5948944/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib
-Xlinker -rpath -Xlinker "\$ORIGIN"  src/swift/libDispatchStubs.a  libdispatch.so  libBlocksRuntime.so
-lc++  -lm  -lgcc  -ldl  -lc  -lgcc  -ldl
EOM
   end
end

Builder.new().build()
