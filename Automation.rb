require_relative "Scripts/Common/ADB.rb"
require_relative "Scripts/Common/Tool.rb"
require_relative "Scripts/Common/Checkout.rb"
require_relative "Scripts/Common/NDK.rb"

require_relative "Scripts/Builders/ICUBuilder.rb"
require_relative "Scripts/Builders/SwiftBuilder.rb"
require_relative "Scripts/Builders/FoundationBuilder.rb"
require_relative "Scripts/Builders/DispatchBuilder.rb"
require_relative "Scripts/Builders/CurlBuilder.rb"
require_relative "Scripts/Builders/OpenSSLBuilder.rb"
require_relative "Scripts/Builders/XMLBuilder.rb"
require_relative "Scripts/Builders/LLVMBuilder.rb"
require_relative "Scripts/Builders/CMarkBuilder.rb"
require_relative "Scripts/Builders/ClangBuilder.rb"
require_relative "Scripts/Builders/CompilerRTBuilder.rb"

require_relative "Projects/HelloExeBuilder.rb"
require_relative "Projects/HelloLibBuilder.rb"

class Automation
  
   def perform()
      action = ARGV.first
      if action == "checkout"
         checkout()
      elsif action == "build"
         # Pass `SA_DRY_RUN=1 rake ...` for Dry run mode.
         build()
      elsif action == "build:xml"
         XMLBuilder.new(Arch.armv7a).make
      else
         usage()
      end
   end

   def checkout()
      Checkout.new().checkout()
   end

   def build()
      buildLLVM()
      buildDeps()
      buildSwift()
   end

   def buildLLVM()
      LLVMBuilder.new().make
      CMarkBuilder.new().make
   end

   def buildDeps()
      ICUHostBuilder.new().clean
      ICUBuilder.new(Arch.armv7a).clean
      ICUHostBuilder.new().make
      ICUBuilder.new(Arch.armv7a).make
      XMLBuilder.new(Arch.armv7a).make
      OpenSSLBuilder.new(Arch.armv7a).make
      CurlBuilder.new(Arch.armv7a).make
   end

   def buildSwift()
      tool = Tool.new()
      swift = SwiftBuilder.new(Arch.armv7a)
      swift.make
      DispatchBuilder.new(Arch.armv7a).make
      FoundationBuilder.new(Arch.armv7a).make
      puts ""
      tool.print("\"Swift Toolchain for Android\" build is completed.")
      tool.print("It can be found in \"#{swift.installs}\".")
      puts ""
   end

   def usage()
      tool = Tool.new()

      tool.print("\nBuilding Swift Toolchain. Steps:\n", 32)

      tool.print("1. Get Sources and Tools.", 32)
      help = <<EOM
   $ make checkout
EOM
      tool.print(help, 36)

      tool.print("2. Build all Swift components and Sample projects for armv7a.", 32)
      help = <<EOM
   $ make build
   $ make armv7a:project:buildExe
   $ make armv7a:project:buildLib
EOM
      tool.print(help, 36)

      tool.print("3. Enable USB Debugging on Android device. Install Android Tools for macOS. Connect Android device and Verify ADB shell setup.", 32)
      help = <<EOM
   $ make verify

   References:
   - How to Install Android Tools for macOS: https://stackoverflow.com/questions/17901692/set-up-adb-on-mac-os-x
   - How to Enable USB Debugging on Android device: https://developer.android.com/studio/debug/dev-options
EOM
      tool.print(help, 36)

      tool.print("4. Deploy and run Demo projects to Android Device.", 32)
      help = <<EOM
   $ make armv7a:project:deployExe
   $ make armv7a:project:deployLib
EOM

      tool.print(help, 36)
   end

end
