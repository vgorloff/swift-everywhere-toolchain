#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
      @cmd = <<EOM
      /Users/vova/Downloads/usr/bin/swiftc -frontend -c
      -primary-file #{@sourceRoot}/Hello.swift
      -color-diagnostics -disable-objc-interop
      -Xcc -v
      -module-name hello
      -o #{@build}/Hello.o

      -target armv7-none-linux-android

      # -target arm64-apple-ios12.0-simulator
      # -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS12.2.sdk

      # -Xcc -I#{@ndk}/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/include
      # -Xcc -I#{@ndk}/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/include/arm-linux-androideabi
      # -L /Users/vova/Repositories/GitHub/Projects/swift-everywhere-toolchain/ToolChain/swift-android-toolchain/lib/swift/android/armv7

EOM
   end

   def build()
      super()
      execute "nm -a #{@build}/Hello.o"
   end
end

Builder.new().build()


      # mainFile = "#{@builds}/main.o"

      # # Swift
      # cmd = ["cd #{@builds} &&"]
      # cmd << "#{@swift.installs}/bin/swift -frontend -c"
      # cmd << "-primary-file #{@sources}/hello.swift"
      # cmd << "-target armv7-none-linux-android -disable-objc-interop"
      # cmd << "-color-diagnostics -module-name hello -o #{mainFile}"
      # cmd << "-Xcc -I#{@ndk.toolchain}/sysroot/usr/include -Xcc -I#{@ndk.toolchain}/sysroot/usr/include/arm-linux-androideabi"
      # cmd << "-Xcc -DDEPLOYMENT_TARGET_ANDROID -Xcc -DDEPLOYMENT_TARGET_LINUX -Xcc -DDEPLOYMENT_RUNTIME_SWIFT"
      # cmd << "-I #{@dispatch.installs}/lib/swift/dispatch"
      # cmd << "-I #{@dispatch.installs}/lib/swift/android/armv7"
      # cmd << "-I #{@dispatch.installs}/lib/swift"
      # cmd << "-I #{@foundation.installs}/lib/swift/android/armv7"
      # cmd << "-I #{@foundation.installs}/lib/swift/CoreFoundation"
      # cmd << "-I #{@foundation.installs}/lib/swift"
      # execute cmd.join(" ")
      # execute "file #{mainFile}"

      # # Clang
      # cmd = ["cd #{@builds} &&"]
      # cmd << "#{@ndk.toolchain}/bin/armv7a-linux-androideabi#{@ndk.api}-clang -fuse-ld=gold -pie"
      # cmd << "-v"
      # cmd << "-B #{@ndk.toolchain}/bin"
      # cmd << "#{@swift.installs}/lib/swift/android/armv7/swiftrt.o"
      # cmd << mainFile
      # # cmd << "-Xlinker --verbose"
      # cmd << "-lswiftCore"
      # cmd << "-lswiftGlibc"
      # cmd << "-lswiftSwiftOnoneSupport"
      # cmd << "-lswiftDispatch"
      # cmd << "-lBlocksRuntime"
      # cmd << "-lc++_shared"
      # cmd << "-lFoundation"
      # cmd << "-L #{@ndk.toolchain}/lib/gcc/arm-linux-androideabi/4.9.x" # Link the Android NDK's libc++ and libgcc.
      # cmd << "-L #{@foundation.installs}/lib/swift/android"
      # cmd << "-L #{@dispatch.installs}/lib/swift/android"
      # cmd << "-L #{@swift.installs}/lib/swift/android/armv7"

      # cmd << "-o #{@binary}"
      # execute cmd.join(" ")
      # execute "file #{@binary}"
