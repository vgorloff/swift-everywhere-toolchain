require_relative "../Scripts/Common/Builder.rb"
Dir[File.dirname(__FILE__) + '/../Scripts/**/*.rb'].each { |file| require file }

class ProjectBuilder < Builder

   attr_reader :binary

   def initialize(component, arch)
      super(component, arch)
      @toolchainDir = Config.toolchainDir
      @sources = "#{Config.projects}/#{component}"
      @binary = "#{@builds}/#{component}"
      if @arch == Arch.armv7a
         @ndkArchPath = "arm-linux-androideabi"
      elsif @arch == Arch.x86
         @ndkArchPath = "i686-linux-android"
      elsif @arch == Arch.aarch64
         @ndkArchPath = "aarch64-linux-android"
      elsif @arch == Arch.x64
         @ndkArchPath = "x86_64-linux-android"
      end
      @swiftc = @toolchainDir + "/bin/swiftc-" + @ndkArchPath
      @copyLibsCmd = @toolchainDir + "/bin/copy-libs-" + @ndkArchPath
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
      execute "#{@copyLibsCmd} #{targetDir}"
   end

end
