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
require_relative "Scripts/ADBHelper.rb"

# References:
#
# - Using Rake to Automate Tasks: https://www.stuartellis.name/articles/rake/
#

task default: %w[usage]

task :usage do
   help = <<EOM
Usage:
How to build Swift for Android. Steps:

1. Validate environment variables setup.
   Execute: "rake verify:environment"

2. Prepare Android Toolchains:
   Execute: "rake ndk:setup"

3. Prior to building Swift for Android we need to patch ICU.
   Execute: "rake icu:patch"

4. Build ICU for all platforms.
   Execute: "rake icu:build:all"
   If you decided to build only one platform, them make sure that ICU for linux
   build before any other platform (due cross compilation).

5. Build Swift.
   Execute: "rake swift:build"

6. Build Hello project using new Swift Compiler.
   Execute: "rake project:hello:build"

7. Install Android Tools for macOS. See: https://stackoverflow.com/questions/17901692/set-up-adb-on-mac-os-x

8. Connect Android device to Host. Enable USB Debugging on Android device. Verify that device is connected.
   Execute: "rake project:hello:verify"

9. Deploy and run Hello Project to Android Device.
   Execute: "rake project:hello:install"
   Execute: "rake project:hello:run"
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

namespace :icu do

   desc "Cleans ICU build."
   task :clean do
      ICUBuilder.new().clean
   end

   desc "Installs patch which will add `swift` suffix to binary. Details here: http://fixme."
   task :patch do
      ICUBuilder.new().applyPatchIfNeeded
   end

   namespace :build do

      desc "Applies patch (if needed) and builds ICU for all platforms."
      task :all => [:linux, :armv7a, :x86, :aarch64] do
         puts "Done!"
      end

      desc "Builds ICU for Linux"
      task :linux do
         ICUBuilder.new("linux").make
      end

      desc "Builds ICU for armv7a"
      task :armv7a do
         ICUBuilder.new("armv7a").make
      end

      desc "Builds ICU for x86"
      task :x86 do
         ICUBuilder.new("x86").make
      end

      desc "Builds ICU for aarch64"
      task :aarch64 do
         ICUBuilder.new("aarch64").make
      end
   end
end

namespace :ndk do

   desc "Cleans NDK build."
   task :clean do
      AndroidBuilder.new("").clean
   end

   desc "Setup Android toolchains for All platforms."
   task :setup do
      AndroidBuilder.new("armv7a").setupToolchain
      AndroidBuilder.new("x86").setupToolchain
      AndroidBuilder.new("aarch64").setupToolchain
   end
end

namespace :swift do

   desc "Builds Swift for Android"
   task :build do
      SwiftBuilder.new().make
   end

   desc "Swift: Show Build options (i.e. `swift/utils/build-script --help`)"
   task :help do
      SwiftBuilder.new().help
   end

   desc "Swift: Update sources (i.e. `swift/utils/update-checkout`)"
   task :update do
      SwiftBuilder.new().update
   end

end

namespace :foundation do

   desc "Build libFoundation"
   task :build do
      FoundationBuilder.new().make
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
   task :rebuild => [:clean, :build] do
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
      task :deploy => [:install, :run] do
      end

   end

end
