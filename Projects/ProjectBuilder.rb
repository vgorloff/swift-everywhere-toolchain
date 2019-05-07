require_relative "../Scripts/Common/Builder.rb"
Dir[File.dirname(__FILE__) + '/../Scripts/**/*.rb'].each { |file| require file }

class ProjectBuilder < Builder

   attr_reader :binary

   def initialize(component, arch)
      super(component, arch)
      @toolchainDir = Config.toolchainDir
      @sources = "#{Config.projects}/#{component}"
      @ndk = NDK.new()
      @binary = "#{@builds}/#{component}"
      if @arch == Arch.armv7a
         @archPath = "armv7"
         @ndkArchPath = "arm-linux-androideabi"
         @ndkToolchainPath = @ndkArchPath
         @target = "armv7-none-linux-androideabi"
         @platform = "arm"
         @cppPath = "armeabi-v7a"
      elsif @arch == Arch.x86
         @archPath = "i686"
         @ndkArchPath = "i686-linux-android"
         @ndkToolchainPath = "x86"
         @target = "i686-unknown-linux-android"
         @platform = "x86"
         @cppPath = "x86"
      elsif @arch == Arch.aarch64
         @archPath = "aarch64"
         @ndkArchPath = "aarch64-linux-android"
         @ndkToolchainPath = @ndkArchPath
         @target = "aarch64-unknown-linux-android"
         @platform = "arm64"
         @cppPath = "arm64-v8a"
      end
   end

   def prepare
      removeBuilds()
      super
   end

   def libs
      return Dir["#{@builds}/lib/*"]
   end

   def copyLibs()
      targetDir = "#{@builds}/lib"
      execute "rm -rvf \"#{targetDir}\""
      execute "mkdir -p \"#{targetDir}\""
      message "Copying Shared Objects started."
      Dir["#{@toolchainDir}/lib/swift/android/#{@archPath}" + "/*.so"].each { |lib|
         execute "cp -vf #{lib} #{targetDir}"
      }
      cxxLibPath = "#{@toolchainDir}/ndk/sources/cxx-stl/llvm-libc++/libs/#{@cppPath}/libc++_shared.so"
      execute "cp -vf #{cxxLibPath} #{targetDir}"
      message "Copying Shared Objects completed."
   end

   def swiftFlags
      ndkToolchain = "#{@toolchainDir}/ndk/toolchains/llvm/prebuilt/darwin-x86_64"
      cmd = []
      cmd << "-target #{@target}"
      # cmd << "-v"
      cmd << "-tools-directory #{ndkToolchain}"
      cmd << "-sdk #{@toolchainDir}/ndk/platforms/android-#{@ndk.api}/arch-#{@platform}"
      cmd << "-Xcc -I#{ndkToolchain}/sysroot/usr/include -Xcc -I#{ndkToolchain}/sysroot/usr/include/#{@ndkArchPath}"
      cmd << "-Xcc -DDEPLOYMENT_TARGET_ANDROID -Xcc -DDEPLOYMENT_TARGET_LINUX -Xcc -DDEPLOYMENT_RUNTIME_SWIFT"
      cmd << "-L #{@toolchainDir}/ndk/sources/cxx-stl/llvm-libc++/libs/#{@cppPath}"
      cmd << "-L #{ndkToolchain}/lib/gcc/#{@ndkArchPath}/#{@ndk.gcc}.x" # Link the Android NDK's libc++ and libgcc.
      cmd << "-L #{@toolchainDir}/lib/swift/android/#{@archPath}"
      return cmd
   end

end
