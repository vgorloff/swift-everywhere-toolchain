# See:
# - Colorized Ruby output: https://stackoverflow.com/a/11482430/1418981

class Tool

   def execute(command)
      puts "\e[32m#{command}\e[0m" # Print to console with Green color.
      if system(command) != true
         message "Execution of command is failed:"
         error command
         puts
         raise
      end
   end

   def message(command)
      puts "\e[36m#{command}\e[0m" # Print to console with Light blue color.
   end

   def error(command)
      puts "\e[31m#{command}\e[0m" # Print to console with Light blue color.
   end

end
