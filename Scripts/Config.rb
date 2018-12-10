class Config

   def self.ndkPath
      ndkName = "android-ndk-r18b"
      return File.realpath(File.dirname(__FILE__) + "/../Sources/#{ndkName}")
   end

   def self.androidAPI
      return "21"
   end

   def self.icuSources
      return File.realpath(File.dirname(__FILE__) + "/../Sources/icu")
   end

   def self.swiftSources
      return File.realpath(File.dirname(__FILE__) + "/../Sources/swift")
   end

   def self.buildRoot
      return File.realpath(File.dirname(__FILE__) + "/../Build")
   end

   def self.installRoot
      return File.realpath(File.dirname(__FILE__) + "/../Install")
   end

   def self.icuPatchesDir
      return File.realpath(File.dirname(__FILE__) + "/../Sources/patches/icu")
   end

   def self.projectsDirPath
      return File.realpath(File.dirname(__FILE__) + "/../Projects")
   end

end
