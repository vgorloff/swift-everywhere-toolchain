require_relative "Tool.rb"

class Downloader < Tool

   def initialize(downloadsDirPath, destinationDirPath, url, downloadedFileNameMask)
      @downloads = downloadsDirPath
      @destination = destinationDirPath
      @url = url
      @fileNameMask = downloadedFileNameMask
   end

   def bootstrap()
      downloadIfNeeded()
      unpackIfNeeded()
   end

   def unpack()
      if archive.end_with? ".tar.gz"
         execute "cd #{@downloads} && tar -xzf \"#{archive}\""
      elsif archive.end_with? ".zip"
         execute "cd #{@downloads} && unzip -q -o \"#{archive}\""
      else
         raise "Don't know how to unpack file \"#{archive}\"."
      end
      unpackedDir = Dir[@downloads + "/" + @fileNameMask].select { |dir| File.directory?(dir) }.first
      if !unpackedDir.nil?
         File.rename(unpackedDir, @destination)
      end
   end

   def unpackIfNeeded()
      if File.exist?(@destination)
         message "Seems URL \"#{@url}\" already downloaded and unpacked to \"#{@destination}\"."
         return
      end
      unpack()
   end

   def download()
      execute "mkdir -p \"#{@downloads}\""
      execute "cd \"#{@downloads}\" && curl -O -J -L #{@url}"
   end

   def downloadIfNeeded()
      if !archive.nil?
         message "Seems URL \"#{@url}\" already downloaded to \"#{archive}\"."
         return
      end
      download()
   end

   def archive
      if @archive.nil?
         @archive = Dir[@downloads + "/" + @fileNameMask].select { |file| !File.directory?(file) }.first
      end
      return @archive
   end

end
