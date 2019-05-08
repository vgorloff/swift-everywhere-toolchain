require_relative "Location.rb"

class Config

   def self.root
      return File.realpath(File.dirname(__FILE__) + "/../../")
   end
   
   def self.toolChain
      return "#{root}/#{Location.toolChain}"
   end
   
   def self.toolchainDir
      return "#{toolChain}/swift-android-toolchain"
   end

   def self.sources
      return "#{toolChain}/#{Location.sources}"
   end

   def self.build
      return "#{toolChain}/#{Location.build}"
   end

   def self.install
      return "#{toolChain}/#{Location.install}"
   end

   def self.patches
      return "#{root}/#{Location.patches}"
   end

   def self.projects
      return "#{root}/#{Location.projects}"
   end

end
