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
      if action.nil? then usage()
      elsif action.start_with?("build:") then build(action.sub("build:", '')) # Pass `SA_DRY_RUN=1 rake ...` for Dry run mode.
      elsif action.start_with?("clean:") then clean(action.sub("clean:", ''))
      elsif action.start_with?("deploy:projects:") then deploy(action.sub("deploy:projects:", ''))
      elsif action == "checkout" then checkout()
      elsif action == "verify" then ADB.verify()
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
      elsif component == "projects" then buildProjects()
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
      elsif component.start_with?("projects:") then cleanProjects(component.sub("projects:", ''))
      else
         puts "! Unknown component \"#{component}\"."
         usage()
      end
   end
   
   def deploy(arch)
     helloExe = HelloExeBuilder.new(arch)
     helloLib = HelloLibBuilder.new(arch)
     helloExe.copyLibs()
     helloLib.copyLibs()
     adb1 = ADB.new(helloExe.libs, helloExe.binary)
     adb1.deploy()
     adb2 = ADB.new(helloLib.libs, helloLib.binary)
     adb2.deploy()
     adb1.run()
     adb2.run()
   end

   def cleanProjects(arch)
     helloExe = HelloExeBuilder.new(arch)
     helloLib = HelloLibBuilder.new(arch)
     ADB.new(helloExe.libs, helloExe.binary).clean
     ADB.new(helloLib.libs, helloLib.binary).clean
   end
   
   def buildProjects()
      buildProject("exe")
      buildProject("lib")
   end
   
   def buildProject(project)
      if project == "exe"
         HelloExeBuilder.new(Arch.armv7a).build
         HelloExeBuilder.new(Arch.aarch64).build
         HelloExeBuilder.new(Arch.x86).build
      elsif project == "lib"
         HelloLibBuilder.new(Arch.armv7a).build
         HelloLibBuilder.new(Arch.aarch64).build
         HelloLibBuilder.new(Arch.x86).build
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
   $ make build:projects
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
   $ make deploy:projects:armv7a
   $ make deploy:projects:x86
EOM

      tool.print(help, 36)
   end

end
