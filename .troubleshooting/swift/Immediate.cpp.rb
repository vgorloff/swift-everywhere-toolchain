#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
      @cmd = <<EOM
      cd /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/swift &&
#       CPATH=/Volumes/Apps/Developer/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1
#       CPLUS_INCLUDE_PATH=/Volumes/Apps/Developer/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1
/Volumes/Apps/Developer/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ -v -DCMARK_STATIC_DEFINE -DGTEST_HAS_RTTI=0 -DHAVE_LIBEDIT -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -Ilib/Immediate -I/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift/lib/Immediate -Iinclude -I/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift/include -I/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/llvm-project/llvm/include -I/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/llvm-project/include -I/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/llvm-project/clang/include -I/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/llvm-project/tools/clang/include -I/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/cmark/src -I/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/cmark/src

# -isystem /Volumes/Apps/Developer/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1
-isystem /Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/include
-isysroot /Volumes/Apps/Developer/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk

 -Wno-unknown-warning-option -Werror=unguarded-availability-new
 -fno-stack-protector -fPIC -fvisibility-inlines-hidden -Werror=date-time -Werror=unguarded-availability-new -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wmissing-field-initializers -Wimplicit-fallthrough -Wcovered-switch-default -Wno-class-memaccess -Wno-noexcept-type -Wnon-virtual-dtor -Wdelete-non-virtual-dtor -Wstring-conversion -fdiagnostics-color -Werror=switch -Wdocumentation -Wimplicit-fallthrough -Wunreachable-code -Woverloaded-virtual -DOBJC_OLD_DISPATCH_PROTOTYPES=0 -O3  -isysroot /Volumes/Apps/Developer/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk   -UNDEBUG  -fno-exceptions -fno-rtti -Werror=gnu -target x86_64-apple-macosx10.9 -isysroot /Volumes/Apps/Developer/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk -arch x86_64 -F/Volumes/Apps/Developer/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/../../../Developer/Library/Frameworks -mmacosx-version-min=10.9 -O2 -g0 -UNDEBUG -std=c++14 -MD -MT lib/Immediate/CMakeFiles/swiftImmediate.dir/Immediate.cpp.o -MF lib/Immediate/CMakeFiles/swiftImmediate.dir/Immediate.cpp.o.d -o lib/Immediate/CMakeFiles/swiftImmediate.dir/Immediate.cpp.o -c /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/swift/lib/Immediate/Immediate.cpp
EOM
   end

end

Builder.new().build()
