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
      llvm = LLVMBuilder.new(@arch)
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
         cmd << "-Xcc -DDEPLOYMENT_TARGET_ANDROID -Xcc -DDEPLOYMENT_TARGET_LINUX"
         cmd << "-Xcc -DDEPLOYMENT_RUNTIME_SWIFT"
      end
      execute cmd.join(" ")
      execute "file #{mainFile}"

      # Clang
      cmd = ["cd #{@builds} &&"]
      cmd << "#{ndk.toolchain}/bin/armv7a-linux-androideabi21-clang -fuse-ld=gold"
      cmd << "-v"
      cmd << "-B #{ndk.toolchain}/bin -pie"
      cmd << "#{swift.installs}/usr/lib/swift/android/armv7/swiftrt.o"
      cmd << mainFile
      cmd << "-L #{@builds}"
      cmd << "-lswiftCore"
      cmd << "-lswiftGlibc"
      cmd << "-lswiftSwiftOnoneSupport"
      cmd << "-lswiftDispatch"
      cmd << "-lBlocksRuntime"
      cmd << "-lc++_shared"
      cmd << "-lFoundation"
             # cmd << "-sdk #{ndk.sources}/platforms/android-#{ndk.api}/arch-arm"  # Use the same NDK path and API version as you used to build the stdlib in the previous step.
      cmd << "-L #{ndk.installs}/lib/gcc/arm-linux-androideabi/4.9.x"  # Link the Android NDK's libc++ and libgcc.
      # cmd << "-L #{ndk.sources}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.9.x"
      cmd << "-L #{ndk.installs}/sysroot/usr/lib"
      # cmd << "#{ndk.installs}/sysroot/usr/lib/crtbegin_dynamic.o"
      # cmd << "#{ndk.installs}/sysroot/usr/lib/crtend_android.o"
      # cmd << "-Xlinker --verbose"

      cmd << "-o #{outFile}"
      execute cmd.join(" ")
      execute "file #{outFile}"

      if !isMacOS?
         execute "readelf -h #{@builds}/#{@executable}"
      end
      logBuildCompleted
   end

   def copyLibs()
      swift = SwiftBuilder.new(@arch)
      ndk = AndroidBuilder.new(@arch)
      icu = ICUBuilder.new(@arch)
      curl = CurlBuilder.new(@arch)
      ssl = OpenSSLBuilder.new(@arch)
      xml = XMLBuilder.new(@arch)
      message "Copying Shared Objects started."
      Dir["#{swift.installs}/usr/lib/swift/android" + "/*.so"].each { |lib|
         execute "cp -vf #{lib} #{@builds}"
      }
      Dir[icu.lib + "/*.so*"].select { |lib| !File.symlink?(lib) }.each { |lib|
         destName = File.basename(lib)
         destName = destName.sub("64.1", "64") # Fix for error: CANNOT LINK EXECUTABLE ... library "libicudataswift.so.63" not found
         execute "cp -vf #{lib} #{@builds}/#{destName}"
      }
      Dir[curl.lib + "/*.so"].each { |lib|
         execute "cp -vf #{lib} #{@builds}"
      }
      Dir[xml.lib + "/*.so"].each { |lib|
         execute "cp -vf #{lib} #{@builds}"
      }
      Dir[ssl.lib + "/*.so*"].select { |lib| !File.symlink?(lib) }.each { |lib|
         execute "cp -vf #{lib} #{@builds}"
      }
      cxxLibPath = "#{ndk.sources}/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a/libc++_shared.so"
      execute "cp -vf #{cxxLibPath} #{@builds}"
      execute "cp -vf #{ndk.toolchain}/sysroot/usr/lib/arm-linux-androideabi/21/crtbegin_so.o #{@builds}"
      execute "cp -vf #{ndk.toolchain}/sysroot/usr/lib/arm-linux-androideabi/21/crtend_so.o #{@builds}"
      execute "cp -vf #{ndk.toolchain}/sysroot/usr/lib/arm-linux-androideabi/21/crtend_android.o #{@builds}"
      execute "cp -vf #{ndk.toolchain}/sysroot/usr/lib/arm-linux-androideabi/21/crtbegin_dynamic.o #{@builds}"
      message "Copying Shared Objects completed."
   end

   def prepare()
      prepareBuilds()
   end

end
