#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

# Was fixed by adding `#include <sys/cdefs.h>` into `CoreFoundation/Base.subproj/SwiftRuntime/CoreFoundation.h`
class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
@cmd = <<EOM
cd /Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-foundation &&
/Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/darwin/swift/bin/swiftc
-emit-library -incremental
-j 8
-target armv7-none-linux-androideabi24
-module-name Foundation -module-link-name Foundation
-emit-module-path /Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-foundation/swift/Foundation.swiftmodule
-DDEPLOYMENT_RUNTIME_SWIFT -DDEPLOYMENT_ENABLE_LIBDISPATCH
-I /Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Install/armv7a/icu/include
-I /Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch
-I /Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src/swift
-Xcc -fblocks
-O
-I/Volumes/Data/Developer/Android/sdk/ndk-bundle/sysroot/usr/include
-I/Volumes/Data/Developer/Android/sdk/ndk-bundle/sysroot/usr/include/arm-linux-androideabi
-Xcc -F/Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-foundation
-output-file-map /Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-foundation/Foundation.dir/output-file-map.json
-target armv7-none-linux-androideabi24
/Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-foundation/CoreFoundation/libCoreFoundation.a
-l/Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Install/armv7a/xml/lib/libxml2.so
-llog -ldl -lm -ldispatch
/Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Install/armv7a/icu/lib/libicuucswift.so
/Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Install/armv7a/icu/lib/libicui18nswift.so
/Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Install/armv7a/xml/lib/libxml2.so
-L /Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch
-L /Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src
-ldispatch -lswiftDispatch
-Xlinker -rpath -Xlinker /Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-libdispatch/src
/Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-foundation/libuuid.a
-Xlinker -rpath -Xlinker "\$ORIGIN"
-v
-use-ld=gold
-tools-directory /Volumes/Data/Developer/Android/sdk/ndk-bundle/toolchains/llvm/prebuilt/darwin-x86_64/arm-linux-androideabi/bin
-L /Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Install/darwin/swift/lib/swift/android/armv7
-L /Volumes/Data/Developer/Android/sdk/ndk-bundle/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi/24
-L /Volumes/Data/Developer/Android/sdk/ndk-bundle/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/lib/gcc/arm-linux-androideabi/4.9.x
-Xlinker --defsym -Xlinker '__CFConstantStringClassReference=$s10Foundation19_NSCFConstantStringCN'
-o /Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-foundation/Foundation.dir/libFoundation.so
@/Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/armv7a/swift-corelibs-foundation/Foundation.dir/Foundation.rsp
EOM
   end
end

Builder.new().build()
