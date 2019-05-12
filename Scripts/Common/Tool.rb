
class Tool

   def execute(command)
      print(command, 32) # Green color.
      if system(command) != true
         message "Execution of command is failed:"
         error command
         puts
         help = <<EOM
If error was due Memory, CPU, or Disk peak resource usage (i.e. missed file while file exists),
then try to run previous command again. Build process will perform `configure` step again,
but most of compilation steps will be skipped.
EOM
         message help
         raise
      end
   end

   def executeCommands(commands)
      lines = commands.split("\n").map { |line| line.strip }
      lines = lines.reject { |line| line.start_with?("#") || line.empty? }
      execute lines.join(" \\\n   ")
      execute(cmd)
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
