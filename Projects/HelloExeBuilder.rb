require_relative "ProjectBuilder.rb"

# See:
# -  Build error: No such module "SwiftGlibc" – https://lists.swift.org/pipermail/swift-dev/Week-of-Mon-20160919/002955.html
class HelloExeBuilder < ProjectBuilder

   def initialize(arch = Arch.default)
      component = "hello-exe"
      super(component, arch)
   end

   def executeBuild
      executeBuildNew
   end

   def executeBuildNew
      cmd = ["cd #{@builds} && #{@toolchainDir}/bin/swiftc -emit-executable"]
      cmd += swiftFlags
      cmd << "-o #{@binary} #{@sources}/main.swift"
      execute cmd.join(" ")
      execute "file #{@binary}"
   end

   def executeBuildOld
      mainFile = "#{@builds}/main.o"

      # Swift
      cmd = ["cd #{@builds} &&"]
      cmd << "#{@swift.installs}/bin/swift -frontend -c"
      cmd << "-primary-file #{@sources}/hello.swift"
      cmd << "-target armv7-none-linux-android -disable-objc-interop"
      cmd << "-color-diagnostics -module-name hello -o #{mainFile}"
      cmd << "-Xcc -I#{@ndk.toolchain}/sysroot/usr/include -Xcc -I#{@ndk.toolchain}/sysroot/usr/include/arm-linux-androideabi"
      cmd << "-Xcc -DDEPLOYMENT_TARGET_ANDROID -Xcc -DDEPLOYMENT_TARGET_LINUX -Xcc -DDEPLOYMENT_RUNTIME_SWIFT"
      cmd << "-I #{@dispatch.installs}/lib/swift/dispatch"
      cmd << "-I #{@dispatch.installs}/lib/swift/android/armv7"
      cmd << "-I #{@dispatch.installs}/lib/swift"
      cmd << "-I #{@foundation.installs}/lib/swift/android/armv7"
      cmd << "-I #{@foundation.installs}/lib/swift/CoreFoundation"
      cmd << "-I #{@foundation.installs}/lib/swift"
      execute cmd.join(" ")
      execute "file #{mainFile}"

      # Clang
      cmd = ["cd #{@builds} &&"]
      cmd << "#{@ndk.toolchain}/bin/armv7a-linux-androideabi#{@ndk.api}-clang -fuse-ld=gold -pie"
      cmd << "-v"
      cmd << "-B #{@ndk.toolchain}/bin"
      cmd << "#{@swift.installs}/lib/swift/android/armv7/swiftrt.o"
      cmd << mainFile
      # cmd << "-Xlinker --verbose"
      cmd << "-lswiftCore"
      cmd << "-lswiftGlibc"
      cmd << "-lswiftSwiftOnoneSupport"
      cmd << "-lswiftDispatch"
      cmd << "-lBlocksRuntime"
      cmd << "-lc++_shared"
      cmd << "-lFoundation"
      cmd << "-L #{@ndk.toolchain}/lib/gcc/arm-linux-androideabi/4.9.x" # Link the Android NDK's libc++ and libgcc.
      cmd << "-L #{@foundation.installs}/lib/swift/android"
      cmd << "-L #{@dispatch.installs}/lib/swift/android"
      cmd << "-L #{@swift.installs}/lib/swift/android/armv7"

      cmd << "-o #{@binary}"
      execute cmd.join(" ")
      execute "file #{@binary}"
      # execute "readelf -h #{@binary}" # Run run this on Linux
   end

end
