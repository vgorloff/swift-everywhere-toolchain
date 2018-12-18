require_relative "Tool.rb"
require_relative "Lib.rb"
require_relative "Arch.rb"
require_relative "Config.rb"
require_relative "Location.rb"
require_relative "Downloader.rb"

class Builder < Tool

   attr_reader :builds, :installs, :sources

   def initialize(component, arch)
      @component = component
      @arch = arch
      @sources = "#{Config.sources}/#{component}"
      @patches = "#{Config.patches}/#{component}"
      @builds = "#{Config.build}/#{component}/#{arch}"
      @installs = "#{Config.install}/#{component}/#{arch}"
   end

   def lib
      return @installs + "/lib"
   end

   def bin
      return @installs + "/bin"
   end

   def include
      return @installs + "/include"
   end

   def usr
      return @installs + "/usr"
   end

   def logBuildCompleted
      message "\"#{@component}\" build is completed."
   end

   def logConfigureCompleted
      message "\"#{@component}\" configuring is completed."
   end

   def logInstallCompleted
      message "\"#{@component}\" install is completed."
   end

   def checkoutIfNeeded(localPath, repoURL)
      if File.exist?(localPath)
         message "Repository \"#{repoURL}\" seems already checked out to \"#{localPath}\"."
      else
         dir = File.dirname(localPath)
         execute "mkdir -p \"#{dir}\""
         execute "cd \"#{dir}\" && git clone --depth=10 #{repoURL}"
         message "#{repoURL} checkout to \"#{localPath}\" is completed."
      end
   end

end
