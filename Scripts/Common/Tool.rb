# See:
# - Colorized Ruby output: https://stackoverflow.com/a/11482430/1418981

class Tool

   def execute(command)
      puts "\e[32m#{command}\e[0m" # Print to console with Green color.
      system command
   end

   def message(command)
      puts "\e[36m#{command}\e[0m" # Print to console with Light blue color.
   end

end
