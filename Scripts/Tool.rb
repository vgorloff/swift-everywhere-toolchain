class Tool

   def execute(command)
      puts "\e[32m#{command}\e[0m" # Green color. See: https://stackoverflow.com/a/11482430/1418981
      system command
   end

   def message(command)
      puts "\e[36m#{command}\e[0m" # Light blue color.
   end

end
