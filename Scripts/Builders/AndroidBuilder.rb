require_relative "../Common/Builder.rb"

class AndroidBuilder < Builder

   def api
      return "21"
   end

   def gcc
      return "4.9"
   end

   def toolchain
      return "#{@sources}/toolchains/llvm/prebuilt/linux-x86_64"
   end

   def initialize(arch = Arch.default)
      super(Lib.ndk, arch)
      @sources = "#{Config.sources}/#{@component}" + suffix
   end

   def download()
      version = "r19b"
      fileName = Tool.isMacOS? ? "android-ndk-#{version}-darwin-x86_64.zip" : "android-ndk-#{version}-linux-x86_64.zip"
      url = "https://dl.google.com/android/repository/#{fileName}"
      downloader = Downloader.new(Config.downloads, @sources, url, 'android-ndk-*')
      downloader.bootstrap()
   end

   # Fixme. Seems standalone toolchains has been deprecated. Update other builders and remove this step.
   # See: https://github.com/android-ndk/ndk/wiki/Changelog-r19-beta2
   def setup
      if File.exist?(@installs + "/bin/clang")
         message "You already have Standalone NDK installed at #{@installs}. Skipping."
         return
      end
      cmd = []
      cmd << "#{@sources}/build/tools/make-standalone-toolchain.sh"
      cmd << "--platform=android-#{api}"
      cmd << "--install-dir=#{@installs}"
      if @arch == Arch.armv7a
         cmd << "--toolchain=arm-linux-androideabi-4.9"
      elsif @arch == Arch.x86
         cmd << "--toolchain=x86-4.9"
      elsif @arch == Arch.aarch64
         cmd << "--toolchain=aarch64-linux-android-4.9"
      end
      execute cmd.join(" ")
      logSetupCompleted
   end

   def clean()
      removeInstalls()
   end

end
