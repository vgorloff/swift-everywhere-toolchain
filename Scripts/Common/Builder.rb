require_relative "Tool.rb"
require_relative "Lib.rb"
require_relative "Arch.rb"
require_relative "Config.rb"
require_relative "Location.rb"
require_relative "Downloader.rb"

class Builder < Tool

   def initialize(component, arch)
      @component = component
      @arch = arch
      @sources = "#{Config.sources}/#{component}"
      @patches = "#{Config.patches}/#{component}"
      @build = "#{Config.build}/#{component}/#{arch}"
      @install = "#{Config.install}/#{component}/#{arch}"
   end

   def checkoutIfNeeded(localPath, repoURL)
      if File.exist?(localPath)
         message "Repository #{repoURL} seems already checked out."
      else
         execute "cd #{File.dirname(localPath)} && git clone --depth=100 #{repoURL}"
      end
   end

end
