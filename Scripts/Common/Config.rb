class Config

   def self.androidAPI
      return "21"
   end

   def self.rootDirPath
      return File.realpath(File.dirname(__FILE__) + "/../../")
   end

   def self.verify
      puts "- Project Root Path: \t\"#{rootDirPath}\""
      puts "- Android NDK Path: \t\"#{ndkSourcesRoot}\""
      puts "- ICU Sources Path: \t\"#{icuSourcesRoot}\""
      puts "- ICU Patches Path: \t\"#{icuPatchesRoot}\""
      puts "- Swift Sources Path: \t\"#{swiftSourcesRoot}\""
      puts "- Build root Path: \t\"#{buildRoot}\""
      puts "- Install root Path: \t\"#{installRoot}\""
   end

   def self.ndkSourcesRoot
      return "#{sourcesRoot}/android-ndk-r18b"
   end

   def self.icuSourcesRoot
      return "#{sourcesRoot}/icu"
   end

   def self.swiftSourcesRoot
      return "#{sourcesRoot}/swift"
   end

   def self.curlSourcesRoot
      return "#{sourcesRoot}/curl"
   end

   def self.sourcesRoot
      return "#{rootDirPath}/Sources"
   end

   def self.buildRoot
      return "#{rootDirPath}/Build"
   end

   def self.swiftBuildRoot
      return "#{buildRoot}/swift-android"
   end

   def self.installRoot
      return "#{rootDirPath}/Install"
   end

   def self.ndkInstallRoot
      return "#{installRoot}/android"
   end

   def self.icuInstallRoot
      return "#{installRoot}/icu"
   end

   def self.icuPatchesRoot
      return "#{rootDirPath}/Patches/icu"
   end

   def self.projectsRoot
      return "#{rootDirPath}/Projects"
   end

   def self.getEnvVariable(name)
      result = ENV[name]
      if result.nil?
         puts "Environment variable \"#{name}\" is not found. Did you completed Vagrant setup?"
         puts "Check \"config.vm.provision\" setting in Vagrantfile..."
         abort
      end
      return result
   end

end
