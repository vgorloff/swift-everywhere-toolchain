require_relative "../Common/Tool.rb"

class Builder < Tool

   def checkoutIfNeeded(localPath, repoURL)
      if File.exist?(localPath)
         message "Repository #{repoURL} seems already checked out."
      else
         execute "cd #{File.dirname(localPath)} && git clone #{repoURL}"
      end
   end

end
