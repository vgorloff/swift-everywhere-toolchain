#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
      @cmd = <<EOM
      cd #{@builds}/darwin/swift &&
      /Users/vagrant/Documents/Android-On-Swift/ToolChain/Build/darwin/llvm/./bin/clang++
      -v
      -DCMARK_STATIC_DEFINE -DGTEST_HAS_RTTI=0 -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS
      -DOBJC_OLD_DISPATCH_PROTOTYPES=0 -DLLVM_DISABLE_ABI_BREAKING_CHECKS_ENFORCING=1 -DSWIFT_TARGET_LIBRARY_NAME=swiftRuntime
      
      -Istdlib/public/runtime
      # -I/Users/vagrant/Documents/Android-On-Swift/ToolChain/Sources/swift/stdlib/public/runtime
      # -Iinclude
      # -I/Users/vagrant/Documents/Android-On-Swift/ToolChain/Sources/swift/include

      -I/Users/vagrant/Documents/Android-On-Swift/ToolChain/Sources/llvm/include
      -I/Users/vagrant/Documents/Android-On-Swift/ToolChain/Build/darwin/llvm/include
      -I/Users/vagrant/Documents/Android-On-Swift/ToolChain/Sources/llvm/tools/clang/include
      -I/Users/vagrant/Documents/Android-On-Swift/ToolChain/Build/darwin/llvm/tools/clang/include

      # -I/Users/vagrant/Documents/Android-On-Swift/ToolChain/Sources/cmark/src
      # -I/Users/vagrant/Documents/Android-On-Swift/ToolChain/Build/darwin/cmark/src

      -std=c++11 -fPIC
      # -O3 -O2 -g0 -DNDEBUG -D__ANDROID_API__=21

      # -UNDEBUG  -fno-exceptions -fno-rtti -Wall -Wglobal-constructors -Wexit-time-destructors -fvisibility=hidden -DswiftCore_EXPORTS
      # -Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector -fvisibility-inlines-hidden
      # -Werror=date-time -Werror=unguarded-availability-new  -Wall -Wextra -Wno-unused-parameter -Wwrite-strings
      # -Wcast-qual -Wmissing-field-initializers -Wimplicit-fallthrough -Wcovered-switch-default -Wno-class-memaccess -Wno-noexcept-type
      # -Wnon-virtual-dtor -Wdelete-non-virtual-dtor -Wstring-conversion -fdiagnostics-color -Werror=switch -Wdocumentation
      # -Wimplicit-fallthrough -Wunreachable-code -Woverloaded-virtual -fno-sanitize=all
      
      # -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
      # -I/Users/vagrant/Documents/Android-On-Swift/ToolChain/Sources/swift/include
      
      -target armv7-none-linux-androideabi 
      # --sysroot=/Users/vagrant/Library/Android/sdk/ndk-bundle/platforms/android-21/arch-arm
      # -B /Users/vagrant/Library/Android/sdk/ndk-bundle/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/arm-linux-androideabi/bin
      
      # -I/Users/vagrant/Library/Android/sdk/ndk-bundle/sources/android/support/include
      -I/Users/vagrant/Library/Android/sdk/ndk-bundle/sysroot/usr/include
      -I/Users/vagrant/Library/Android/sdk/ndk-bundle/sysroot/usr/include/arm-linux-androideabi
      
      # -isystem /Users/vagrant/Documents/Android-On-Swift/ToolChain/Sources/icu/icu4c/source/common
      # -isystem /Users/vagrant/Documents/Android-On-Swift/ToolChain/Sources/icu/icu4c/source/i18n

      -MD -MT #{@build}/Array.cpp.o
      -MF #{@build}/Array.cpp.o.d
      -o #{@build}/Array.cpp.o
      -c /Users/vagrant/Documents/Android-On-Swift/ToolChain/Sources/swift/stdlib/public/runtime/Array.cpp
EOM
   end
end

Builder.new().build()