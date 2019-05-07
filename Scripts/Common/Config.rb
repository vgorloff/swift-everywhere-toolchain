require_relative "Location.rb"

class Config

   def self.root
      return File.realpath(File.dirname(__FILE__) + "/../../")
   end
   
   def self.toolchainDir
      return "#{install}/swift-android-toolchain"
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

   def self.projects
      return "#{root}/#{Location.projects}"
   end

end
