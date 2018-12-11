#!/usr/bin/env ruby

require_relative "Scripts/Builders/ICUBuilder.rb"
require_relative "Scripts/Builders/AndroidBuilder.rb"
require_relative "Scripts/Builders/SwiftBuilder.rb"
require_relative "Scripts/HelloProjectBuilder.rb"
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
   If you decided to build only one platform, them make sure that ICU for linux build before any other platform (due cross compilation).
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

namespace :project do

   desc "Project Hello: Build"
   task :project_hello_build do
      HelloProjectBuilder.new().make
   end

   desc "Project Hello: Setup"
   task :project_hello_setup do
      ADBHelper.new().installDependencies
   end

   desc "Project Hello: Install on Android"
   task :project_hello_install do
      binary = "#{Config.buildRoot}/projects/hello/hello"
      helper = ADBHelper.new()
      helper.deployLibs
      helper.deployProducts([binary])
   end

   desc "Project Hello: Run on Android"
   task :project_hello_run do
      ADBHelper.new().run("hello")
   end

   desc "Project Hello: Cleanup on Android"
   task :project_hello_cleanup do
      ADBHelper.new().cleanup("hello")
   end

   desc "Project Hello: Build and Run on Android"
   task :project_hello_execute => [:project_hello_build, :project_hello_install, :project_hello_run] do

   end

end
