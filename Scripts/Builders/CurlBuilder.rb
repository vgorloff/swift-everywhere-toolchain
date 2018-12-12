require_relative "../Common/Builder.rb"
require_relative "../Common/Config.rb"

class CurlBuilder < Builder

   def checkout()
      execute "cd #{Config.sourcesRoot} && git clone https://github.com/curl/curl.git"
   end

   def make()
      puts "OK"
   end

end
