require_relative "../Common/Builder.rb"

class AndroidBuilder < Builder

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

   def api
      return "21"
   end

   def gcc
      return "4.9"
   end

   def toolchain
      return "#{@sources}/toolchains/llvm/prebuilt/linux-x86_64"
   end

end
