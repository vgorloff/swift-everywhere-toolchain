class Config

   def self.androidAPI
      return "21"
   end

   def self.verify
      puts "- Android NDK Path: \t\"#{andkPath}\""
      puts "- ICU Sources Path: \t\"#{icuSources}\""
      puts "- ICU Patches Path: \t\"#{icuPatchesDirPath}\""
      puts "- Swift Sources Path: \t\"#{swiftSources}\""
      puts "- Build root Path: \t\"#{buildRoot}\""
      puts "- Install root Path: \t\"#{installRoot}\""
   end

   def self.ndkSourcesRoot
      return getEnvVariable('SA_SOURCES_ROOT_ANDK')
   end

   def self.icuSourcesRoot
      return getEnvVariable('SA_SOURCES_ROOT_ICU')
   end

   def self.swiftSourcesRoot
      return getEnvVariable('SA_SOURCES_ROOT_SWIFT')
   end

   def self.buildRoot
      return getEnvVariable('SA_BUILD_ROOT')
   end

   def self.installRoot
      return getEnvVariable('SA_INSTALL_ROOT')
   end

   def self.icuPatchesRoot
      return getEnvVariable('SA_PATCHES_ROOT_ICU')
   end

   def self.projectsRoot
      return getEnvVariable('SA_PROJECTS_ROOT')
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
