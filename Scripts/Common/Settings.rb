require_relative "Config.rb"

class Settings

   def initialize()
      @settingsFilePath = Config.root + "/local.properties.yml"
      if File.exist?(@settingsFilePath)
         @config = YAML.load_file(@settingsFilePath)
      else
         raise "File \"#{@settingsFilePath}\" not exists."
      end
   end

   def ndkDir
      ndkDir = @config['ndk.dir']
      if ndkDir.nil?
         raise "Setting \"ndk.dir\" is missed in file \"#{@settingsFilePath}\"."
      end
      return File.expand_path(ndkDir)
   end

end
