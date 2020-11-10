#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
      @cmd = <<EOM
cd /Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/swift && /Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/llvm/./bin/clang++

-v
-Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector -fPIC -fvisibility-inlines-hidden -Werror=date-time -Werror=unguarded-availability-new -std=c++11 -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wmissing-field-initializers -Wimplicit-fallthrough -Wcovered-switch-default -Wno-class-memaccess -Wno-noexcept-type -Wnon-virtual-dtor -Wdelete-non-virtual-dtor -Wstring-conversion -fdiagnostics-color -Werror=switch -Wdocumentation -Wimplicit-fallthrough -Wunreachable-code -Woverloaded-virtual

-DOBJC_OLD_DISPATCH_PROTOTYPES=0 -O3

-isysroot /Volumes/Data/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
-dynamiclib -Wl,-headerpad_max_install_names -dynamiclib

-Wl,-headerpad_max_install_names -Xlinker -compatibility_version -Xlinker 1

-target x86_64-apple-macosx10.9

-isysroot /Volumes/Data/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk -arch x86_64

-F /Volumes/Data/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/../../../Developer/Library/Frameworks
-mmacosx-version-min=10.9
-Wl,-dead_strip -Wl,-sectcreate,__TEXT,__info_plist,/Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/swift/stdlib/public/core/Info.plist
-Wl,-application_extension
"-L/Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/swift/./lib/swift/macosx/x86_64"
"-L/Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/swift/./bin/../lib/swift/macosx/x86_64"
"-L/Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/swift/./bin/../lib/swift/macosx"
-o lib/swift/macosx/x86_64/libswiftCore.dylib
-install_name /usr/lib/swift/libswiftCore.dylib
stdlib/public/core/OSX/x86_64/Swift.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/AnyHashableSupport.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/Array.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/BackDeployment.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/Casting.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/CompatibilityOverride.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/CygwinPort.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/Demangle.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/Enum.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/ErrorObjectConstants.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/ErrorObjectNative.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/Errors.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/ErrorDefaultImpls.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/Exclusivity.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/ExistentialContainer.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/Heap.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/HeapObject.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/ImageInspectionMachO.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/ImageInspectionELF.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/ImageInspectionCOFF.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/KeyPaths.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/KnownMetadata.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/LLVMSupport.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/Metadata.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/MetadataLookup.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/MutexPThread.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/MutexWin32.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/Numeric.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/Once.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/Portability.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/ProtocolConformance.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/RefCount.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/RuntimeInvocationsTracking.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/SwiftDtoa.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/__/__/__/lib/Demangling/OldDemangler.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/__/__/__/lib/Demangling/Demangler.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/__/__/__/lib/Demangling/NodePrinter.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/__/__/__/lib/Demangling/Context.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/__/__/__/lib/Demangling/ManglingUtils.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/__/__/__/lib/Demangling/Punycode.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/__/__/__/lib/Demangling/NodeDumper.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/ErrorObject.mm.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/SwiftObject.mm.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/SwiftValue.mm.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/ReflectionMirror.mm.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/ObjCRuntimeGetImageNameFromClass.mm.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/__/__/__/lib/Demangling/OldRemangler.cpp.o
stdlib/public/runtime/CMakeFiles/swiftRuntime-macosx-x86_64.dir/__/__/__/lib/Demangling/Remangler.cpp.o
stdlib/public/stubs/CMakeFiles/swiftStdlibStubs-macosx-x86_64.dir/Assert.cpp.o
stdlib/public/stubs/CMakeFiles/swiftStdlibStubs-macosx-x86_64.dir/CommandLine.cpp.o
stdlib/public/stubs/CMakeFiles/swiftStdlibStubs-macosx-x86_64.dir/GlobalObjects.cpp.o
stdlib/public/stubs/CMakeFiles/swiftStdlibStubs-macosx-x86_64.dir/LibcShims.cpp.o
stdlib/public/stubs/CMakeFiles/swiftStdlibStubs-macosx-x86_64.dir/Random.cpp.o
stdlib/public/stubs/CMakeFiles/swiftStdlibStubs-macosx-x86_64.dir/Stubs.cpp.o
stdlib/public/stubs/CMakeFiles/swiftStdlibStubs-macosx-x86_64.dir/ThreadLocalStorage.cpp.o
stdlib/public/stubs/CMakeFiles/swiftStdlibStubs-macosx-x86_64.dir/MathStubs.cpp.o
stdlib/public/stubs/CMakeFiles/swiftStdlibStubs-macosx-x86_64.dir/Availability.mm.o
stdlib/public/stubs/CMakeFiles/swiftStdlibStubs-macosx-x86_64.dir/FoundationHelpers.mm.o
stdlib/public/stubs/CMakeFiles/swiftStdlibStubs-macosx-x86_64.dir/OptionalBridgingHelper.mm.o
stdlib/public/stubs/CMakeFiles/swiftStdlibStubs-macosx-x86_64.dir/Reflection.mm.o
stdlib/public/stubs/CMakeFiles/swiftStdlibStubs-macosx-x86_64.dir/SwiftNativeNSXXXBaseARC.m.o
stdlib/public/stubs/CMakeFiles/swiftStdlibStubs-macosx-x86_64.dir/UnicodeNormalization.cpp.o
stdlib/public/stubs/CMakeFiles/swiftStdlibStubs-macosx-x86_64.dir/8/SwiftNativeNSXXXBase.mm.o
stdlib/public/core/CMakeFiles/swiftCore-macosx-x86_64.dir/__/__/linker-support/magic-symbols-for-install-name.c.o
-L/Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/llvm/./lib
-L /Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Install/darwin-host/icu-swift/lib
-licui18nswift -licuucswift -licudataswift -latomic
EOM
   end

end

Builder.new().build()
