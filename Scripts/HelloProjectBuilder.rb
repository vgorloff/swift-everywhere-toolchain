require_relative "Builders/Builder.rb"
require_relative "Common/Config.rb"

# See:
# -  Build error: No such module "SwiftGlibc" – https://lists.swift.org/pipermail/swift-dev/Week-of-Mon-20160919/002955.html
class HelloProjectBuilder < Builder

   def initialize()
      super()
      @buildDir = Config.buildRoot + "/projects/hello"
      @executablePath = @buildDir + "/hello"
   end

   def build
      cmd = ["cd #{@buildDir} &&"]
      cmd << "PATH=#{Config.swiftSources}/build/Ninja-ReleaseAssert/swift-linux-x86_64/bin:$PATH"
      cmd << "swiftc"
      cmd << "-tools-directory #{Config.ndkPath}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/arm-linux-androideabi/bin"
      cmd << "-target armv7-none-linux-androideabi" # Targeting android-armv7.
      cmd << "-sdk #{Config.ndkPath}/platforms/android-#{Config.androidAPI}/arch-arm"  # Use the same NDK path and API version as you used to build the stdlib in the previous step.
      cmd << "-L #{Config.ndkPath}/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a"   # Link the Android NDK's libc++ and libgcc.
      cmd << "-L #{Config.ndkPath}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.9.x"
      cmd << "#{Config.projectsDirPath}/Hello/hello.swift"
      execute cmd.join(" ")
      execute "readelf -h #{@executablePath}"
   end

   def prepare()
      execute "mkdir -p #{@buildDir}"
   end

   def make
      prepare
      build
   end

end
