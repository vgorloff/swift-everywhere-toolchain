require_relative "Tool.rb"

class Checkout < Tool

   def self.checkout()
      SwiftBuilder.new().checkout
      DispatchBuilder.new().checkout
      FoundationBuilder.new().checkout
      CMarkBuilder.new().checkout
      ICUBuilder.new().checkout
      LLVMBuilder.new().checkout
      ClangBuilder.new().checkout
      CompilerRTBuilder.new().checkout
      XMLBuilder.new().checkout
      CurlBuilder.new().checkout
      OpenSSLBuilder.new().checkout
   end

   def checkoutIfNeeded(localPath, repoURL, revision)
      if File.exist?(localPath)
         cmd = "cd \"#{localPath}\" && git rev-parse --verify HEAD"
         sha = `#{cmd}`.strip()
         if revision == sha
            message "Repository \"#{repoURL}\" seems already checked out to \"#{localPath}\" and have needed revision #{revision}."
         else
            checkoutRevision(localPath, revision)
            message "#{localPath} updated to revision #{revision}."
         end
      else
         execute "mkdir -p \"#{localPath}\""
         # Checking out specific SHA - https://stackoverflow.com/a/43136160/1418981
         execute "cd \"#{localPath}\" && git init && git remote add origin \"#{repoURL}\""
         checkoutRevision(localPath, revision)
         message "#{repoURL} checkout to \"#{localPath}\" is completed."
      end
   end

   # Private

   def checkoutRevision(localPath, revision)
      message "Checking out revision #{revision}"
      execute "cd \"#{localPath}\" && git config --local uploadpack.allowReachableSHA1InWant true"
      execute "cd \"#{localPath}\" && git fetch --depth 10 origin #{revision}"
      # Disable warning about detached HEAD - https://stackoverflow.com/a/45652159/1418981
      execute "cd \"#{localPath}\" && git -c advice.detachedHead=false checkout FETCH_HEAD"
   end

end
