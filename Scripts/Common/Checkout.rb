#
# The MIT License
#
# Copyright (c) 2019 Volodymyr Gorlov (https://github.com/vgorloff)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

require_relative "Tool.rb"

class Checkout < Tool

   def checkout()
      checkoutIfNeeded("#{Config.sources}/#{Lib.swift}", "https://github.com/apple/swift.git", Revision.swift)
      checkoutIfNeeded("#{Config.sources}/#{Lib.llvm}", "https://github.com/apple/swift-llvm.git", Revision.llvm)
      checkoutIfNeeded("#{Config.sources}/#{Lib.clang}", "https://github.com/apple/swift-clang.git", Revision.clang)
      checkoutIfNeeded("#{Config.sources}/#{Lib.crt}", "https://github.com/apple/swift-compiler-rt.git", Revision.crt)
      checkoutIfNeeded("#{Config.sources}/#{Lib.foundation}", "https://github.com/apple/swift-corelibs-foundation", Revision.foundation)
      checkoutIfNeeded("#{Config.sources}/#{Lib.dispatch}", "https://github.com/apple/swift-corelibs-libdispatch.git", Revision.dispatch)
      checkoutIfNeeded("#{Config.sources}/#{Lib.cmark}", "https://github.com/apple/swift-cmark.git", Revision.cmark)
      checkoutIfNeeded("#{Config.sources}/#{Lib.icu}", "https://github.com/unicode-org/icu.git", Revision.icu)
      checkoutIfNeeded("#{Config.sources}/#{Lib.ssl}", "https://github.com/openssl/openssl.git", Revision.ssl)
      checkoutIfNeeded("#{Config.sources}/#{Lib.curl}", "https://github.com/curl/curl.git", Revision.curl)
      checkoutIfNeeded("#{Config.sources}/#{Lib.xml}", "https://github.com/GNOME/libxml2.git", Revision.xml)
   end

   # Private

   def checkoutIfNeeded(localPath, repoURL, revision)
      if File.exist?(localPath)
         cmd = "cd \"#{localPath}\" && git rev-parse --verify HEAD"
         sha = `#{cmd}`.strip()
         if revision == sha
            message "Repository \"#{repoURL}\" already checked out to \"#{localPath}\"."
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

   def checkoutRevision(localPath, revision)
      message "Checking out revision #{revision}"
      execute "cd \"#{localPath}\" && git fetch origin"
      # Disable warning about detached HEAD - https://stackoverflow.com/a/45652159/1418981
      execute "cd \"#{localPath}\" && git -c advice.detachedHead=false checkout #{revision}"
      branchName = "sha-" + revision[0..16]
      execute "cd \"#{localPath}\" && git branch -f #{branchName}"
      execute "cd \"#{localPath}\" && git checkout #{branchName}"
   end

end
