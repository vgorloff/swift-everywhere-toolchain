#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

# Below issue was at the end fixed by adding `#include <atomic>` into `/Sources/swift/stdlib/public/SwiftShims/Visibility.h`
=begin
In file included from /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Sources/swift/stdlib/public/runtime/SwiftRT-ELF.cpp:13:
In file included from /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Sources/swift/stdlib/public/runtime/ImageInspectionELF.h:26:
/Users/vova/Library/Android/sdk/ndk-bundle/sources/cxx-stl/llvm-libc++/include/cstddef:50:9: error: no member named 'ptrdiff_t' in the global namespace
using ::ptrdiff_t;
      ~~^
/Users/vova/Library/Android/sdk/ndk-bundle/sources/cxx-stl/llvm-libc++/include/cstddef:51:9: error: no member named 'size_t' in the global namespace
using ::size_t;
      ~~^
In file included from /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Sources/swift/stdlib/public/runtime/SwiftRT-ELF.cpp:13:
/Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/Sources/swift/stdlib/public/runtime/ImageInspectionELF.h:45:5: error: unknown type name 'size_t'
    size_t length;
    ^
3 errors generated.
=end

class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
      @cmd = <<EOM
      cd #{@builds}/darwin/swift &&
      #{@builds}/darwin/llvm/./bin/clang++
      -v

      # -DCMARK_STATIC_DEFINE -DGTEST_HAS_RTTI=0 -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS
      # -DSWIFT_TARGET_LIBRARY_NAME=swiftImageRegistrationObjectELF
      # -DOBJC_OLD_DISPATCH_PROTOTYPES=0 -DLLVM_DISABLE_ABI_BREAKING_CHECKS_ENFORCING=1
      # -O3 -UNDEBUG -O2 -g0 -DNDEBUG
      # -D__ANDROID_API__=21
      # -DLLVM_DISABLE_ABI_BREAKING_CHECKS_ENFORCING=1
      #
      # -fno-stack-protector -fPIC -fvisibility-inlines-hidden
      # -fno-exceptions -fno-rtti -Wall -Wglobal-constructors -Wexit-time-destructors -fvisibility=hidden
      -std=c++11
      # -lstdc++
      # -fdiagnostics-color -fno-sanitize=all
      # -Wall -Wextra -Wno-unused-parameter -Wno-unknown-warning-option -Werror=unguarded-availability-new -Werror=date-time
      # -Wwrite-strings -Wcast-qual -Wmissing-field-initializers -Wimplicit-fallthrough -Wcovered-switch-default
      # -Wno-class-memaccess -Wno-noexcept-type -Wnon-virtual-dtor -Wdelete-non-virtual-dtor -Wstring-conversion
      # -Werror=switch -Wdocumentation -Wimplicit-fallthrough -Wunreachable-code -Woverloaded-virtual -Werror=unguarded-availability-new

      # -I#{@builds}/darwin/swift/stdlib/public/runtime
      # -I#{@toolChain}/Sources/swift/stdlib/public/runtime
      # -I#{@builds}/darwin/swift/include
      # -I#{@toolChain}/Sources/swift/include

      # -I#{@toolChain}/Sources/llvm/include
      # -I#{@toolChain}/Build/darwin/llvm/include
      # -I#{@toolChain}/Sources/llvm/tools/clang/include
      # -I#{@toolChain}/Build/darwin/llvm/tools/clang/include

      # -I#{@toolChain}/Sources/cmark/src
      # -I#{@toolChain}/Build/darwin/cmark/src

      # -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
      -target armv7-none-linux-androideabi
      # --sysroot=#{@ndk}/platforms/android-21/arch-x86_64
      # -B #{@ndk}/toolchains/x86_64-4.9/prebuilt/darwin-x86_64/x86_64-linux-android/bin

      # +++++++
      # -I#{@ndk}/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/include/c++/v1
      # -I#{@ndk}/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/include/c++
      # +++++++

      # *******
      # Uncommenting this 2 lines cause compile issues
      -I#{@ndk}/sources/cxx-stl/llvm-libc++/include
      -I#{@ndk}/sources/cxx-stl/llvm-libc++abi/include
      # *******

      # -I#{@ndk}/sources/android/support/include
      -I#{@ndk}/sysroot/usr/include
      -I#{@ndk}/sysroot/usr/include/arm-linux-androideabi

      # -isystem #{@toolChain}/Sources/icu/icu4c/source/common
      # -isystem #{@toolChain}/Sources/icu/icu4c/source/i18n

      # -MD -MT #{@build}/SwiftRT-ELF.cpp.o
      # -MF #{@build}/SwiftRT-ELF.cpp.o.d
      -o #{@build}/SwiftRT-ELF.cpp.o
      -c #{@sources}/swift/stdlib/public/runtime/SwiftRT-ELF.cpp
EOM
   end
end

Builder.new().build()
