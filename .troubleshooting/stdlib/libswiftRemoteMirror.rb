#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
      @cmd = <<EOM
      cd /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib &&

      /usr/local/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64/bin/clang

      # -D__ANDROID_API__=21

      -v
      -Wl,-v
      --target=armv7-none-linux-androideabi21
      --gcc-toolchain=/usr/local/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64
      --sysroot=/usr/local/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
      -fPIC
      -g
      -DANDROID
      -fdata-sections -ffunction-sections -funwind-tables
      -fstack-protector-strong -no-canonical-prefixes -D_FORTIFY_SOURCE=2
      -march=armv7-a -mthumb -Wformat -Werror=format-security
      -fPIC -Werror=date-time
      -Werror=unguarded-availability-new -Wall -Wextra -Wno-unused-parameter
      -Wwrite-strings -Wmissing-field-initializers -Wimplicit-fallthrough -Wcovered-switch-default -Wdelete-non-virtual-dtor -Wstring-conversion -fdiagnostics-color -ffunction-sections -fdata-sections
      -Oz
      -Wl,--exclude-libs,libgcc.a
      -Wl,--exclude-libs,libgcc_real.a
      -Wl,--exclude-libs,libatomic.a

      # -Wl,--exclude-libs,ALL

      -static-libstdc++
      -Wl,--build-id -Wl,--fatal-warnings
      -Wl,--exclude-libs,libunwind.a
      -Wl,--no-undefined
      -Qunused-arguments
      -shared
      -Wl,-soname,libswiftRemoteMirror.so
      -target armv7-unknown-linux-androideabi21
      --sysroot=/usr/local/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
      -B /usr/local/ndk/21.3.6528147/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/arm-linux-androideabi/bin
      -lm

      # -fuse-ld=gold
      -fuse-ld=lld

      -shared
      -o lib/swift/android/armv7/libswiftRemoteMirror.so
      stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/ErrorHandling.cpp.o
      stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/Hashing.cpp.o
      stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/MemAlloc.cpp.o
      stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/SmallPtrSet.cpp.o
      stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/SmallVector.cpp.o
      stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/StringRef.cpp.o
      stdlib/public/SwiftRemoteMirror/CMakeFiles/swiftRemoteMirror-android-armv7.dir/SwiftRemoteMirror.cpp.o
      -L/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/llvm-project/./lib
      -L/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./lib/swift/android/armv7
      -L/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/swift/bin/../lib/swift/android/armv7
      -L/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/swift/bin/../lib/swift/android
      -L/usr/local/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/swift
      -L/usr/local/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/../lib/gcc/arm-linux-androideabi/4.9.x
      -L/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Install/darwin-armv7a/icu/lib
      -L/usr/local/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi
      lib/swift/android/armv7/libswiftReflection.a
      -ldl
      -llog
      /usr/local/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi/libc++abi.a
      -lc++_shared
      -licui18nswift
      -licuucswift
      -latomic
      -lm
EOM
   end

end

Builder.new().build()
