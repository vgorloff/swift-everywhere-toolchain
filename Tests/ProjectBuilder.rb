require_relative "ADB.rb"
require_relative "Tool.rb"

class ProjectBuilder < Tool

   def libs
      return Dir["#{@builds}/lib/*"]
   end

   def copyLibs()
      targetDir = "#{@builds}/lib"
      execute "rm -rf \"#{targetDir}\""
      execute "#{@copyLibsCmd} #{targetDir}"
   end

   def deploy()
      adb = ADB.new(libs, binary)
      adb.deploy()
      adb.run()
   end

   def undeploy()
      ADB.new(libs, binary).clean
   end

end
