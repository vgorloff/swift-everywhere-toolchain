#!/usr/bin/env ruby

require_relative "Scripts/ICUBuilder.rb"
require_relative "Scripts/AndroidBuilder.rb"
require_relative "Scripts/SwiftBuilder.rb"
require_relative "Scripts/HelloProjectBuilder.rb"
require_relative "Scripts/ADBHelper.rb"

=begin

Building on Ubuntu for Android.
------------------------------

1. Download sources. In this example v63.1 is used.
- http://site.icu-project.org/download

2. Extract binaries to folder "./icu"


See also:
--------

- Using Rake to Automate Tasks: https://www.stuartellis.name/articles/rake/

=end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

desc "Setup Android toolchains"
task :setupAndroidToolchains do
   AndroidBuilder.new("armv7a").makeToolchain
   AndroidBuilder.new("x86").makeToolchain
   AndroidBuilder.new("aarch64").makeToolchain
end

desc "Cleans ICU build"
task :clean_icu do
   ICUBuilder.new("").clean
end

desc "Cleans Android build"
task :clean_android do
   AndroidBuilder.new("").clean
end

desc "Builds ICU for Linux"
task :icu_build_linux do
   ICUBuilder.new("linux").make
end

desc "Builds ICU for armv7a"
task :icu_build_armv7a do
   ICUBuilder.new("armv7a").make
end

desc "Builds ICU for x86"
task :icu_build_x86 do
   ICUBuilder.new("x86").make
end

desc "Builds ICU for aarch64"
task :icu_build_aarch64 do
   ICUBuilder.new("aarch64").make
end

desc "Builds ICU All"
task :icu_build_all => [:icu_build_armv7a, :icu_build_x86, :icu_build_aarch64] do
end

desc "Builds Swift for Android"
task :swift_build_android do
   SwiftBuilder.new().make
end

desc "Swift: Show Build options"
task :swift_help do
   SwiftBuilder.new().help
end

desc "Swift: Update"
task :swift_update do
   SwiftBuilder.new().update
end

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
