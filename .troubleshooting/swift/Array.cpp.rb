#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
      @cmd = <<EOM
      cd #{@builds}/darwin/swift &&
      #{@toolChain}/Build/darwin/llvm/./bin/clang++
      -v
      # -DCMARK_STATIC_DEFINE -DGTEST_HAS_RTTI=0 -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS
      # -DOBJC_OLD_DISPATCH_PROTOTYPES=0 -DLLVM_DISABLE_ABI_BREAKING_CHECKS_ENFORCING=1 -DSWIFT_TARGET_LIBRARY_NAME=swiftRuntime

      -std=c++11
      # -fPIC

      -I#{@builds}/darwin/swift/stdlib/public/runtime
      -I#{@toolChain}/Sources/swift/stdlib/public/runtime
      -I#{@builds}/darwin/swift/include
      -I#{@toolChain}/Sources/swift/include

      -I#{@toolChain}/Sources/llvm/include
      -I#{@toolChain}/Build/darwin/llvm/include
      -I#{@toolChain}/Sources/llvm/tools/clang/include
      -I#{@toolChain}/Build/darwin/llvm/tools/clang/include

      # -I#{@toolChain}/Sources/cmark/src
      # -I#{@toolChain}/Build/darwin/cmark/src

      # -O3 -O2 -g0 -DNDEBUG -D__ANDROID_API__=21

      # -UNDEBUG  -fno-exceptions -fno-rtti -Wall -Wglobal-constructors -Wexit-time-destructors -fvisibility=hidden -DswiftCore_EXPORTS
      # -Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector -fvisibility-inlines-hidden
      # -Werror=date-time -Werror=unguarded-availability-new  -Wall -Wextra -Wno-unused-parameter -Wwrite-strings
      # -Wcast-qual -Wmissing-field-initializers -Wimplicit-fallthrough -Wcovered-switch-default -Wno-class-memaccess -Wno-noexcept-type
      # -Wnon-virtual-dtor -Wdelete-non-virtual-dtor -Wstring-conversion -fdiagnostics-color -Werror=switch -Wdocumentation
      # -Wimplicit-fallthrough -Wunreachable-code -Woverloaded-virtual -fno-sanitize=all

      # -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
      # -I#{@toolChain}/Sources/swift/include

      -target armv7-none-linux-androideabi
      # --sysroot=#{@ndk}/platforms/android-21/arch-arm
      # -B #{@ndk}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/arm-linux-androideabi/bin

      # +++++++
      # If these lines below next block there will be compile errors.
      -I#{@ndk}/sources/cxx-stl/llvm-libc++/include
      -I#{@ndk}/sources/cxx-stl/llvm-libc++abi/include
      # +++++++

      # -I#{@ndk}/sources/android/support/include
      -I#{@ndk}/sysroot/usr/include
      -I#{@ndk}/sysroot/usr/include/arm-linux-androideabi

      # -isystem #{@toolChain}/Sources/icu/icu4c/source/common
      # -isystem #{@toolChain}/Sources/icu/icu4c/source/i18n

      -MD -MT #{@build}/Array.cpp.o
      -MF #{@build}/Array.cpp.o.d
      -o #{@build}/Array.cpp.o
      -c #{@toolChain}/Sources/swift/stdlib/public/runtime/Array.cpp
EOM
   end
end

Builder.new().build()
