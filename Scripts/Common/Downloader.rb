require_relative "Tool.rb"

class Downloader < Tool

   def initialize(downloadsDirPath, destinationDirPath, url, downloadedFileNameMask)
      @downloads = downloadsDirPath
      @destination = destinationDirPath
      @url = url
      @fileName = File.basename(url)
      @archive = @downloads + "/" + @fileName
      @downloadedFileNameMask = downloadedFileNameMask
   end

   def bootstrap()
      downloadIfNeeded()
      unpackIfNeeded()
   end

   def unpack()
      message "Unpacking file #{@archive}"
      if !unpackedDir.nil?
         execute "rm -rf \"#{unpackedDir}\""
      end
      if @archive.end_with? ".tar.gz"
         execute "cd #{@downloads} && tar -xzf \"#{@archive}\""
      elsif @archive.end_with? ".zip"
         execute "cd #{@downloads} && unzip -q -o \"#{@archive}\""
      else
         raise "Don't know how to unpack file \"#{@archive}\"."
      end
      if !unpackedDir.nil?
         File.rename(unpackedDir, @destination)
         message "Archive extracted to \"#{@destination}\""
      end
   end

   def unpackIfNeeded()
      if File.exist?(@destination)
         message "Seems URL \"#{@url}\" already downloaded and unpacked to \"#{@destination}\"."
         return
      end
      unpack()
   end

   def unpackedDir
      return Dir[@downloads + "/" + @downloadedFileNameMask].select { |dir| File.directory?(dir) }.first
   end

   def download()
      execute "mkdir -p \"#{@downloads}\""
      execute "cd \"#{@downloads}\" && curl -O -J -L #{@url}"
   end

   def downloadIfNeeded()
      if File.exist?(@archive)
         message "Seems URL \"#{@url}\" already downloaded to \"#{@archive}\"."
         return
      end
      download()
   end

end
