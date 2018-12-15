require_relative "../Common/Builder.rb"

class AndroidBuilder < Builder

   def self.api
      return "21"
   end

   def initialize(arch = Arch.default)
      super(Lib.ndk, arch)
      @installDir = Config.ndkInstallRoot + "/#{@arch}"
   end

   def download()
      downloader = Downloader.new(Config.downloads, @sources, "https://dl.google.com/android/repository/android-ndk-r18b-linux-x86_64.zip", 'android-ndk-*')
      downloader.bootstrap()
   end

   def setup
      cmd = []
      cmd << "#{@sources}/build/tools/make-standalone-toolchain.sh"
      cmd << "--platform=android-#{AndroidBuilder.api}"
      cmd << "--install-dir=#{@install}"
      if @arch == Arch.armv7a
         cmd << "--toolchain=arm-linux-androideabi-4.9"
      elsif @arch == Arch.x86
         cmd << "--toolchain=x86-4.9"
      elsif @arch == Arch.aarch64
         cmd << "--toolchain=aarch64-linux-android-4.9"
      end
      execute cmd.join(" ")
   end

   def clean()
      execute "rm -rf #{@install}/"
   end

end
