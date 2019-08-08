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

class Tool

   def initialize()
      globalArch = ENV['SA_ARCH']
      @archsToBuild = [Arch.armv7a, Arch.aarch64, Arch.x86, Arch.x64]
      if !globalArch.nil?
         @archsToBuild = [globalArch]
      end
      @version = File.read("#{Config.root}/VERSION").strip()
   end

   def isMacOS?
      (/darwin/ =~ RUBY_PLATFORM) != nil
   end

   def platform
      return isMacOS? ? "darwin" : "linux"
   end

   def verifyXcode
      fullVersion = `xcodebuild -version`.strip
      version = fullVersion.split("\n").select { |comp| comp.include?("Xcode") }.first
      status = version.include?("11")
      if !status
         print("Please use Xcode 11.", 31)
         print("Your Xcode version seems too old:", 36)
         print(fullVersion, 32)
      end
      return status
   end

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
