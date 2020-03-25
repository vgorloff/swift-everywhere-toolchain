#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
      @cmd = <<EOM
      cd /Users/Shared/Git/Projects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-corelibs-libdispatch &&
/Users/Shared/Data/Android/android-ndk-r21/toolchains/llvm/prebuilt/darwin-x86_64/bin/clang++ 
--target=armv7-none-linux-androideabi24 
 -DDISPATCH_USE_DTRACE=0 -DHAVE_CONFIG_H -Ddispatch_EXPORTS 
 -I. -I/Users/Shared/Git/Projects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch -I/Users/Shared/Git/Projects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch/src -Isrc -I/Users/Shared/Git/Projects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch/private -I/Users/Shared/Git/Projects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch/src/BlocksRuntime -fuse-ld=gold 
 -Wno-unused-command-line-argument 
 -B /Users/Shared/Data/Android/android-ndk-r21/toolchains/llvm/prebuilt/darwin-x86_64/arm-linux-androideabi/bin -Wl,-L,/Users/Shared/Data/Android/android-ndk-r21/toolchains/llvm/prebuilt/darwin-x86_64/lib/gcc/arm-linux-androideabi/4.9.x,-L,/Users/Shared/Data/Android/android-ndk-r21/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi,-L,/Users/Shared/Data/Android/android-ndk-r21/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi/24 -Wl,-L,/Users/Shared/Data/Android/android-ndk-r21/toolchains/llvm/prebuilt/darwin-x86_64/arm-linux-androideabi/lib -O3 -DNDEBUG -fPIC  
 
   -Werror
   -Wall -Wextra 
   -Warray-bounds-pointer-arithmetic -Wassign-enum -Watomic-properties 
  -Wcomma -Wconditional-uninitialized -Wconversion -Wcovered-switch-default 
  -Wdate-time -Wdeprecated -Wdocumentation -Wdouble-promotion -Wduplicate-enum 
  -Wexpansion-to-defined -Wfloat-equal -Widiomatic-parentheses 
  -Winfinite-recursion -Wmissing-prototypes -Wnewline-eof 
  -Wnullable-to-nonnull-conversion -Wobjc-interface-ivars -Wover-aligned -Wpacked -Wpointer-arith -Wselector -Wshadow -Wshorten-64-to-32 -Wsign-conversion -Wstatic-in-inline 
  -Wsuper-class-method-mismatch -Wswitch -Wunguarded-availability -Wunreachable-code -Wunused -Wno-unknown-warning-option -Wno-trigraphs -Wno-four-char-constants -Wno-disabled-macro-expansion 
  -Wno-pedantic -Wno-bad-function-cast 
  -Wno-c++-compat -Wno-c++98-compat 
  -Wno-c++98-compat-pedantic -Wno-cast-align 
  -Wno-cast-qual -Wno-documentation-unknown-command 
  -Wno-format-nonliteral -Wno-missing-variable-declarations 
  -Wno-old-style-cast -Wno-padded -Wno-reserved-id-macro 
  -Wno-shift-sign-overflow -Wno-undef -Wno-unreachable-code-aggressive 
  -Wno-unused-macros -Wno-used-but-marked-unused -Wno-vla 
  -Wno-incompatible-function-pointer-types -Wno-implicit-function-declaration 
  -Wno-conversion -Wno-int-conversion -Wno-shorten-64-to-32 
  -Wno-error=assign-enum -U_GNU_SOURCE -fno-exceptions -fblocks 
  -momit-leaf-frame-pointer 
  -std=gnu++11 
  -MD -MT src/CMakeFiles/dispatch.dir/block.cpp.o -MF src/CMakeFiles/dispatch.dir/block.cpp.o.d 
  -o src/CMakeFiles/dispatch.dir/block.cpp.o -c /Users/Shared/Git/Projects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch/src/block.cpp
EOM
   end
end

Builder.new().build()
