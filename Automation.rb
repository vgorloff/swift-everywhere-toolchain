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
      helloExe = HelloExeBuilder.new(Arch.armv7a)
      helloLib = HelloLibBuilder.new(Arch.armv7a)
      
      action = ARGV.first
      if action.nil? then usage()
      elsif action.start_with?("build:") then build(action.sub("build:", '')) # Pass `SA_DRY_RUN=1 rake ...` for Dry run mode.
      elsif action.start_with?("clean:") then clean(action.sub("clean:", ''))
      elsif action.start_with?("build-project:") then buildProject(action.sub("build-project:", ''))
      elsif action == "checkout" then checkout()
      elsif action == "verify" then ADB.verify()
      elsif action == "clean-armv7a:exe" then ADB.new(helloExe.libs, helloExe.binary).clean
      elsif action == "clean-armv7a:lib" then ADB.new(helloLib.libs, helloLib.binary).clean
      elsif action == "deploy-armv7a:exe"
         helloExe.copyLibs()
         adb = ADB.new(helloExe.libs, helloExe.binary)
         adb.deploy()
         adb.run()
      elsif action == "deploy-armv7a:lib"
         helloLib.copyLibs()
         adb = ADB.new(helloLib.libs, helloLib.binary)
         adb.deploy()
         adb.run()
      else usage()
      end
   end
   
   def build(component)
      if component == "toolchain" then buildAll()
      elsif component == "xml" then buildXML()
      elsif component == "icu" then buildICU()
      elsif component == "curl" then buildCURL()
      elsif component == "ssl" then buildSSL()
      elsif component == "deps" then buildDeps()
      elsif component == "libs" then buildLibs()
      elsif component == "swift" then SwiftBuilder.new().make
      elsif component == "dispatch" then buildDispatch()
      elsif component == "foundation" then buildFoundation()
      elsif component == "llvm" then buildLLVM()
      else
         puts "! Unknown component \"#{component}\"."
         usage()
      end
   end
   
   def clean(component)
      if component == "curl" then cleanCURL()
      elsif component == "xml" then cleanXML()
      elsif component == "deps" then cleanDeps()
      elsif component == "dispatch" then cleanDispatch()
      elsif component == "foundation" then cleanFoundation()
      elsif component == "llvm" then cleanLLVM()
      elsif component == "libs" then cleanLibs()
      elsif component == "swift" then SwiftBuilder.new().clean
      else
         puts "! Unknown component \"#{component}\"."
         usage()
      end
   end
   
   def buildProject(project)
      if project == "exe" then buildProjectExe()
      elsif project == "lib" then buildProjectLib()
      else
         puts "! Unknown project \"#{project}\"."
         usage()
      end
   end

   def checkout()
      Checkout.new().checkout()
   end

   def buildAll()
      swift = SwiftBuilder.new()
      buildLLVM()
      buildDeps()
      swift.make
      buildLibs()
      puts ""
      tool = Tool.new()
      tool.print("\"Swift Toolchain for Android\" build is completed.")
      tool.print("It can be found in \"#{swift.installs}\".")
      puts ""
   end

   def buildLLVM()
      LLVMBuilder.new().make
      CMarkBuilder.new().make
   end
   
   def cleanLLVM()
      LLVMBuilder.new().clean
      CMarkBuilder.new().clean
   end
   
   def buildProjectExe()
      HelloExeBuilder.new(Arch.armv7a).build
   end
   
   def buildProjectLib()
      HelloLibBuilder.new(Arch.armv7a).build
   end
   
   def cleanICU()
      ICUHostBuilder.new().clean
      ICUBuilder.new(Arch.armv7a).clean
      ICUBuilder.new(Arch.aarch64).clean
      ICUBuilder.new(Arch.x86).clean
   end
   
   def buildICU()
      cleanICU()
      ICUHostBuilder.new().make
      ICUBuilder.new(Arch.armv7a).make
      ICUBuilder.new(Arch.aarch64).make
      ICUBuilder.new(Arch.x86).make
   end
   
   def buildSSL()
      OpenSSLBuilder.new(Arch.armv7a).make
      OpenSSLBuilder.new(Arch.aarch64).make
      OpenSSLBuilder.new(Arch.x86).make
   end
   
   def cleanSSL()
      OpenSSLBuilder.new(Arch.armv7a).clean
      OpenSSLBuilder.new(Arch.aarch64).clean
      OpenSSLBuilder.new(Arch.x86).clean
   end
   
   def cleanCURL()
      CurlBuilder.new(Arch.armv7a).clean
      CurlBuilder.new(Arch.aarch64).clean
      CurlBuilder.new(Arch.x86).clean
   end
   
   def buildCURL()
      CurlBuilder.new(Arch.armv7a).make
      CurlBuilder.new(Arch.aarch64).make
      CurlBuilder.new(Arch.x86).make
   end
   
   def cleanXML()
      XMLBuilder.new(Arch.armv7a).clean
      XMLBuilder.new(Arch.aarch64).clean
      XMLBuilder.new(Arch.x86).clean
   end
   
   def buildXML()
      XMLBuilder.new(Arch.armv7a).make
      XMLBuilder.new(Arch.aarch64).make
      XMLBuilder.new(Arch.x86).make
   end

   def cleanDeps()
      cleanICU()
      cleanXML()
      cleanSSL()
      cleanCURL()
   end

   def buildDeps()
      buildICU()
      buildXML()
      buildSSL()
      buildCURL()
   end
   
   def cleanLibs()
      cleanDispatch()
      cleanFoundation()
   end

   def buildLibs()
      buildDispatch()
      buildFoundation()
   end
   
   def cleanDispatch()
      DispatchBuilder.new(Arch.armv7a).clean
      DispatchBuilder.new(Arch.aarch64).clean
      DispatchBuilder.new(Arch.x86).clean
   end
   
   def buildDispatch()
      DispatchBuilder.new(Arch.armv7a).make
      DispatchBuilder.new(Arch.aarch64).make
      DispatchBuilder.new(Arch.x86).make
   end
   
   def cleanFoundation()
      FoundationBuilder.new(Arch.armv7a).clean
      FoundationBuilder.new(Arch.aarch64).clean
      FoundationBuilder.new(Arch.x86).clean
   end
   
   def buildFoundation()
      FoundationBuilder.new(Arch.armv7a).make
      FoundationBuilder.new(Arch.aarch64).make
      FoundationBuilder.new(Arch.x86).make
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
   $ make build:toolchain
   $ make build-project:exe
   $ make build-project:lib
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
   $ make deploy-armv7a:exe
   $ make deploy-armv7a:lib
EOM

      tool.print(help, 36)
   end

end
