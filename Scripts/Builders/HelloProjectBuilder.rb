require_relative "../Common/Builder.rb"

# See:
# -  Build error: No such module "SwiftGlibc" – https://lists.swift.org/pipermail/swift-dev/Week-of-Mon-20160919/002955.html
class HelloProjectBuilder < Builder

   attr_reader :executable, :executableName

   def initialize(arch = Arch.default)
      super("Hello", arch)
      @executableName = "hello"
      @executable = @builds + "/" + @executableName
      @projectRoot = "#{Config.projects}/Hello"
   end

   def build
      prepare
      swift = SwiftBuilder.new()
      ndk = AndroidBuilder.new()
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
      execute "readelf -h #{@executable}"
   end

   def prepare()
      prepareBuilds()
   end

end
