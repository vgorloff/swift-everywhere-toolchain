#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
      @cmd = <<EOM
cd #{@builds}/darwin/swift &&
/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/darwin/llvm/./bin/clang++
-v
-DCMARK_STATIC_DEFINE -DGTEST_HAS_RTTI=0 -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS
-Istdlib/public/runtime -I/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Sources/swift/stdlib/public/runtime
-Iinclude
-I/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Sources/swift/include
-I/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Sources/llvm/include
-I/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/darwin/llvm/include
-I/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Sources/llvm/tools/clang/include
-I/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/darwin/llvm/tools/clang/include
-I/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Sources/cmark/src
-I/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Build/darwin/cmark/src

-Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector -fPIC -fvisibility-inlines-hidden -Werror=date-time
-Werror=unguarded-availability-new -std=c++11 -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wmissing-field-initializers
-Wimplicit-fallthrough -Wcovered-switch-default -Wno-class-memaccess -Wno-noexcept-type -Wnon-virtual-dtor -Wdelete-non-virtual-dtor
-Wstring-conversion -fdiagnostics-color -Werror=switch -Wdocumentation -Wimplicit-fallthrough -Wunreachable-code -Woverloaded-virtual
-DOBJC_OLD_DISPATCH_PROTOTYPES=0 -fno-sanitize=all -DLLVM_DISABLE_ABI_BREAKING_CHECKS_ENFORCING=1 -O3

-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
 -UNDEBUG  -fno-exceptions -fno-rtti -Wall -Wglobal-constructors -Wexit-time-destructors -fvisibility=hidden
 -DswiftCore_EXPORTS
 -I/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Sources/swift/include
 -DSWIFT_TARGET_LIBRARY_NAME=swiftRuntime -target armv7-none-linux-androideabi
 --sysroot=/Users/vova/Library/Android/sdk/ndk-bundle/platforms/android-21/arch-arm
 -B /Users/vova/Library/Android/sdk/ndk-bundle/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/arm-linux-androideabi/bin
 -O2 -g0 -DNDEBUG

 # +++++++
 "-I#{@ndk}/sources/cxx-stl/llvm-libc++/include"
 # +++++++

 "-I/Users/vova/Library/Android/sdk/ndk-bundle/sources/cxx-stl/llvm-libc++abi/include"
 "-I/Users/vova/Library/Android/sdk/ndk-bundle/sources/android/support/include"
 "-I/Users/vova/Library/Android/sdk/ndk-bundle/sysroot/usr/include"
 "-I/Users/vova/Library/Android/sdk/ndk-bundle/sysroot/usr/include/arm-linux-androideabi"
 -D__ANDROID_API__=21 -isystem /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Sources/icu/icu4c/source/common
 -isystem /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Sources/icu/icu4c/source/i18n
 -MD -MT stdlib/public/runtime/CMakeFiles/swiftRuntime-android-armv7.dir/Casting.cpp.o
 -MF stdlib/public/runtime/CMakeFiles/swiftRuntime-android-armv7.dir/Casting.cpp.o.d
 -o stdlib/public/runtime/CMakeFiles/swiftRuntime-android-armv7.dir/Casting.cpp.o
 -c /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Sources/swift/stdlib/public/runtime/Casting.cpp
EOM
   end

end

Builder.new().build()
