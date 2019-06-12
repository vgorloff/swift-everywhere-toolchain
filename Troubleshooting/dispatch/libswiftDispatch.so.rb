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
   end
end

Builder.new().build()
