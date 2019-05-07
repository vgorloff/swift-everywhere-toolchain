require_relative "../Scripts/Common/Builder.rb"
Dir[File.dirname(__FILE__) + '/../Scripts/**/*.rb'].each { |file| require file }

class ProjectBuilder < Builder

   attr_reader :binary

   def initialize(component, arch)
      super(component, arch)
      @sources = "#{Config.projects}/#{component}"
      @swift = SwiftBuilder.new()
      @ndk = NDK.new()
      @dispatch = DispatchBuilder.new(@arch)
      @foundation = FoundationBuilder.new(@arch)
      @icu = ICUBuilder.new(@arch)
      @curl = CurlBuilder.new(@arch)
      @xml = XMLBuilder.new(arch)
      @ssl = OpenSSLBuilder.new(@arch)
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
      Dir["#{@swift.installs}/lib/swift/android/#{@archPath}" + "/*.so"].each { |lib|
         execute "cp -vf #{lib} #{targetDir}"
      }
      Dir["#{@dispatch.installs}/lib/swift/android" + "/*.so"].each { |lib|
         execute "cp -vf #{lib} #{targetDir}"
      }
      Dir["#{@foundation.installs}/lib/swift/android" + "/*.so"].each { |lib|
         execute "cp -vf #{lib} #{targetDir}"
      }
      Dir[@icu.lib + "/*.so"].each { |lib|
         execute "cp -vf #{lib} #{targetDir}"
      }
      Dir[@curl.lib + "/*.so"].each { |lib|
         execute "cp -vf #{lib} #{targetDir}"
      }
      Dir[@xml.lib + "/*.so"].each { |lib|
         execute "cp -vf #{lib} #{targetDir}"
      }
      Dir[@ssl.lib + "/*.so*"].each { |lib|
         execute "cp -vf #{lib} #{targetDir}"
      }
      cxxLibPath = "#{@ndk.sources}/sources/cxx-stl/llvm-libc++/libs/#{@cppPath}/libc++_shared.so"
      execute "cp -vf #{cxxLibPath} #{targetDir}"
      message "Copying Shared Objects completed."
   end

   def swiftFlags
      cmd = []
      cmd << "-target #{@target}"
      # cmd << "-v"
      cmd << "-tools-directory #{@ndk.toolchain}"
      cmd << "-sdk #{@ndk.sources}/platforms/android-#{@ndk.api}/arch-#{@platform}"
      cmd << "-Xcc -I#{@ndk.toolchain}/sysroot/usr/include -Xcc -I#{@ndk.toolchain}/sysroot/usr/include/#{@ndkArchPath}"
      cmd << "-Xcc -DDEPLOYMENT_TARGET_ANDROID -Xcc -DDEPLOYMENT_TARGET_LINUX -Xcc -DDEPLOYMENT_RUNTIME_SWIFT"
      cmd << "-I #{@dispatch.installs}/lib/swift/dispatch"
      cmd << "-I #{@dispatch.installs}/lib/swift/android/#{@archPath}"
      cmd << "-I #{@dispatch.installs}/lib/swift"
      cmd << "-I #{@foundation.installs}/lib/swift/android/#{@archPath}"
      cmd << "-I #{@foundation.installs}/lib/swift/CoreFoundation"
      cmd << "-I #{@foundation.installs}/lib/swift"
      cmd << "-L #{@ndk.sources}/sources/cxx-stl/llvm-libc++/libs/#{@cppPath}"
      cmd << "-L #{@ndk.toolchain}/lib/gcc/#{@ndkArchPath}/#{@ndk.gcc}.x" # Link the Android NDK's libc++ and libgcc.
      cmd << "-L #{@foundation.installs}/lib/swift/android"
      cmd << "-L #{@dispatch.installs}/lib/swift/android"
      cmd << "-L #{@swift.installs}/lib/swift/android/#{@archPath}"
      return cmd
   end

end
