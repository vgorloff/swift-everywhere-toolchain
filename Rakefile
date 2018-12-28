#!/usr/bin/env ruby

require_relative "Scripts/Builders/ICUBuilder.rb"
require_relative "Scripts/Builders/AndroidBuilder.rb"
require_relative "Scripts/Builders/SwiftBuilder.rb"
require_relative "Scripts/Builders/FoundationBuilder.rb"
require_relative "Scripts/Builders/DispatchBuilder.rb"
require_relative "Scripts/Builders/CurlBuilder.rb"
require_relative "Scripts/Builders/OpenSSLBuilder.rb"
require_relative "Scripts/Builders/XMLBuilder.rb"
require_relative "Scripts/Builders/HelloProjectBuilder.rb"
require_relative "Scripts/Builders/LLVMBuilder.rb"
require_relative "Scripts/Builders/CMarkBuilder.rb"
require_relative "Scripts/Builders/ClangBuilder.rb"
require_relative "Scripts/Builders/CompilerRTBuilder.rb"
require_relative "Scripts/Builders/UUIDBuilder.rb"
require_relative "Scripts/Common/ADBHelper.rb"
require_relative "Scripts/Common/Tool.rb"

# References:
#
# - Using Rake to Automate Tasks: https://www.stuartellis.name/articles/rake/
#

task default: ['usage']

namespace :more do
   desc "Show more actions for ARMv7a targets (for Developers)."
   task :armv7a do
      system "rake -T | grep develop | grep armv7a"
   end
   desc "Show more actions for Host targets (for Developers)."
   task :host do
      system "rake -T | grep develop | grep host"
   end
end


desc "Checkout Sources of all Components from Git."
task :checkout do
   SwiftBuilder.new().checkout
   DispatchBuilder.new().checkout
   FoundationBuilder.new().checkout
   CMarkBuilder.new().checkout
   ICUBuilder.new().checkout
   LLVMBuilder.new().checkout
   ClangBuilder.new().checkout
   CompilerRTBuilder.new().checkout
   XMLBuilder.new().checkout
   CurlBuilder.new().checkout
   OpenSSLBuilder.new().checkout
   # UUIDBuilder.new().checkout
end

desc "Download Android NDK"
task :download do AndroidBuilder.new().download end

desc "Verify ADB shell setup."
task :verify do ADBHelper.new().verify end

namespace :armv7a do

   desc "Setup NDK Toolchain."
   task :setup do AndroidBuilder.new(Arch.armv7a).setup end

   desc "Build Swift Toolchain."
   task :build do
      tool = Tool.new()
      swift = SwiftBuilder.new(Arch.armv7a)
      ICUBuilder.new(Arch.armv7a).make
      XMLBuilder.new(Arch.armv7a).make
      # UUIDBuilder.new().make
      OpenSSLBuilder.new(Arch.armv7a).make
      CurlBuilder.new(Arch.armv7a).make
      CMarkBuilder.new(Arch.armv7a).make
      LLVMBuilder.new(Arch.armv7a).make
      swift.make
      DispatchBuilder.new(Arch.armv7a).make
      FoundationBuilder.new(Arch.armv7a).make
      puts ""
      tool.print("\"Swift Toolchain for Android\" build is completed.")
      tool.print("It can be found in \"#{swift.installs}\".")
      puts ""
   end

   namespace :project do

      desc "Builds Sample project"
      task :build do HelloProjectBuilder.new(Arch.armv7a).build end

      desc "Deploy and Run on Android"
      task deploy: ["develop:armv7a:install:project", "develop:armv7a:run:project"] do
      end

      desc "Clean Hello project."
      task :clean do ADBHelper.new().clean end
   end

end

# Pass `SA_DRY_RUN=1 rake ...` for Dry run mode.
namespace :develop do
   namespace :host do
      namespace :make do
         desc "Configure, Build and Install - Swift"
         task :swift do SwiftBuilder.new(Arch.host).make end

         desc "Configure, Build and Install - libDispatch"
         task :dispatch do DispatchBuilder.new(Arch.host).make end

         desc "Configure, Build and Install - libFoundation"
         task :foundation do FoundationBuilder.new(Arch.host).make end

         desc "Configure, Build and Install - UUID"
         task :uuid do UUIDBuilder.new(Arch.host).make end
      end
      namespace :configure do
         desc "Configure - ICU"
         task :icu do ICUBuilder.new(Arch.host).configure end
      end
      namespace :build do
         desc "Build - ICU"
         task :icu do ICUBuilder.new(Arch.host).build end
      end
      namespace :install do
         desc "Install - ICU"
         task :icu do ICUBuilder.new(Arch.host).install end

         desc "Install - libDispatch"
         task :dispatch do DispatchBuilder.new(Arch.host).install end

         desc "Install - libFoundation"
         task :foundation do FoundationBuilder.new(Arch.host).install end
      end
      namespace :clean do
         desc "Clean - libDispatch"
         task :dispatch do DispatchBuilder.new(Arch.host).clean end

         desc "Clean - libFoundation"
         task :foundation do FoundationBuilder.new(Arch.host).clean end
      end
      namespace :project do
         desc "Builds Sample project"
         task :build do HelloProjectBuilder.new(Arch.host).build end

         desc "Deploy and Run on Android"
         task :run do
            builder = HelloProjectBuilder.new(Arch.host)
            builder.execute(builder.executable)
         end
      end
   end

   namespace :armv7a do
      namespace :configure do
         desc "Configure - ICU"
         task :icu do ICUBuilder.new(Arch.armv7a).configure end

         desc "Configure - Swift"
         task :swift do SwiftBuilder.new(Arch.armv7a).configure end

         desc "Configure - LLVM"
         task :llvm do LLVMBuilder.new(Arch.armv7a).configure end

         desc "Configure - CMark"
         task :cmark do CMarkBuilder.new(Arch.armv7a).configure end

         desc "Configure - libDispatch"
         task :dispatch do DispatchBuilder.new(Arch.armv7a).configure end

         desc "Configure - libFoundation"
         task :foundation do FoundationBuilder.new(Arch.armv7a).configure end

         desc "Configure - libXML"
         task :xml do XMLBuilder.new(Arch.armv7a).configure end

         desc "Configure - OpenSSL"
         task :ssl do OpenSSLBuilder.new(Arch.armv7a).configure end

         desc "Configure - curl"
         task :curl do CurlBuilder.new(Arch.armv7a).configure end
      end

      namespace :build do
         desc "Build - ICU"
         task :icu do ICUBuilder.new(Arch.armv7a).build end

         desc "Build - Swift"
         task :swift do SwiftBuilder.new(Arch.armv7a).build end

         desc "Build - LLVM"
         task :llvm do LLVMBuilder.new(Arch.armv7a).build end

         desc "Build - CMark"
         task :cmark do CMarkBuilder.new(Arch.armv7a).build end

         desc "Build - libDispatch"
         task :dispatch do DispatchBuilder.new(Arch.armv7a).build end

         desc "Build - libFoundation"
         task :foundation do FoundationBuilder.new(Arch.armv7a).build end

         desc "Build - libXML"
         task :xml do XMLBuilder.new(Arch.armv7a).build end

         desc "Build - OpenSSL"
         task :ssl do OpenSSLBuilder.new(Arch.armv7a).build end

         desc "Build - curl"
         task :curl do CurlBuilder.new(Arch.armv7a).build end
      end

      namespace :install do

         desc "Install - ICU"
         task :icu do ICUBuilder.new(Arch.armv7a).install end

         desc "Install - Swift"
         task :swift do SwiftBuilder.new(Arch.armv7a).install end

         desc "Install - LLVM"
         task :llvm do LLVMBuilder.new(Arch.armv7a).install end

         desc "Install - CMark"
         task :cmark do CMarkBuilder.new(Arch.armv7a).install end

         desc "Install - libDispatch"
         task :dispatch do DispatchBuilder.new(Arch.armv7a).install end

         desc "Install - libFoundation"
         task :foundation do FoundationBuilder.new(Arch.armv7a).install end

         desc "Install - libXML"
         task :xml do XMLBuilder.new(Arch.armv7a).install end

         desc "Install - OpenSSL"
         task :ssl do OpenSSLBuilder.new(Arch.armv7a).install end

         desc "Install - curl"
         task :curl do CurlBuilder.new(Arch.armv7a).install end

         desc "Install - Hello project on Android"
         task :project do ADBHelper.new().deploy(HelloProjectBuilder.new(Arch.armv7a).builds) end
      end

      namespace :make do
         desc "Configure, Build and Install - ICU"
         task :icu do ICUBuilder.new(Arch.armv7a).make end

         desc "Configure, Build and Install - Swift"
         task :swift do SwiftBuilder.new(Arch.armv7a).make end

         desc "Configure, Build and Install - LLVM"
         task :llvm do LLVMBuilder.new(Arch.armv7a).make end

         desc "Configure, Build and Install - CMark"
         task :cmark do CMarkBuilder.new(Arch.armv7a).make end

         desc "Configure, Build and Install - libDispatch"
         task :dispatch do DispatchBuilder.new(Arch.armv7a).make end

         desc "Configure, Build and Install - libFoundation"
         task :foundation do FoundationBuilder.new(Arch.armv7a).make end

         desc "Configure, Build and Install - libXML"
         task :xml do XMLBuilder.new(Arch.armv7a).make end

         desc "Configure, Build and Install - curl"
         task :curl do CurlBuilder.new(Arch.armv7a).make end

         desc "Configure, Build and Install - OpenSSL"
         task :ssl do OpenSSLBuilder.new(Arch.armv7a).make end

         desc "Configure, Build and Install - UUID"
         task :uuid do UUIDBuilder.new(Arch.armv7a).make end
      end

      namespace :clean do
         desc "Clean - ICU."
         task :icu do ICUBuilder.new(Arch.armv7a).clean end

         desc "Clean - NDK."
         task :ndk do AndroidBuilder.new(Arch.armv7a).clean end

         desc "Clean - Swift."
         task :swift do SwiftBuilder.new(Arch.armv7a).clean end

         desc "Clean - LLVM."
         task :llvm do  LLVMBuilder.new(Arch.armv7a).clean end

         desc "Clean - libDispatch"
         task :dispatch do DispatchBuilder.new(Arch.armv7a).clean end

         desc "Clean - libFoundation"
         task :foundation do FoundationBuilder.new(Arch.armv7a).clean end

         desc "Clean - UUID"
         task :uuid do UUIDBuilder.new(Arch.armv7a).clean end

         desc "Clean - libXML"
         task :xml do XMLBuilder.new(Arch.armv7a).clean end

         desc "Clean - OpenSSL"
         task :ssl do OpenSSLBuilder.new(Arch.armv7a).clean end

         desc "Clean - curl"
         task :curl do CurlBuilder.new(Arch.armv7a).clean end
      end

      namespace :run do
         desc "Run - Hello project on Android"
         task :project do ADBHelper.new().run(HelloProjectBuilder.new(Arch.armv7a).executable) end
      end
   end
end

task :usage do

   tool = Tool.new()

   tool.print("\nBuilding Swift Toolchain. Steps:\n", 32)
   note = <<EOM
Note: Every time you see host$ – this means that command should be executed on HOST macOS computer.
      Every time you see box$ – this means that command should be executed on virtual GUEST Linux OS.
EOM
   tool.print(note, 33)

   tool.print("1. Get Sources and Tools.", 32)
   help = <<EOM
   box$ rake checkout
   box$ rake download

   Alternatively you can download "Android NDK" manually from "https://developer.android.com/ndk/downloads/" and put archive to Downloads folder.
EOM
   tool.print(help, 36)

   tool.print("2. Setup and Build all Swift components and Sample project for armv7a.", 32)
help = <<EOM
   box$ rake armv7a:setup
   box$ rake armv7a:build
   box$ rake armv7a:project:build
EOM
   tool.print(help, 36)

   tool.print("3. Enable USB Debugging on Android device. Install Android Tools for macOS. Connect Android device and Verify ADB shell setup.", 32)
   help = <<EOM
   host$ rake verify

   References:
   - How to Install Android Tools for macOS: https://stackoverflow.com/questions/17901692/set-up-adb-on-mac-os-x
   - How to Enable USB Debugging on Android device: https://developer.android.com/studio/debug/dev-options
EOM
   tool.print(help, 36)

   tool.print("4. Deploy and run Demo project to Android Device.", 32)
   help = <<EOM
   host$ rake armv7a:project:deploy
EOM

   tool.print(help, 36)
   system "rake -T | grep --invert-match develop"
end
