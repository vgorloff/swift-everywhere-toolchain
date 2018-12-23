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
require_relative "Scripts/ADBHelper.rb"

# References:
#
# - Using Rake to Automate Tasks: https://www.stuartellis.name/articles/rake/
#

task default: ['usage']

task :usage do
   help = <<EOM

Building Swift Toolchain. Steps:

1. Get Sources and Tools.
   host$ rake checkout
   host$ rake download

   Alternatively you can download Android NDK manually form https://developer.android.com/ndk/downloads/ and put archive to Downloads folder.

2. Build all Swift components for armv7a:
   box$ rake armv7a:build

3. Install Android Tools for macOS. See: https://stackoverflow.com/questions/17901692/set-up-adb-on-mac-os-x

4. Connect Android device to Host. Enable USB Debugging on Android device. Verify that device is connected.
   host$ rake verify

5. Build, Deploy and run `Hello` Project to Android Device.
   box$ rake hello:build
   host$ rake hello:deploy

EOM
   puts help
   system "rake -T | grep --invert-match develop"
end

desc "Verify ADB shell setup."
task :verify do
   ADBHelper.new().verify
end

desc "Show more actions (for Developers)."
task :more do
   system "rake -T | grep develop"
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
end

desc "Download Android NDK"
task :download do
   AndroidBuilder.new().download
end

namespace :armv7a do

   desc "Setup NDK Toolchain."
   task :setup do
      AndroidBuilder.new(Arch.armv7a).setup
   end

   desc "Build Swift Toolchain."
   task build: [":develop:install:hello", ":develop:run:helo"] do
   end

end

namespace :hello do

   desc "Builds sample project"
   task :build do
      HelloProjectBuilder.new().build
   end

   desc "Deploy and Run on Android"
   task deploy: [":develop:make:icu", ":develop:make:swift"] do
   end
end

namespace :develop do

   namespace :configure do
      desc "Configure ICU"
      task :icu do
         ICUBuilder.new(Arch.armv7a).configure
      end
      desc "Configure Swift"
      task :swift do
         SwiftBuilder.new(Arch.armv7a).configure
      end
      desc "Configure LLVM"
      task :llvm do
         LLVMBuilder.new(Arch.armv7a).configure
      end
      desc "Configure CMark"
      task :cmark do
         CMarkBuilder.new(Arch.armv7a).configure
      end
   end

   namespace :build do
      desc "Build ICU"
      task :icu do
         ICUBuilder.new(Arch.armv7a).build
      end
      desc "Build Swift"
      task :swift do
         SwiftBuilder.new(Arch.armv7a).build
      end
      desc "Build LLVM"
      task :llvm do
         LLVMBuilder.new(Arch.armv7a).build
      end
      desc "Build CMark"
      task :cmark do
         CMarkBuilder.new(Arch.armv7a).build
      end
   end

   namespace :install do
      desc "Install ICU"
      task :icu do
         ICUBuilder.new(Arch.armv7a).install
      end
      desc "Install Swift"
      task :swift do
         SwiftBuilder.new(Arch.armv7a).install
      end
      desc "Install LLVM"
      task :llvm do
         LLVMBuilder.new(Arch.armv7a).install
      end
      desc "Install CMark"
      task :cmark do
         CMarkBuilder.new(Arch.armv7a).install
      end

      desc "Install Hello project on Android"
      task :hello do
         binary = HelloProjectBuilder.new().executable
         helper = ADBHelper.new()
         helper.deployLibs
         helper.deployProducts([binary])
      end
   end

   namespace :make do
      desc "Configure, Build and Install ICU"
      task :icu do
         ICUBuilder.new(Arch.armv7a).make
      end
      desc "Configure, Build and Install Swift"
      task :swift do
         SwiftBuilder.new(Arch.armv7a).make
      end
      desc "Configure, Build and Install LLVM"
      task :llvm do
         LLVMBuilder.new(Arch.armv7a).make
      end
      desc "Configure, Build and Install CMark"
      task :cmark do
         CMarkBuilder.new(Arch.armv7a).make
      end
      desc "Configure, Build and Install libDispatch"
      task :dispatch do
         DispatchBuilder.new().make
      end
      desc "Configure, Build and Install  libFoundation"
      task :foundation do
         FoundationBuilder.new().make
      end
   end

   namespace :clean do
      desc "Clean ICU."
      task :icu do
         ICUBuilder.new(Arch.armv7a).clean
      end

      desc "Clean NDK."
      task :ndk do
         AndroidBuilder.new(Arch.armv7a).clean
      end

      desc "Clean Swift."
      task :swift do
         SwiftBuilder.new(Arch.armv7a).clean
      end

      desc "Clean LLVM."
      task :llvm do
         LLVMBuilder.new(Arch.armv7a).clean
      end

      desc "Clean libDispatch"
      task :dispatch do
         DispatchBuilder.new().clean
      end

      desc "Clean libFoundation"
      task :foundation do
         FoundationBuilder.new().clean
      end

      desc "Clean Hello project."
      task :hello do
         ADBHelper.new().cleanup(HelloProjectBuilder.new().executableName)
      end
   end

   namespace :run do
      desc "Run Hello project on Android"
      task :helo do
         ADBHelper.new().run(HelloProjectBuilder.new().executableName)
      end
   end

   namespace :xml do

      desc "Checkout libXML"
      task :checkout do
         XMLBuilder.new().checkout
      end

      desc "Build libXML"
      task :make do
         XMLBuilder.new().make
      end

   end

   namespace :curl do

      desc "Checkout curl"
      task :checkout do
         CurlBuilder.new().checkout
      end

      desc "Build curl"
      task :make do
         CurlBuilder.new().make
      end

   end

   namespace :openssl do

      desc "Checkout OpenSSL"
      task :checkout do
         OpenSSLBuilder.new().checkout
      end

      desc "Make OpenSSL"
      task :make do
         OpenSSLBuilder.new().make
      end
   end
end
