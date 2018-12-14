require_relative "../Common/Builder.rb"

class AndroidBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.ndk, arch)
      @installDir = Config.ndkInstallRoot + "/#{@arch}"
   end

   def download()
      downloader = Downloader.new(Config.downloads, @sources, "https://dl.google.com/android/repository/android-ndk-r18b-linux-x86_64.zip", 'android-ndk-*')
      downloader.bootstrap()
   end

   def setupToolchain
      cmd = []
      cmd << "#{Config.ndkSourcesRoot}/build/tools/make-standalone-toolchain.sh"
      cmd << "--platform=android-#{Config.androidAPI}"
      cmd << "--install-dir=#{@installDir}"
      if @arch == "armv7a"
         cmd << "--toolchain=arm-linux-androideabi-4.9"
      elsif @arch == "x86"
         cmd << "--toolchain=x86-4.9"
      elsif @arch == "aarch64"
         cmd << "--toolchain=aarch64-linux-android-4.9"
      end
      execute cmd.join(" ")
   end

   def clean()
      execute "rm -rf #{Config.ndkInstallRoot}/"
   end

end
