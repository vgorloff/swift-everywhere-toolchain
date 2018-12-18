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

1. Checkout Sources.
   rake checkout:icu
   rake checkout:llvm
   rake checkout:swift
   rake checkout:ndk

   Alternatively you can download Android NDK manually form https://developer.android.com/ndk/downloads/ and put archive to Downloads folder.

2. Configure and Build Sources:
   rake armv7a:setup:ndk
   rake armv7a:build:llvm
   rake armv7a:build:icu
   rake armv7a:build:cmark

3. Build `Hello` project.
   Execute: "rake project:hello:build"

4. Install Android Tools for macOS. See: https://stackoverflow.com/questions/17901692/set-up-adb-on-mac-os-x

5. Connect Android device to Host. Enable USB Debugging on Android device. Verify that device is connected.
   Execute: "rake project:hello:verify"

6. Deploy and run Hello Project to Android Device.
   Execute: "rake project:hello:install"
   Execute: "rake project:hello:run"

7. Repeat steps 2...6 for other architectures.
\n
EOM
   puts help
   system "rake -T"
end

namespace :verify do
   desc "Verify environment variables"
   task :environment do
      Config.verify
   end
end

namespace :checkout do

   desc "Checkout Swift, CMark"
   task :swift do
      CMarkBuilder.new().checkout
      SwiftBuilder.new().checkout
   end

   desc "Checkout ICU"
   task :icu do
      ICUBuilder.new().checkout
   end

   desc "Checkout LLVM, Clang, Compiler-RT"
   task :llvm do
      LLVMBuilder.new().checkout
      ClangBuilder.new().checkout
      CompilerRTBuilder.new().checkout
   end

   desc "Download Android NDK"
   task :ndk do
      AndroidBuilder.new().download
   end

end

namespace :armv7a do

   namespace :setup do
      desc "Setup NDK Toolchain."
      task :ndk do
         AndroidBuilder.new(Arch.armv7a).setup
      end
   end

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

   namespace :compile do
      desc "Build ICU"
      task :icu do
         ICUBuilder.new(Arch.armv7a).compile
      end
      desc "Build Swift"
      task :swift do
         SwiftBuilder.new(Arch.armv7a).compile
      end
      desc "Build LLVM"
      task :llvm do
         LLVMBuilder.new(Arch.armv7a).compile
      end
      desc "Build CMark"
      task :cmark do
         CMarkBuilder.new(Arch.armv7a).compile
      end
   end

   namespace :build do
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

      desc "LLVM Swift."
      task :llvm do
         LLVMBuilder.new(Arch.armv7a).clean
      end
   end

end

namespace :update do

   desc "Updated Git repositories: `swift/utils/update-checkout`"
   task :swift do
      SwiftBuilder.new().update
   end

end

namespace :help do

   desc "Show Build options: `swift/utils/build-script --help`"
   task :swift do
      SwiftBuilder.new().help
   end

end

namespace :foundation do

   desc "Build libFoundation"
   task :build do
      FoundationBuilder.new().make
   end

   desc "Clean libFoundation"
   task :clean do
      FoundationBuilder.new().clean
   end

end

namespace :dispatch do

   desc "Build libDispatch"
   task :build do
      DispatchBuilder.new().make
   end

   desc "Clean libDispatch"
   task :clean do
      DispatchBuilder.new().clean
   end

   desc "Rebuild libDispatch"
   task rebuild: [:clean, :build] do
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

namespace :project do

   namespace :hello do

      desc "Project Hello: Build"
      task :build do
         HelloProjectBuilder.new().make
      end

      desc "Project Hello: Verify"
      task :verify do
         ADBHelper.new().verify
      end

      desc "Project Hello: Install on Android"
      task :install do
         binary = "#{Config.buildRoot}/hello/hello"
         helper = ADBHelper.new()
         helper.deployLibs
         helper.deployProducts([binary])
      end

      desc "Project Hello: Run on Android"
      task :run do
         ADBHelper.new().run("hello")
      end

      desc "Project Hello: Cleanup on Android"
      task :cleanup do
         ADBHelper.new().cleanup("hello")
      end

      desc "Project Hello: Deploy and Run on Android"
      task deploy: [:install, :run] do
      end

   end

end
