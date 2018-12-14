require_relative "Location.rb"

class Config

   def self.sources(component)
      return sourcesRoot + "/" + component
   end

   def self.verify
      puts "- Project Root Path: \t\"#{root}\""
      puts "- Android NDK Path: \t\"#{ndkSourcesRoot}\""
      puts "- ICU Sources Path: \t\"#{icuSourcesRoot}\""
      puts "- ICU Patches Path: \t\"#{icuPatchesRoot}\""
      puts "- Swift Sources Path: \t\"#{swiftSourcesRoot}\""
      puts "- Build root Path: \t\"#{buildRoot}\""
      puts "- Install root Path: \t\"#{installRoot}\""
   end

   def self.androidAPI
      return "21"
   end

   def self.root
      return File.realpath(File.dirname(__FILE__) + "/../../")
   end

   # Sources

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

   def self.opensslSourcesRoot
      return "#{sourcesRoot}/openssl"
   end

   def self.xmlSourcesRoot
      return "#{sourcesRoot}/xml"
   end

   def self.sourcesRoot
      return "#{root}/Sources"
   end

   # Builds

   def self.buildRoot
      return "#{root}/Build"
   end

   def self.swiftBuildRoot
      return "#{buildRoot}/swift"
   end

   # Install

   def self.installRoot
      return "#{root}/Install"
   end

   def self.ndkInstallRoot
      return "#{installRoot}/android"
   end

   def self.dispatchInstallRoot
      return "#{installRoot}/dispatch"
   end

   def self.icuInstallRoot
      return "#{installRoot}/icu"
   end

   def self.curlInstallRoot
      return "#{installRoot}/curl"
   end

   def self.xmlInstallRoot
      return "#{installRoot}/xml"
   end

   # Misc

   def self.icuPatchesRoot
      return "#{root}/Patches/icu"
   end

   def self.projectsRoot
      return "#{root}/Projects"
   end

   def self.sources
      return "#{root}/#{Location.sources}"
   end

   def self.downloads
      return "#{root}/#{Location.downloads}"
   end

   def self.build
      return "#{root}/#{Location.build}"
   end

   def self.install
      return "#{root}/#{Location.install}"
   end

   def self.patches
      return "#{root}/#{Location.patches}"
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
