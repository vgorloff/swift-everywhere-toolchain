#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

class Builder < Troubleshooter

   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
      @cmd = <<EOM
      cd #{@builds}/darwin/swift &&
      #{@builds}/darwin/llvm/./bin/clang++
      -DCMARK_STATIC_DEFINE -DGTEST_HAS_RTTI=0 -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS
      -DOBJC_OLD_DISPATCH_PROTOTYPES=0 -DLLVM_DISABLE_ABI_BREAKING_CHECKS_ENFORCING=1 -UNDEBUG -UNDEBUG

      -Istdlib/public/Reflection
      -I#{@sources}/swift/stdlib/public/Reflection
      -Iinclude
      -I#{@sources}/swift/include
      -I#{@sources}/llvm/include
      -I#{@builds}/darwin/llvm/include
      -I#{@sources}/llvm/tools/clang/include
      -I#{@builds}/darwin/llvm/tools/clang/include
      -I#{@sources}/cmark/src
      -I#{@builds}/darwin/cmark/src

      # Fixed by making symlink to c++ in `@llvm.builds/include/c++` folder
      # +++++++
      # -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1
      # +++++++


      # -Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector -fPIC -fvisibility-inlines-hidden
      # -Werror=date-time -Werror=unguarded-availability-new -std=c++11 -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wcast-qual
      # -Wmissing-field-initializers -Wimplicit-fallthrough -Wcovered-switch-default -Wno-class-memaccess -Wno-noexcept-type -Wnon-virtual-dtor
      # -Wdelete-non-virtual-dtor -Wstring-conversion -fdiagnostics-color -Werror=switch -Wdocumentation -Wimplicit-fallthrough -Wunreachable-code
      # -Woverloaded-virtual -Wall

      # -fno-sanitize=all -fno-exceptions -fno-rtti
      # -O3 -O2 -g0

      -target x86_64-apple-macosx10.9 -mmacosx-version-min=10.9 -arch x86_64
      -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
      -F /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/../../../Developer/Library/Frameworks

      -MD -MT stdlib/public/Reflection/CMakeFiles/swiftReflection.dir/MetadataSource.cpp.o
      -MF stdlib/public/Reflection/CMakeFiles/swiftReflection.dir/MetadataSource.cpp.o.d
      -o stdlib/public/Reflection/CMakeFiles/swiftReflection.dir/MetadataSource.cpp.o
      -c #{@sources}/swift/stdlib/public/Reflection/MetadataSource.cpp
EOM
   end

end

Builder.new().build()
