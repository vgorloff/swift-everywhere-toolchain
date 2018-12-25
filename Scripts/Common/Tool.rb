# See:
# -

class Tool

   def execute(command)
      print(command, 32) # Green color.
      if system(command) != true
         message "Execution of command is failed:"
         error command
         puts
         raise
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
