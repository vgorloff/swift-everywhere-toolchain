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
      swift = SwiftBuilder.new(@arch)
      ndk = AndroidBuilder.new(@arch)
      cmd = ["cd #{@builds} &&"]
      cmd << "PATH=#{swift.installs}/usr/bin:$PATH"
      cmd << "swiftc"
      if @arch != Arch.host
         cmd << "-tools-directory #{ndk.installs}/bin"
         cmd << "-target armv7-none-linux-androideabi" # Targeting android-armv7.
         cmd << "-Xcc -I#{ndk.installs}/sysroot/usr/include"
         cmd << "-Xcc -DDEPLOYMENT_TARGET_ANDROID"
         cmd << "-Xcc -DDEPLOYMENT_RUNTIME_SWIFT"

         # Below seems not needed.
         # cmd << "-sdk #{ndk.sources}/platforms/android-#{ndk.api}/arch-arm"  # Use the same NDK path and API version as you used to build the stdlib in the previous step.
         # cmd << "-L #{ndk.sources}/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a"  # Link the Android NDK's libc++ and libgcc.
         # cmd << "-L #{ndk.sources}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.9.x"
      end
      cmd << "#{@projectRoot}/hello.swift"
      execute cmd.join(" ")
      if !isMacOS?
         copyLibs
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
