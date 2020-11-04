require_relative "ADB.rb"
require_relative "Tool.rb"

class ProjectBuilder < Tool

   attr_reader :binary

   def self.usage()
      tool = Tool.new()

      tool.print("\n1. Build project:", 32)
      tool.print("   $ make build\n", 36)

      tool.print("2. Enable USB Debugging on Android device. Install Android Tools for macOS. Connect Android device and Verify ADB shell setup.", 32)
      help = <<EOM
   $ make verify

   References:
   - How to Install Android Tools for macOS: https://stackoverflow.com/questions/17901692/set-up-adb-on-mac-os-x
   - How to Enable USB Debugging on Android device: https://developer.android.com/studio/debug/dev-options
EOM
      tool.print(help, 36)

      tool.print("3. Deploy and run project on Android Device or Simulator.", 32)
      help = <<EOM
   $ make deploy:armv7a
   $ make deploy:aarch64
   $ make deploy:x86
   $ make deploy:x86_64
EOM
      tool.print(help, 36)

      tool.print("4. (Optional) Clean deployed project:", 32)
      tool.print("   $ make clean:armv7a", 36)
      tool.print("   $ make clean:aarch64", 36)
      tool.print("   $ make clean:x86", 36)
      tool.print("   $ make clean:x86_64", 36)

      tool.print("\n5. (Optional) Clean project:", 32)
      tool.print("   $ make clean\n", 36)
   end

   def self.perform()
      action = ARGV.first
      if action.nil? then usage()
      elsif action == "build" then build()
      elsif action == "clean" then clean()
      elsif action == "verify" then ADB.verify()
      elsif action.start_with?("clean:") then undeploy(action.sub("clean:", ''))
      elsif action.start_with?("deploy:") then deploy(action.sub("deploy:", ''))
      else usage()
      end
   end

   def self.build()
      Tool.new().archsToBuild.each { |arch| Builder.new(arch).build() }
   end

   def self.clean()
      Tool.new().archsToBuild.each { |arch| Builder.new(arch).clean() }
   end

   def self.deploy(arch)
      Builder.new(arch).deploy()
   end

   def self.undeploy(arch)
      Builder.new(arch).undeploy()
   end

   def initialize(component, arch)
      @isVerbose = false
      @arch = arch
      @component = component
      @sources = "#{@root}/Sources"
      @builds = "#{@root}/build-#{arch}"
      @config = "release"
      @toolchainDir = File.expand_path(File.join(File.dirname(__FILE__), "../../ToolChain/swift-android-toolchain"))
      if @arch == "armv7a"
         @ndkArchPath = "arm-linux-androideabi"
         @swiftTarget = "armv7-none-linux-androideabi"
      elsif @arch == "x86"
         @ndkArchPath = "i686-linux-android"
         @swiftTarget = "i686-unknown-linux-android"
      elsif @arch == "aarch64"
         @ndkArchPath = "aarch64-linux-android"
         @swiftTarget = "aarch64-unknown-linux-android"
      elsif @arch == "x86_64"
         @ndkArchPath = "x86_64-linux-android"
         @swiftTarget = "x86_64-unknown-linux-android"
      end
      @swiftc = @toolchainDir + "/usr/bin/swiftc-" + @ndkArchPath
      @copyLibsCmd = @toolchainDir + "/usr/bin/copy-libs-" + @ndkArchPath
      @swiftBuildCmd = "#{@toolchainDir}/usr/bin/android-swift-build --android-target #{@swiftTarget} -c #{@config} --build-path #{@builds}"

      if @isVerbose
         @swiftc += " -v"
         @copyLibsCmd += " -v"
         @swiftBuildCmd += " -v"
      end
   end

   def libs
      return Dir["#{@builds}/lib/*"]
   end

   def copyLibs()
      targetDir = "#{@builds}/lib"
      execute "rm -rf \"#{targetDir}\""
      execute "#{@copyLibsCmd} #{targetDir}"
   end

   def build
      clean()
      execute "mkdir -p \"#{@builds}\""
      executeBuild()
   end

   def clean
      execute "rm -rf \"#{@builds}\""
   end

   def deploy()
      adb = ADB.new(libs, binary)
      adb.deploy()
      adb.run()
   end

   def undeploy()
      ADB.new(libs, binary).clean
   end

end
