#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
   @cmd = <<EOM
cd #{@builds}/darwin/swift &&
#{@builds}/darwin/llvm/./bin/clang++
-v
-DCMARK_STATIC_DEFINE -DGTEST_HAS_RTTI=0 -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS
-DOBJC_OLD_DISPATCH_PROTOTYPES=0 -DLLVM_DISABLE_ABI_BREAKING_CHECKS_ENFORCING=1 -DNDEBUG -UNDEBUG -D__ANDROID_API__=21
-O3 -O2 -g0
-DSWIFT_TARGET_LIBRARY_NAME=swiftImageRegistrationObjectELF -target armv7-none-linux-androideabi

-Istdlib/public/runtime
-I#{@sources}/swift/stdlib/public/runtime
-Iinclude
-I#{@sources}/swift/include
-I#{@sources}/llvm/include
-I#{@builds}/darwin/llvm/include
-I#{@sources}/llvm/tools/clang/include
-I#{@builds}/darwin/llvm/tools/clang/include
-I#{@sources}/cmark/src
-I#{@builds}/darwin/cmark/src

# -Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector -fPIC -fvisibility-inlines-hidden -Werror=date-time
# -Werror=unguarded-availability-new -std=c++11 -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wmissing-field-initializers
# -Wimplicit-fallthrough -Wcovered-switch-default -Wno-class-memaccess -Wno-noexcept-type -Wnon-virtual-dtor -Wdelete-non-virtual-dtor
# -Wstring-conversion -fdiagnostics-color -Werror=switch -Wdocumentation -Wimplicit-fallthrough -Wunreachable-code -Woverloaded-virtual

# -fno-exceptions -fno-rtti -Wall -Wglobal-constructors -Wexit-time-destructors -fvisibility=hidden -fno-sanitize=all

-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
--sysroot=#{@ndk}/platforms/android-21/arch-arm
-B #{@ndk}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/arm-linux-androideabi/bin

# Below issue was at the end fixed by adding `#include <cstddef>` into `/Sources/swift/stdlib/public/SwiftShims/Visibility.h`
# *******
# Uncommenting this block cause compile issues
"-I#{@ndk}/sources/cxx-stl/llvm-libc++/include"
# *******

"-I#{@ndk}/sources/cxx-stl/llvm-libc++abi/include"
"-I#{@ndk}/sources/android/support/include"
"-I#{@ndk}/sysroot/usr/include"
"-I#{@ndk}/sysroot/usr/include/arm-linux-androideabi"

-isystem #{@sources}/icu/icu4c/source/common
-isystem #{@sources}/icu/icu4c/source/i18n
-MD -MT stdlib/public/runtime/CMakeFiles/swiftImageRegistrationObjectELF-android-armv7.dir/SwiftRT-ELF.cpp.o
-MF stdlib/public/runtime/CMakeFiles/swiftImageRegistrationObjectELF-android-armv7.dir/SwiftRT-ELF.cpp.o.d
-o stdlib/public/runtime/CMakeFiles/swiftImageRegistrationObjectELF-android-armv7.dir/SwiftRT-ELF.cpp.o
-c #{@sources}/swift/stdlib/public/runtime/SwiftRT-ELF.cpp
EOM
   end
end

Builder.new().build()
