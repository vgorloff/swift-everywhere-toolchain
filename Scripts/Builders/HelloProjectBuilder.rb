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
         cmd << "-Xcc -I#{ndk.installs}/sysroot/usr/include"
         cmd << "-Xcc -DDEPLOYMENT_TARGET_ANDROID"
         cmd << "-Xcc -DDEPLOYMENT_RUNTIME_SWIFT"
      end
      execute cmd.join(" ")
      execute "file #{mainFile}"

      # Clang
      cmd = ["cd #{@builds} &&"]
      cmd << "#{ndk.bin}/clang++ -fuse-ld=gold"
      # cmd << "-v"
      cmd << "-B #{ndk.bin} -pie -target armv7-none-linux-androideabi"
      cmd << "#{swift.installs}/usr/lib/swift/android/armv7/swiftrt.o"
      cmd << mainFile
      cmd << "-l#{swift.installs}/usr/lib/swift/android/libswiftCore.so"
      cmd << "-l#{swift.installs}/usr/lib/swift/android/libswiftSwiftOnoneSupport.so"
      cmd << "--target=armv7-none-linux-android"
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
         destName = destName.sub("63.1", "63") # Fix for error: CANNOT LINK EXECUTABLE ... library "libicudataswift.so.63" not found
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
      message "Copying Shared Objects completed."
   end

   def prepare()
      prepareBuilds()
   end

end
