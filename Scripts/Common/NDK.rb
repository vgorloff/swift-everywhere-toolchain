require_relative "Settings.rb"
require 'yaml'

class NDK

   def initialize()
      @settings = Settings.new()
   end

   def api
      return "24"
   end

   def gcc
      return "4.9"
   end

   def sources
      return @settings.ndkDir
   end

   def toolchain
      return "#{@settings.ndkDir}/toolchains/llvm/prebuilt/darwin-x86_64"
   end

end
