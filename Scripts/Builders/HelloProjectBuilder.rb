require_relative "../Common/Builder.rb"

# See:
# -  Build error: No such module "SwiftGlibc" – https://lists.swift.org/pipermail/swift-dev/Week-of-Mon-20160919/002955.html
class HelloProjectBuilder < Builder

   attr_reader :executable

   def initialize(arch = Arch.default)
      super("Hello", arch)
      @builds = "#{Config.build}/#{arch}/#{@component}"
      @executable = "hello"
      @projectRoot = "#{Config.projects}/Hello"
   end

   def build
      logBuildStarted
      prepare
      copyLibs
      swift = SwiftBuilder.new(@arch)
      ndk = AndroidBuilder.new(@arch)
      mainFile = "#{@builds}/hello-main.o"
      outFile = "#{@builds}/hello"

      # Swift
      cmd = ["cd #{@builds} &&"]
      if @arch != Arch.host
         cmd << "#{swift.installs}/usr/bin/swift -frontend -c"
         cmd << "-primary-file #{@projectRoot}/hello.swift"
         cmd << "-target armv7-none-linux-android -disable-objc-interop"
         cmd << "-color-diagnostics -module-name hello -o #{mainFile}"
         cmd << "-Xcc -I#{ndk.toolchain}/sysroot/usr/include -I#{ndk.toolchain}/sysroot/usr/include/arm-linux-androideabi"
         cmd << "-Xcc -DDEPLOYMENT_TARGET_ANDROID -Xcc -DDEPLOYMENT_TARGET_LINUX -Xcc -DDEPLOYMENT_RUNTIME_SWIFT"
      end
      execute cmd.join(" ")
      execute "file #{mainFile}"

      # Clang
      cmd = ["cd #{@builds} &&"]
      cmd << "#{ndk.toolchain}/bin/armv7a-linux-androideabi#{ndk.api}-clang -fuse-ld=gold -pie"
      cmd << "-v"
      cmd << "-B #{ndk.toolchain}/bin"
      cmd << "#{swift.installs}/usr/lib/swift/android/armv7/swiftrt.o"
      cmd << mainFile
      # cmd << "-Xlinker --verbose"
      cmd << "-L #{@builds}"
      cmd << "-lswiftCore"
      cmd << "-lswiftGlibc"
      cmd << "-lswiftSwiftOnoneSupport"
      cmd << "-lswiftDispatch"
      cmd << "-lBlocksRuntime"
      cmd << "-lc++_shared"
      cmd << "-lFoundation"
      cmd << "-L #{ndk.toolchain}/lib/gcc/arm-linux-androideabi/4.9.x" # Link the Android NDK's libc++ and libgcc.

      cmd << "-o #{outFile}"
      execute cmd.join(" ")
      execute "file #{outFile}"

      if !isMacOS?
         execute "readelf -h #{@builds}/#{@executable}"
      end
      logBuildCompleted
   end

   def copyLibs()
      message "Copying Shared Objects started."
      Dir["#{SwiftBuilder.new(@arch).installs}/usr/lib/swift/android" + "/*.so"].each { |lib|
         execute "cp -vf #{lib} #{@builds}"
      }
      Dir[ICUBuilder.new(@arch).lib + "/*.so*"].select { |lib| !File.symlink?(lib) }.each { |lib|
         destName = File.basename(lib)
         destName = destName.sub("64.1", "64") # Fix for error: CANNOT LINK EXECUTABLE ... library "libicudataswift.so.63" not found
         execute "cp -vf #{lib} #{@builds}/#{destName}"
      }
      Dir[CurlBuilder.new(@arch).lib + "/*.so"].each { |lib|
         execute "cp -vf #{lib} #{@builds}"
      }
      Dir[XMLBuilder.new(@arch).lib + "/*.so"].each { |lib|
         execute "cp -vf #{lib} #{@builds}"
      }
      Dir[OpenSSLBuilder.new(@arch).lib + "/*.so*"].select { |lib| !File.symlink?(lib) }.each { |lib|
         execute "cp -vf #{lib} #{@builds}"
      }
      ndk = AndroidBuilder.new(@arch)
      cxxLibPath = "#{ndk.sources}/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a/libc++_shared.so"
      execute "cp -vf #{cxxLibPath} #{@builds}"
      message "Copying Shared Objects completed."
   end

end
