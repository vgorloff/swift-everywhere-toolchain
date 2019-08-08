#
# The MIT License
#
# Copyright (c) 2019 Volodymyr Gorlov (https://github.com/vgorloff)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

require_relative "Scripts/Common/Tool.rb"
require_relative "Scripts/Common/Checkout.rb"
require_relative "Scripts/Common/NDK.rb"

require_relative "Scripts/Builders/ICUBuilder.rb"
require_relative "Scripts/Builders/ICUHostBuilder.rb"
require_relative "Scripts/Builders/ICUSwiftHostBuilder.rb"
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
require_relative "Scripts/Builders/SPMBuilder.rb"
require_relative "Scripts/Builders/LLBBuilder.rb"
require_relative "Scripts/Builders/SwiftSPMBuilder.rb"

require 'fileutils'

class Automation < Tool

   def usage()

       print("\nBuilding Toolchain with One Action:\n", 33)

       print("   $ make bootstrap\n", 36)

       print("Building Toolchain Step-by-Step:\n", 33)

       print("1. Checkout sources:", 32)
       print("   $ make checkout\n", 36)

       print("2. Build toolchain:", 32)
       print("   $ make build\n", 36)

       print("3. Install toolchain:", 32)
       print("   $ make install\n", 36)

       print("4. Archive toolchain:", 32)
       print("   $ make archive\n", 36)

       print("5. (Optional) Clean toolchain build:", 32)
       print("   $ make clean\n", 36)

       print("Building certain component (i.e. llvm, icu, xml, ssl, curl, swift, dispatch, foundation):\n", 33)

       print("To build only certain component:", 32)
       print("   $ make build:llvm\n", 36)

       print("To clean only certain component:", 32)
       print("   $ make clean:llvm\n", 36)
   end

   # Pass `SA_DRY_RUN=1 make ...` for Dry run mode.
   # Pass `SA_ARCH=armv7a make ...` to build only armv7a.
   def perform()
      if !verifyXcode
         exit 1
      end
      action = ARGV.first
      if action.nil? then usage()
      elsif action == "bootstrap" then bootstrap()
      elsif action == "build" then build()
      elsif action == "checkout" then Checkout.new().checkout()
      elsif action == "install" then install()
      elsif action == "archive" then archive()
      elsif action == "clean" then clean()
      elsif action == "status" then status()
      elsif action == "finalize"
         install()
         archive()
      elsif action.start_with?("build:") then buildComponent(action.sub("build:", ''))
      elsif action.start_with?("rebuild:") then rebuildComponent(action.sub("rebuild:", ''))
      elsif action.start_with?("clean:") then cleanComponent(action.sub("clean:", ''))
      elsif action.start_with?("install:") then installComponent(action.sub("install:", ''))
      elsif action.start_with?("reset:") then resetComponent(action.sub("reset:", ''))
      elsif action.start_with?("patch:") then patchComponent(action.sub("patch:", ''))
      elsif action.start_with?("unpatch:") then unpatchComponent(action.sub("unpatch:", ''))
      elsif action.start_with?("configure:") then configureComponent(action.sub("configure:", ''))
      else usage()
      end
   end

   def buildComponent(component)
      if component == "xml" then @archsToBuild.each { |arch| XMLBuilder.new(arch).make }
      elsif component == "icu" then @archsToBuild.each { |arch| ICUBuilder.new(arch).make }
      elsif component == "icuHost" then ICUHostBuilder.new().make
      elsif component == "icuSwift" then ICUSwiftHostBuilder.new().make
      elsif component == "curl" then @archsToBuild.each { |arch| CurlBuilder.new(arch).make }
      elsif component == "ssl" then @archsToBuild.each { |arch| OpenSSLBuilder.new(arch).make }
      elsif component == "deps" then buildDeps()
      elsif component == "libs"
         @archsToBuild.each { |arch| DispatchBuilder.new(arch).make }
         @archsToBuild.each { |arch| FoundationBuilder.new(arch).make }
      elsif component == "swift" then SwiftBuilder.new().make
      elsif component == "swift-spm" then SwiftSPMBuilder.new().make
      elsif component == "spm" then SPMBuilder.new().make
      elsif component == "llb" then LLBBuilder.new().make
      elsif component == "dispatch" then @archsToBuild.each { |arch| DispatchBuilder.new(arch).make }
      elsif component == "foundation" then @archsToBuild.each { |arch| FoundationBuilder.new(arch).make }
      elsif component == "cmark" then CMarkBuilder.new().make
      elsif component == "llvm" then LLVMBuilder.new().make
      else
         puts "! Unknown component \"#{component}\"."
         usage()
      end
   end

   def rebuildComponent(component)
      if component == "swift" then SwiftBuilder.new().rebuild()
      elsif component == "dispatch" then @archsToBuild.each { |arch| DispatchBuilder.new(arch).rebuild() }
      elsif component == "foundation" then @archsToBuild.each { |arch| FoundationBuilder.new(arch).rebuild() }
      elsif component == "xml" then @archsToBuild.each { |arch| XMLBuilder.new(arch).rebuild() }
      elsif component == "llb" then LLBBuilder.new().rebuild()
      elsif component == "spm" then SPMBuilder.new().rebuild()
      elsif component == "swift-spm" then SwiftSPMBuilder.new().rebuild()
      elsif component == "libs"
         @archsToBuild.each { |arch| DispatchBuilder.new(arch).rebuild() }
         @archsToBuild.each { |arch| FoundationBuilder.new(arch).rebuild() }
      elsif component == "stage-swift"
         rebuildComponent("swift")
         rebuildComponent("libs")
      elsif component == "stage-spm"
         rebuildComponent("llb")
         rebuildComponent("spm")
      else
         puts "! Unknown component \"#{component}\"."
         usage()
      end
   end

   def cleanComponent(component)
      if component == "curl" then @archsToBuild.each { |arch| CurlBuilder.new(arch).clean }
      elsif component == "icuHost" then ICUHostBuilder.new().clean
      elsif component == "icu" then @archsToBuild.each { |arch| ICUBuilder.new(arch).clean }
      elsif component == "xml" then @archsToBuild.each { |arch| XMLBuilder.new(arch).clean }
      elsif component == "ssl" then @archsToBuild.each { |arch| OpenSSLBuilder.new(arch).clean }
      elsif component == "dispatch" then @archsToBuild.each { |arch| DispatchBuilder.new(arch).clean }
      elsif component == "foundation" then @archsToBuild.each { |arch| FoundationBuilder.new(arch).clean }
      elsif component == "cmark" then CMarkBuilder.new().clean
      elsif component == "llvm" then LLVMBuilder.new().clean
      elsif component == "deps" then cleanDeps()
      elsif component == "libs" then cleanLibs()
      elsif component == "swift" then SwiftBuilder.new().clean
      elsif component == "spm" then SPMBuilder.new().clean
      elsif component == "llb" then LLBBuilder.new().clean
      else
         puts "! Unknown component \"#{component}\"."
         usage()
      end
   end

   def installComponent(component)
      if component == "curl" then @archsToBuild.each { |arch| CurlBuilder.new(arch).install }
      elsif component == "swift" then SwiftBuilder.new().install
      elsif component == "llvm" then LLVMBuilder.new().install
      elsif component == "foundation" then @archsToBuild.each { |arch| FoundationBuilder.new(arch).install }
      else
         puts "! Unknown component \"#{component}\"."
         usage()
      end
   end

   def configureComponent(component)
      if component == "swift" then SwiftBuilder.new().configure
      elsif component == "dispatch" then @archsToBuild.each { |arch| DispatchBuilder.new(arch).configure }
      elsif component == "llvm" then LLVMBuilder.new().configure
      else
         puts "! Unknown component \"#{component}\"."
         usage()
      end
   end

   def patchComponent(component)
      if component == "swift" then SwiftBuilder.new().patch
      elsif component == "dispatch" then DispatchBuilder.new(Arch.default).patch
      elsif component == "foundation" then FoundationBuilder.new(Arch.default).patch
      else
         puts "! Unknown component \"#{component}\"."
         usage()
      end
   end

   def unpatchComponent(component)
      if component == "swift" then SwiftBuilder.new().unpatch
      elsif component == "dispatch" then DispatchBuilder.new(Arch.default).unpatch
      elsif component == "foundation" then FoundationBuilder.new(Arch.default).unpatch
      else
         puts "! Unknown component \"#{component}\"."
         usage()
      end
   end

   def install()
     toolchainDir = Config.toolchainDir
     print("Installing toolchain into \"#{toolchainDir}\"", 32)
     if File.exists?(toolchainDir)
        FileUtils.rm_rf(toolchainDir)
     end
     FileUtils.mkdir_p(toolchainDir)
     File.symlink("/Users/vagrant/Library/Android/sdk/ndk-bundle", "#{toolchainDir}/ndk")

     copyToolchainFiles()
     fixModuleMaps()
     copyAssets()
     copyLicenses()
     print("Toolchain installed into \"#{toolchainDir}\"", 36)
   end

   def copyAssets()
     toolchainDir = Config.toolchainDir
     FileUtils.copy_entry("#{Config.root}/Assets/Readme.md", "#{toolchainDir}/Readme.md", false, false, true)
     FileUtils.copy_entry("#{Config.root}/VERSION", "#{toolchainDir}/VERSION", false, false, true)
     FileUtils.copy_entry("#{Config.root}/LICENSE.txt", "#{toolchainDir}/LICENSE.txt", false, false, true)
     utils = Dir["#{Config.root}/Assets/*"].reject { |file| file.include?("Readme.md") }
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
     files += Dir["#{root}/lib/**/*"]
     files += Dir["#{root}/share/**/*"]
     copyFiles(files, root, toolchainDir)

     @archsToBuild.each { |arch|
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
     print("Compressing \"#{Config.toolchainDir}\"", 32)
     baseName = File.basename(Config.toolchainDir)
     extName = 'tar.gz'
     fileName = "#{baseName}.#{extName}"
     system("cd \"#{File.dirname(Config.toolchainDir)}\" && tar -czf #{fileName} --options='compression-level=9' #{baseName}")
     print("Archive saved to \"#{Config.toolchainDir}.#{extName}\"", 36)
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
     print("\"Swift Toolchain for Android\" build is completed.")
     print("It can be found in \"#{Config.toolchainDir}\".")
     puts ""
   end

   def status()
      repos = []
      repos << "#{Config.sources}/#{Lib.clang}"
      repos << "#{Config.sources}/#{Lib.cmark}"
      repos << "#{Config.sources}/#{Lib.crt}"
      repos << "#{Config.sources}/#{Lib.curl}"
      repos << "#{Config.sources}/#{Lib.icu}"
      repos << "#{Config.sources}/#{Lib.llvm}"
      repos << "#{Config.sources}/#{Lib.ssl}"
      repos << "#{Config.sources}/#{Lib.swift}"
      repos << "#{Config.sources}/#{Lib.dispatch}"
      repos << "#{Config.sources}/#{Lib.foundation}"
      repos << "#{Config.sources}/#{Lib.xml}"
      repos << "#{Config.sources}/#{Lib.spm}"
      repos << "#{Config.sources}/#{Lib.llb}"
      repos.each { |repo|
         execute "cd \"#{repo}\" && git status"
      }
   end

   def clean()
     LLVMBuilder.new().clean
     CMarkBuilder.new().clean
     cleanDeps()
     SwiftBuilder.new().clean
     cleanLibs()
   end

   def build()
      LLVMBuilder.new().make
      CMarkBuilder.new().make
      buildDeps()
      SwiftBuilder.new().make
      @archsToBuild.each { |arch| DispatchBuilder.new(arch).make }
      @archsToBuild.each { |arch| FoundationBuilder.new(arch).make }
   end

   def cleanDeps()
      ICUHostBuilder.new().clean
      @archsToBuild.each { |arch| ICUBuilder.new(arch).clean }
      @archsToBuild.each { |arch| XMLBuilder.new(arch).clean }
      @archsToBuild.each { |arch| OpenSSLBuilder.new(arch).clean }
      @archsToBuild.each { |arch| CurlBuilder.new(arch).clean }
   end

   def buildDeps()
      ICUHostBuilder.new().make
      @archsToBuild.each { |arch| ICUBuilder.new(arch).make }
      @archsToBuild.each { |arch| XMLBuilder.new(arch).make }
      @archsToBuild.each { |arch| OpenSSLBuilder.new(arch).make }
      @archsToBuild.each { |arch| CurlBuilder.new(arch).make }
   end

   def cleanLibs()
      @archsToBuild.each { |arch| DispatchBuilder.new(arch).clean }
      @archsToBuild.each { |arch| FoundationBuilder.new(arch).clean }
   end

   def resetComponent(component)
      if component == "swift" then SwiftBuilder.new().reset()
      elsif component == "dispatch" then DispatchBuilder.new(Arch.default).reset()
      elsif component == "foundation" then FoundationBuilder.new(Arch.default).reset()
      elsif component == "libs"
         @archsToBuild.each { |arch| DispatchBuilder.new(arch).reset() }
         @archsToBuild.each { |arch| FoundationBuilder.new(arch).reset() }
      else
         puts "! Unknown component \"#{component}\"."
         usage()
      end
   end

end
