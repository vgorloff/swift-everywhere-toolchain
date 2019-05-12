require_relative "Scripts/Common/Tool.rb"
require_relative "Scripts/Common/Checkout.rb"
require_relative "Scripts/Common/NDK.rb"

require_relative "Scripts/Builders/ICUBuilder.rb"
require_relative "Scripts/Builders/ICUHostBuilder.rb"
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

require 'fileutils'

globalArch = ENV['SA_ARCH']
archsToBuild = [Arch.armv7a, Arch.aarch64, Arch.x86, Arch.x64]
if !globalArch.nil?
   archsToBuild = [globalArch]
end

class Automation

   def usage()
       tool = Tool.new()

       tool.print("\nBuilding Toolchain with One Action:\n", 33)

       tool.print("$ make bootstrap\n", 36)

       tool.print("Building Toolchain Step-by-Step:\n", 33)

       tool.print("1. Checkout sources:", 32)
       tool.print("$ make checkout\n", 36)

       tool.print("2. Build toolchain:", 32)
       tool.print("$ make build\n", 36)

       tool.print("3. Install toolchain:", 32)
       tool.print("$ make install\n", 36)

       tool.print("4. Archive toolchain:", 32)
       tool.print("$ make archive\n", 36)

       tool.print("5. (Optional) Clean toolchain build:", 32)
       tool.print("$ make clean\n", 36)

       tool.print("Building certain component (i.e. llvm, icu, xml, ssl, curl, swift, dispatch, foundation):\n", 33)

       tool.print("To build only certain component:", 32)
       tool.print("$ make build:llvm\n", 36)

       tool.print("To clean only certain component:", 32)
       tool.print("$ make clean:llvm\n", 36)
   end

   # Pass `SA_DRY_RUN=1 make ...` for Dry run mode.
   # Pass `SA_ARCH=armv7a make ...` to build only armv7a.
   def perform()
      action = ARGV.first
      if action.nil? then usage()
      elsif action == "bootstrap" then bootstrap()
      elsif action == "build" then build()
      elsif action == "checkout" then Checkout.new().checkout()
      elsif action == "install" then install()
      elsif action == "archive" then archive()
      elsif action == "clean" then clean()
      elsif action.start_with?("build:") then buildComponent(action.sub("build:", ''))
      elsif action.start_with?("clean:") then cleanComponent(action.sub("clean:", ''))
      else usage()
      end
   end

   def buildComponent(component)
      if component == "xml" then buildXML()
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

   def cleanComponent(component)
      if component == "curl" then cleanCURL()
      elsif component == "icu" then cleanICU()
      elsif component == "xml" then cleanXML()
      elsif component == "ssl" then cleanSSL()
      elsif component == "curl" then cleanCURL()
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

   def install()
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

     archsToBuild.each { |arch|
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

   def archive()
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

   def bootstrap()
     Checkout.new().checkout()
     build()
     install()
     archive()
     puts ""
     tool = Tool.new()
     tool.print("\"Swift Toolchain for Android\" build is completed.")
     tool.print("It can be found in \"#{Config.toolchainDir}\".")
     puts ""
   end

   def clean()
     cleanLLVM()
     cleanDeps()
     SwiftBuilder.new().clean
     cleanLibs()
   end

   def build()
      buildLLVM()
      buildDeps()
      SwiftBuilder.new().make
      buildLibs()
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
      archsToBuild.each { |arch| ICUBuilder.new(arch).clean }
   end

   def buildICU()
      ICUHostBuilder.new().make
      archsToBuild.each { |arch| ICUBuilder.new(arch).make }
   end

   def buildSSL()
      archsToBuild.each { |arch| OpenSSLBuilder.new(arch).make }
   end

   def cleanSSL()
      archsToBuild.each { |arch| OpenSSLBuilder.new(arch).clean }
   end

   def cleanCURL()
      archsToBuild.each { |arch| CurlBuilder.new(arch).clean }
   end

   def buildCURL()
      archsToBuild.each { |arch| CurlBuilder.new(arch).make }
   end

   def cleanXML()
      archsToBuild.each { |arch| XMLBuilder.new(arch).clean }
   end

   def buildXML()
      archsToBuild.each { |arch| XMLBuilder.new(arch).make }
   end

   def cleanDispatch()
      archsToBuild.each { |arch| DispatchBuilder.new(arch).clean }
   end

   def buildDispatch()
      archsToBuild.each { |arch| DispatchBuilder.new(arch).make }
   end

   def cleanFoundation()
      archsToBuild.each { |arch| FoundationBuilder.new(arch).clean }
   end

   def buildFoundation()
      archsToBuild.each { |arch| FoundationBuilder.new(arch).make }
   end

end
