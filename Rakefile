#!/usr/bin/env ruby

require_relative "Automation.rb"

automation = Automation.new()

task default: ['usage']

desc "Verify ADB shell setup."
task :verify do ADB.verify() end

task :usage do automation.usage() end

namespace :armv7a do

   namespace :project do

      helloExe = HelloExeBuilder.new(Arch.armv7a)
      helloLib = HelloLibBuilder.new(Arch.armv7a)

      desc "Builds Hello-Exe project"
      task :buildExe do helloExe.build end

      desc "Builds Hello-Lib project"
      task :buildLib do helloLib.build end

      desc "Deploy and Run Hello-Exe project on Android"
      task :deployExe do
         helloExe.copyLibs()
         adb = ADB.new(helloExe.libs, helloExe.binary)
         adb.deploy()
         adb.run()
      end

      desc "Deploy and Run Hello-Lib project on Android"
      task :deployLib do
         helloLib.copyLibs()
         adb = ADB.new(helloLib.libs, helloLib.binary)
         adb.deploy()
         adb.run()
      end

      desc "Clean Hello-Exe project."
      task :cleanExe do ADB.new(helloExe.libs, helloExe.binary).clean end

      desc "Clean Hello-Lib project."
      task :cleanLib do ADB.new(helloLib.libs, helloLib.binary).clean end
   end

end
