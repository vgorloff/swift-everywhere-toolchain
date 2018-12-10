require_relative "Builder.rb"
require_relative "../Common/Config.rb"

class AndroidBuilder < Builder

   def initialize(arch)
      super()
      @arch = arch
      @installDir = Config.installRoot + "/android/#{@arch}"
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
      execute "rm -rf #{Config.buildRoot}/android/"
      execute "rm -rf #{Config.installRoot}/android/"
   end

end
