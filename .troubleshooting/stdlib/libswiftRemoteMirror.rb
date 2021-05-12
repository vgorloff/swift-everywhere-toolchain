#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
      @cmd = <<EOM

      cd /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib &&
/Volumes/Shared/Data/Android/sdk/ndk/21.4.7075529/toolchains/llvm/prebuilt/darwin-x86_64/bin/clang --target=armv7-none-linux-androideabi21 --gcc-toolchain=/Volumes/Shared/Data/Android/sdk/ndk/21.4.7075529/toolchains/llvm/prebuilt/darwin-x86_64 --sysroot=/Volumes/Shared/Data/Android/sdk/ndk/21.4.7075529/toolchains/llvm/prebuilt/darwin-x86_64/sysroot -fPIC -g -DANDROID -fdata-sections -ffunction-sections -funwind-tables -fstack-protector-strong -no-canonical-prefixes -D_FORTIFY_SOURCE=2 -march=armv7-a -mthumb -Wformat -Werror=format-security  -fPIC -Werror=date-time -Werror=unguarded-availability-new -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wmissing-field-initializers -Wimplicit-fallthrough -Wcovered-switch-default -Wdelete-non-virtual-dtor -Wstring-conversion -fdiagnostics-color -ffunction-sections -fdata-sections -Oz  -Wl,--exclude-libs,libgcc.a -Wl,--exclude-libs,libgcc_real.a -Wl,--exclude-libs,libatomic.a -static-libstdc++ -Wl,--build-id -Wl,--fatal-warnings -Wl,--exclude-libs,libunwind.a -Wl,--no-undefined -Qunused-arguments     -shared -Wl,-soname,libswiftRemoteMirror.so -target armv7-unknown-linux-androideabi21 --sysroot=/Volumes/Shared/Data/Android/sdk/ndk/21.4.7075529/toolchains/llvm/prebuilt/darwin-x86_64/sysroot -B /Volumes/Shared/Data/Android/sdk/ndk/21.4.7075529/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/arm-linux-androideabi/bin -lm -fuse-ld=gold -shared  -o lib/swift/android/armv7/libswiftRemoteMirror.so stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/ErrorHandling.cpp.o stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/Hashing.cpp.o stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/MemAlloc.cpp.o stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/SmallPtrSet.cpp.o stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/SmallVector.cpp.o stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/StringRef.cpp.o stdlib/public/SwiftRemoteMirror/CMakeFiles/swiftRemoteMirror-android-armv7.dir/SwiftRemoteMirror.cpp.o -L/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/llvm-project/./lib   -L/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./lib/swift/android/armv7   -L/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/swift/bin/../lib/swift/android/armv7   -L/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/swift/bin/../lib/swift/android   -L/Volumes/Shared/Data/Android/sdk/ndk/21.4.7075529/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/swift   -L/Volumes/Shared/Data/Android/sdk/ndk/21.4.7075529/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/../lib/gcc/arm-linux-androideabi/4.9.x   -L/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Install/darwin-armv7a/icu/lib

# -L/Volumes/Shared/Data/Android/sdk/ndk/21.4.7075529/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi

lib/swift/android/armv7/libswiftReflection.a  -ldl  -llog  /Volumes/Shared/Data/Android/sdk/ndk/21.4.7075529/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi/libc++abi.a  -lc++_shared  -licui18nswift  -licuucswift  -latomic -lm
EOM
      @_cmd = <<EOM
      cd /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib &&

      /Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/bin/clang

      -v

      --target=armv7-none-linux-androideabi23
      --gcc-toolchain=/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64
      --sysroot=/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
      -fPIC -g -DANDROID -fdata-sections -ffunction-sections -funwind-tables
      -fstack-protector-strong -no-canonical-prefixes -D_FORTIFY_SOURCE=2
      -march=armv7-a -mthumb -Wformat -Werror=format-security
      -D__ANDROID_API__=23 -fPIC -Werror=date-time -Werror=unguarded-availability-new -Wall -Wextra
      -Wno-unused-parameter -Wwrite-strings -Wmissing-field-initializers
      -Wimplicit-fallthrough -Wcovered-switch-default -Wdelete-non-virtual-dtor
      -Wstring-conversion -fdiagnostics-color -ffunction-sections -fdata-sections
      -Oz
      -Wl,--exclude-libs,libgcc.a
      -Wl,--exclude-libs,libgcc_real.a
      -Wl,--exclude-libs,libatomic.a
      -static-libstdc++

      -Wl,-v

      -Wl,--build-id=sha1
      -Wl,--no-rosegment
      -Wl,--fatal-warnings
      -Wl,--exclude-libs,libunwind.a
      -Wl,--no-undefined
      -Qunused-arguments
      -Wl,--color-diagnostics
      -shared
      -Wl,-soname,libswiftRemoteMirror.so

      # -target armv7-unknown-linux-androideabi23
      # --sysroot=/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/sysroot

      -lm -fuse-ld=lld
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
      -L/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Install/darwin-armv7a/icu/lib

      -L/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/swift
      -L/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/lib/gcc/arm-linux-androideabi/4.9.x



      # Below line breaks the build. See: https://github.com/vgorloff/swift-everywhere-toolchain/issues/113
      # -L/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi




      lib/swift/android/armv7/libswiftReflection.a
      -ldl
      -llog
      /Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi/libc++abi.a
      -lc++_shared
      -licui18nswift
      -licuucswift
      -latomic
      -lm
EOM

      @_cmd = <<EOM

cd /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib &&

/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/bin/ld.lld \

-error-limit=0

--sysroot=/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
-z noexecstack -EL
--warn-shared-textrel
-z now
-z relro
-z max-page-size=4096
-X --hash-style=gnu
--enable-new-dtags
--eh-frame-hdr
-m armelf_linux_eabi
-o lib/swift/android/armv7/libswiftRemoteMirror.so

/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi/23/crtbegin_so.o

-L/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/llvm-project/./lib
-L/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-armv7a/swift-stdlib/./lib/swift/android/armv7
-L/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/swift/bin/../lib/swift/android/armv7
-L/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/swift/bin/../lib/swift/android
-L/Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Install/darwin-armv7a/icu/lib

-L/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/lib/gcc/arm-linux-androideabi/4.9.x
-L/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi
-L/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/lib64/clang/11.0.5/lib/linux/arm
-L/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/lib/gcc/arm-linux-androideabi/4.9.x/armv7-a/thumb
-L/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/lib/gcc/arm-linux-androideabi/4.9.x/../../../../arm-linux-androideabi/lib/../lib/armv7-a/thumb
-L/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi/23
-L/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi
-L/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/../lib
-L/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi/../../lib
-L/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/lib/gcc/arm-linux-androideabi/4.9.x/../../../../arm-linux-androideabi/lib/armv7-a/thumb
-L/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib

--exclude-libs libgcc.a
--exclude-libs libgcc_real.a
--exclude-libs libatomic.a
--exclude-libs libunwind.a

--build-id=sha1
--no-rosegment
--fatal-warnings
-color-diagnostics

-v
--no-undefined

-soname libswiftRemoteMirror.so
-lm
stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/ErrorHandling.cpp.o
stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/Hashing.cpp.o
stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/MemAlloc.cpp.o
stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/SmallPtrSet.cpp.o
stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/SmallVector.cpp.o
stdlib/public/LLVMSupport/CMakeFiles/swiftLLVMSupport-android-armv7.dir/StringRef.cpp.o
stdlib/public/SwiftRemoteMirror/CMakeFiles/swiftRemoteMirror-android-armv7.dir/SwiftRemoteMirror.cpp.o
lib/swift/android/armv7/libswiftReflection.a
-ldl
-llog
-shared
/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi/libc++abi.a
-lc++_shared
-licui18nswift
-licuucswift
-latomic
-lm
-lgcc
-ldl
-lc
-lgcc
-ldl
/Volumes/Shared/Data/Android/sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi/23/crtend_so.o
EOM
   end

end

Builder.new().build()
