require_relative "Settings.rb"
require 'yaml'

class NDK

   def initialize()
      @settings = Settings.new()
   end

   def api
      return "21"
   end

   def gcc
      return "4.9"
   end

   def sources
      return @settings.ndkDir
   end

   def toolchain
      prefix = "#{@settings.ndkDir}/toolchains/llvm/prebuilt"
      return "#{prefix}/darwin-x86_64"
   end

end
