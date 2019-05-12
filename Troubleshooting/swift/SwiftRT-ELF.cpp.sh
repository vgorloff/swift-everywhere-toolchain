#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

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

      # -Istdlib/public/runtime
      # -I/Users/vagrant/Documents/Android-On-Swift/ToolChain/Sources/swift/stdlib/public/runtime
      # -Iinclude
      # -I/Users/vagrant/Documents/Android-On-Swift/ToolChain/Sources/swift/include
      # -I/Users/vagrant/Documents/Android-On-Swift/ToolChain/Sources/llvm/include
      # -I/Users/vagrant/Documents/Android-On-Swift/ToolChain/Build/darwin/llvm/include
      # -I/Users/vagrant/Documents/Android-On-Swift/ToolChain/Sources/llvm/tools/clang/include
      # -I/Users/vagrant/Documents/Android-On-Swift/ToolChain/Build/darwin/llvm/tools/clang/include
      # -I/Users/vagrant/Documents/Android-On-Swift/ToolChain/Sources/cmark/src
      # -I/Users/vagrant/Documents/Android-On-Swift/ToolChain/Build/darwin/cmark/src

      # -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
      -target x86_64-unknown-linux-android
      # --sysroot=/Users/vagrant/Library/Android/sdk/ndk-bundle/platforms/android-21/arch-x86_64
      # -B /Users/vagrant/Library/Android/sdk/ndk-bundle/toolchains/x86_64-4.9/prebuilt/darwin-x86_64/x86_64-linux-android/bin

      # +++++++
      # -I/Users/vagrant/Library/Android/sdk/ndk-bundle/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/include/c++/v1
      # -I/Users/vagrant/Library/Android/sdk/ndk-bundle/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/include/c++
      # +++++++

      # >>>>>>
      # Uncommenting this 2 lines cause compile issues
      # -I/Users/vagrant/Library/Android/sdk/ndk-bundle/sources/cxx-stl/llvm-libc++/include
      # -I/Users/vagrant/Library/Android/sdk/ndk-bundle/sources/cxx-stl/llvm-libc++abi/include
      # <<<<<<

      # -I/Users/vagrant/Library/Android/sdk/ndk-bundle/sources/android/support/include
      -I#{@ndk}/sysroot/usr/include
      # -I/Users/vagrant/Library/Android/sdk/ndk-bundle/sysroot/usr/include/x86_64-linux-android

      # -isystem /Users/vagrant/Documents/Android-On-Swift/ToolChain/Sources/icu/icu4c/source/common
      # -isystem /Users/vagrant/Documents/Android-On-Swift/ToolChain/Sources/icu/icu4c/source/i18n

      -MD -MT #{@build}/SwiftRT-ELF.cpp.o
      -MF #{@build}/SwiftRT-ELF.cpp.o.d
      -o #{@build}/SwiftRT-ELF.cpp.o
      -c #{@sources}/swift/stdlib/public/runtime/SwiftRT-ELF.cpp
EOM
   end
end

Builder.new().build()