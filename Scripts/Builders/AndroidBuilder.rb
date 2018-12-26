require_relative "../Common/Builder.rb"

class AndroidBuilder < Builder

   def api
      return "21"
   end

   def initialize(arch = Arch.default)
      super(Lib.ndk, arch)
      @sources = "#{Config.sources}/#{@component}" + suffix
   end

   def download()
      fileName = Tool.isMacOS ? "android-ndk-r18b-darwin-x86_64.zip" : "android-ndk-r18b-linux-x86_64.zip"
      url = "https://dl.google.com/android/repository/#{fileName}"
      downloader = Downloader.new(Config.downloads, @sources, url, Tool.isMacOS? ? 'android-ndk-*-darwin*': 'android-ndk-*-linux*')
      downloader.bootstrap()
   end

   # Fixme. Seems standalone toolchains has been deprecated. Update other builders and remove this step.
   # See: https://github.com/android-ndk/ndk/wiki/Changelog-r19-beta2
   def setup
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
