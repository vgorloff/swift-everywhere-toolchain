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
require 'fileutils'

class Automation
  
   def perform()
      action = ARGV.first
      if action.nil? then usage()
      elsif action.start_with?("build:") then build(action.sub("build:", '')) # Pass `SA_DRY_RUN=1 rake ...` for Dry run mode.
      elsif action.start_with?("clean:") then clean(action.sub("clean:", ''))
      elsif action.start_with?("deploy:projects:") then deploy(action.sub("deploy:projects:", ''))
      elsif action == "checkout" then checkout()
      elsif action == "verify" then ADB.verify()
      elsif action == "archive" then archive()
      elsif action == "compress" then compress()
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
     adb1 = ADB.new(helloExe.libs, helloExe.binary)
     adb1.deploy()
     adb2 = ADB.new(helloLib.libs, helloLib.binary)
     adb2.deploy()
     adb1.run()
     adb2.run()
   end
   
   def archive()
     toolchainDir = Config.toolchainDir
     if File.exists?(toolchainDir)
        FileUtils.rm_rf(toolchainDir)
     end
     FileUtils.mkdir_p(toolchainDir)
     File.symlink("/Users/vagrant/Library/Android/sdk/ndk-bundle", "#{toolchainDir}/ndk")

     copyToolchainFiles()
     fixModuleMaps()
     copyAssets()
     copyLicenses()
   end
   
   def copyAssets()
     toolchainDir = Config.toolchainDir
     FileUtils.copy_entry("#{Config.root}/Assets/Readme.md", "#{toolchainDir}/Readme.md", false, false, true)
     FileUtils.copy_entry("#{Config.root}/VERSION", "#{toolchainDir}/VERSION", false, false, true)
     utils = Dir["#{Config.root}/Assets/swiftc-*"]
     utils += Dir["#{Config.root}/Assets/copy-libs-*"]
     utils.each { |file|
       FileUtils.copy_entry(file, "#{toolchainDir}/bin/#{File.basename(file)}", false, false, true)
     }
   end
   
   def copyLicenses()
     toolchainDir = Config.toolchainDir
     sourcesDir = Config.sources
     files = []
     files << "#{sourcesDir}/#{Lib.clang}/LICENSE.TXT"
     files << "#{sourcesDir}/#{Lib.cmark}/COPYING"
     files << "#{sourcesDir}/#{Lib.crt}/LICENSE.TXT"
     files << "#{sourcesDir}/#{Lib.curl}/COPYING"
     files << "#{sourcesDir}/#{Lib.icu}/icu4c/LICENSE"
     files << "#{sourcesDir}/#{Lib.llvm}/LICENSE.TXT"
     files << "#{sourcesDir}/#{Lib.ssl}/LICENSE"
     files << "#{sourcesDir}/#{Lib.dispatch}/LICENSE"
     files << "#{sourcesDir}/#{Lib.foundation}/LICENSE"
     files << "#{sourcesDir}/#{Lib.xml}/Copyright"
     files.each { |file|
        dst = file.sub(sourcesDir, "#{toolchainDir}/share")
        puts "- Copying \"#{file}\""
        FileUtils.mkdir_p(File.dirname(dst))
        FileUtils.copy_entry(file, dst, false, false, true)
     }
   end
   
   def fixModuleMaps()
     moduleMaps = Dir["#{Config.toolchainDir}/lib/swift/**/glibc.modulemap"]
     moduleMaps.each { |file|
        puts "Correcting \"#{file}\""
        contents = File.read(file)
        contents = contents.gsub(/\/Users\/.+\/ndk-bundle/, "../../../../ndk")
        File.write(file, contents)
     }
   end
   
   def copyToolchainFiles()
     toolchainDir = Config.toolchainDir
     root = SwiftBuilder.new().installs
     files = Dir["#{root}/bin/**/*"]
     files += Dir["#{root}/lib/**/*"].reject { |file| file.end_with?(".dylib") }
     files += Dir["#{root}/share/**/*"]
     copyFiles(files, root, toolchainDir)

     archs = [Arch.armv7a, Arch.aarch64, Arch.x86, Arch.x64]
     archs.each { |arch|
       root = DispatchBuilder.new(arch).installs
       files = Dir["#{root}/lib/**/*"]
       copyFiles(files, root, toolchainDir)

       root = FoundationBuilder.new(arch).installs
       files = Dir["#{root}/lib/**/*"]
       copyFiles(files, root, toolchainDir)

       root = ICUBuilder.new(arch).installs
       files = Dir["#{root}/lib/*.so"]
       copyLibFiles(files, root, toolchainDir, arch)

       root = OpenSSLBuilder.new(arch).installs
       files = Dir["#{root}/lib/*.so"]
       copyLibFiles(files, root, toolchainDir, arch)

       root = CurlBuilder.new(arch).installs
       files = Dir["#{root}/lib/*.so"]
       copyLibFiles(files, root, toolchainDir, arch)

       root = XMLBuilder.new(arch).installs
       files = Dir["#{root}/lib/*.so"]
       copyLibFiles(files, root, toolchainDir, arch)
     }
   end
   
   def compress()
     puts "Compressing \"#{Config.toolchainDir}\""
     baseName = File.basename(Config.toolchainDir)
     system("cd \"#{File.dirname(Config.toolchainDir)}\" && tar -czf #{baseName}.tar.gz --options='compression-level=9' #{baseName}")
   end
   
   def copyFiles(files, source, destination)
     files.each { |file|
       dst = file.sub(source, destination)
       puts "- Copying \"#{file}\""
       FileUtils.mkdir_p(File.dirname(dst))
       FileUtils.copy_entry(file, dst, false, false, true)
     }
   end
   
   def copyLibFiles(files, source, destination, arch)
     if arch == Arch.armv7a
        archPath = "armv7"
     elsif arch == Arch.x86
        archPath = "i686"
     elsif arch == Arch.aarch64
        archPath = "aarch64"
     elsif arch == Arch.x64
        archPath = "x86_64"
     end
     files.each { |file|
       dst = file.sub(source, destination).sub("/lib/", "/lib/swift/android/#{archPath}/")
       puts "Copying \"#{file}\""
       FileUtils.mkdir_p(File.dirname(dst))
       FileUtils.copy_entry(file, dst, false, false, true)
     }
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
         HelloExeBuilder.new(Arch.x64).build
      elsif project == "lib"
         HelloLibBuilder.new(Arch.armv7a).build
         HelloLibBuilder.new(Arch.aarch64).build
         HelloLibBuilder.new(Arch.x86).build
         HelloLibBuilder.new(Arch.x64).build
      else
         puts "! Unknown project \"#{project}\"."
         usage()
      end
   end

   def checkout()
      Checkout.new().checkout()
   end

   def buildAll()
      buildLLVM()
      buildDeps()
      SwiftBuilder.new().make
      buildLibs()
      archive()
      compress()
      puts ""
      tool = Tool.new()
      tool.print("\"Swift Toolchain for Android\" build is completed.")
      tool.print("It can be found in \"#{Config.toolchainDir}\".")
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
      ICUBuilder.new(Arch.x64).clean
   end
   
   def buildICU()
      ICUHostBuilder.new().make
      ICUBuilder.new(Arch.armv7a).make
      ICUBuilder.new(Arch.aarch64).make
      ICUBuilder.new(Arch.x86).make
      ICUBuilder.new(Arch.x64).make
   end
   
   def buildSSL()
      OpenSSLBuilder.new(Arch.armv7a).make
      OpenSSLBuilder.new(Arch.aarch64).make
      OpenSSLBuilder.new(Arch.x86).make
      OpenSSLBuilder.new(Arch.x64).make
   end
   
   def cleanSSL()
      OpenSSLBuilder.new(Arch.armv7a).clean
      OpenSSLBuilder.new(Arch.aarch64).clean
      OpenSSLBuilder.new(Arch.x86).clean
      OpenSSLBuilder.new(Arch.x64).clean
   end
   
   def cleanCURL()
      CurlBuilder.new(Arch.armv7a).clean
      CurlBuilder.new(Arch.aarch64).clean
      CurlBuilder.new(Arch.x86).clean
      CurlBuilder.new(Arch.x64).clean
   end
   
   def buildCURL()
      CurlBuilder.new(Arch.armv7a).make
      CurlBuilder.new(Arch.aarch64).make
      CurlBuilder.new(Arch.x86).make
      CurlBuilder.new(Arch.x64).make
   end
   
   def cleanXML()
      XMLBuilder.new(Arch.armv7a).clean
      XMLBuilder.new(Arch.aarch64).clean
      XMLBuilder.new(Arch.x86).clean
      XMLBuilder.new(Arch.x64).clean
   end
   
   def buildXML()
      XMLBuilder.new(Arch.armv7a).make
      XMLBuilder.new(Arch.aarch64).make
      XMLBuilder.new(Arch.x86).make
      XMLBuilder.new(Arch.x64).make
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
      DispatchBuilder.new(Arch.x64).clean
   end
   
   def buildDispatch()
      DispatchBuilder.new(Arch.armv7a).make
      DispatchBuilder.new(Arch.aarch64).make
      DispatchBuilder.new(Arch.x86).make
      DispatchBuilder.new(Arch.x64).make
   end
   
   def cleanFoundation()
      FoundationBuilder.new(Arch.armv7a).clean
      FoundationBuilder.new(Arch.aarch64).clean
      FoundationBuilder.new(Arch.x86).clean
      FoundationBuilder.new(Arch.x64).clean
   end
   
   def buildFoundation()
      FoundationBuilder.new(Arch.armv7a).make
      FoundationBuilder.new(Arch.aarch64).make
      FoundationBuilder.new(Arch.x86).make
      FoundationBuilder.new(Arch.x64).make
   end

   def usage()
      tool = Tool.new()

      tool.print("\nBuilding Swift Toolchain. Steps:\n", 32)

      tool.print("1. Get Sources and Tools.", 32)
      help = <<EOM
   $ make checkout
EOM
      tool.print(help, 36)

      tool.print("2. Build all Swift components and Sample projects.", 32)
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
   $ make deploy:projects:x86_64
EOM

      tool.print(help, 36)
   end

end
