require_relative "Builders/Builder.rb"
require_relative "Common/Config.rb"

# See:
# -  Build error: No such module "SwiftGlibc" – https://lists.swift.org/pipermail/swift-dev/Week-of-Mon-20160919/002955.html
class HelloProjectBuilder < Builder

   def initialize()
      super()
      @buildDir = Config.buildRoot + "/hello"
      @executablePath = @buildDir + "/hello"
      @projectRoot = "#{Config.projectsRoot}/Hello"
   end

   def build
      cmd = ["cd #{@buildDir} &&"]
      cmd << "PATH=#{Config.swiftBuildRoot}/swift-linux-x86_64/bin:$PATH"
      cmd << "swiftc"
      cmd << "-tools-directory #{Config.ndkSourcesRoot}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/arm-linux-androideabi/bin"
      cmd << "-target armv7-none-linux-androideabi" # Targeting android-armv7.
      cmd << "-sdk #{Config.ndkSourcesRoot}/platforms/android-#{Config.androidAPI}/arch-arm"  # Use the same NDK path and API version as you used to build the stdlib in the previous step.
      cmd << "-L #{Config.ndkSourcesRoot}/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a"  # Link the Android NDK's libc++ and libgcc.
      cmd << "-L #{Config.ndkSourcesRoot}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.9.x"
      cmd << "#{@projectRoot}/hello.swift"
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
