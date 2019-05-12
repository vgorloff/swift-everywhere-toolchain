class Troubleshooter
   
   def initialize(sourceRoot)
      currentDir = File.expand_path(File.dirname(__FILE__))
      @sources = File.expand_path("#{currentDir}/../ToolChain/Sources")
      @builds = File.expand_path("#{currentDir}/../ToolChain/Build")
      @ndk = File.expand_path("~/Library/Android/sdk/ndk-bundle")
      @build = "#{currentDir}/Build"
   end
   
   def build()
      clean()
      execute "mkdir -p \"#{@build}\""
      lines = @cmd.split("\n").map { |line| line.strip }
      lines = lines.reject { |line| line.start_with?("#") || line.empty? }
      execute lines.join(" \\\n   ")
      message "Build is Done!"
      Dir["#{@build}/*"].each { |file|
         execute "file #{file}"
      }
   end
   
   def clean()
      execute "rm -rf \"#{@build}\""
   end
   
   def execute(command)
      print(command, 32) # Green color.
      if system(command) != true
         raise "Execution is failed."
      end
   end

   def print(message, color = 32)
      # See: Colorized Ruby output – https://stackoverflow.com/a/11482430/1418981
      puts "\e[#{color}m#{message}\e[0m"
   end

   def message(command)
      print(command, 36) # Light blue color.
   end

   def error(command)
      print(command, 31) # Red color.
   end

end