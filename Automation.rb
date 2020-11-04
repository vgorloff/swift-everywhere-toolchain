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
require_relative "Scripts/Builders/SPMBuilder.rb"
require_relative "Scripts/Builders/LLBBuilder.rb"
require_relative "Scripts/Builders/SwiftSPMBuilder.rb"

require 'fileutils'

class Automation < Tool

   def perform()
      elsif action == "install" then install()
      elsif action == "test" then test()
   end

   def install()
     toolchainDir = Config.toolchainDir
     print("Installing toolchain into \"#{toolchainDir}\"", 32)
     if File.exist?(toolchainDir)
        FileUtils.rm_rf(toolchainDir)
     end
     FileUtils.mkdir_p(toolchainDir)

     copyToolchainFiles()
     fixModuleMaps()
     copyAssets()
     copyLicenses()
     print("Toolchain installed into \"#{toolchainDir}\"", 36)
   end

   def copyAssets()
     toolchainDir = Config.toolchainDir
     FileUtils.copy_entry("#{Config.root}/Assets/Readme.md", "#{toolchainDir}/Readme.md", false, false, true)
     FileUtils.copy_entry("#{Config.root}/CHANGELOG", "#{toolchainDir}/CHANGELOG", false, false, true)
     FileUtils.copy_entry("#{Config.root}/VERSION", "#{toolchainDir}/VERSION", false, false, true)
     FileUtils.copy_entry("#{Config.root}/LICENSE.txt", "#{toolchainDir}/LICENSE.txt", false, false, true)
     utils = Dir["#{Config.root}/Assets/*"].reject { |file| file.include?("Readme.md") }
     utils.each { |file|
       puts "- Copying \"#{file}\""
       FileUtils.copy_entry(file, "#{toolchainDir}/usr/bin/#{File.basename(file)}", false, false, true)
     }
   end

   def copyLicenses()
     toolchainDir = Config.toolchainDir
     sourcesDir = Config.sources
     files = []
     files << "#{sourcesDir}/#{Lib.cmark}/COPYING"
     files << "#{sourcesDir}/#{Lib.curl}/COPYING"
     files << "#{sourcesDir}/#{Lib.icu}/icu4c/LICENSE"
     files << "#{sourcesDir}/#{Lib.llvm}/LICENSE.TXT"
     files << "#{sourcesDir}/#{Lib.llvm}/clang/LICENSE.TXT"
     files << "#{sourcesDir}/#{Lib.llvm}/compiler-rt/LICENSE.TXT"
     files << "#{sourcesDir}/#{Lib.ssl}/LICENSE"
     files << "#{sourcesDir}/#{Lib.dispatch}/LICENSE"
     files << "#{sourcesDir}/#{Lib.foundation}/LICENSE"
     files << "#{sourcesDir}/#{Lib.xml}/Copyright"
     files.each { |file|
        dst = file.sub(sourcesDir, "#{toolchainDir}/usr/share")
        puts "- Copying \"#{file}\""
        FileUtils.mkdir_p(File.dirname(dst))
        FileUtils.copy_entry(file, dst, false, false, true)
     }
   end

   def fixModuleMaps()
      moduleMaps = Dir["#{Config.toolchainDir}/usr/lib/swift/**/glibc.modulemap"]
      moduleMaps.each { |file|
         puts "* Correcting \"#{file}\""
         contents = File.read(file)
         contents = contents.gsub(/header\s+\".+sysroot/, "header \"/usr/local/ndk/sysroot")
         File.write(file, contents)
      }
   end

   def copyToolchainFiles()
     toolchainDir = "#{Config.toolchainDir}/usr"
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
       files = Dir["#{root}/lib/*.so"].reject { |file| file.include?("libicutestswift.so") }
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
       puts "- Copying \"#{file}\""
       FileUtils.mkdir_p(File.dirname(dst))
       FileUtils.copy_entry(file, dst, false, false, true)
     }
   end

   def test()
      ndkDir = "/usr/local/ndk"
      toolchainName = isMacOS? ? "darwin-x86_64" : "linux-x86_64"
      testFile = "#{ndkDir}/toolchains/llvm/prebuilt/#{toolchainName}"
      if !Dir.exist?(testFile)
         error "! Please create symbolic link \"#{ndkDir}\" which points to Android NDK installation."
         puts ""
         message "  Example:"
         message "  sudo ln -vsi ~/Library/Android/sdk/ndk-bundle #{ndkDir}"
         puts ""
         exit(1)
      end
      execute "cd \"#{Config.tests}/sample-executable\" && make build"
      puts()
      execute "cd \"#{Config.tests}/sample-library\" && make build"
      puts()
      execute "cd \"#{Config.tests}/sample-package\" && make build"
   end

end
