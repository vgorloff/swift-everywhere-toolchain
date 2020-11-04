require_relative "Tool.rb"

class ADB < Tool

   def initialize(libs, executable)
      super()
      component = File.basename(executable)
      @executable = executable
      @libs = libs
      @destinationDirPath = "/data/local/tmp/project-#{component}"
      @binary = "#{@destinationDirPath}/#{component}"
   end

   def self.verify()
      # See: Enable adb debugging on your device – https://developer.android.com/studio/command-line/adb#Enabling
      # On linux `execute "sudo apt-get install android-tools-adb"`
      tool = Tool.new()
      tool.execute "adb devices" # To run daemon.
      tool.message "Make sure you are enabled \"USB debugging\" on Android device (See :https://developer.android.com/studio/command-line/adb#Enabling)"
      tool.execute "adb devices" # To list devices.
   end

   def deploy
      clean()
      message "Deploy of Shared Objects started."
      execute "adb shell mkdir -p #{@destinationDirPath}"
      @libs.each { |lib|
         execute "adb push #{lib} #{@destinationDirPath}"
      }
      execute "adb push #{@executable} #{@destinationDirPath}"
      message "Deploy of Shared Objects completed."
   end

   def run
      execute "adb shell ls -l #{@destinationDirPath}"
      message "Starting execution of \"#{@binary}\"..."
      execute "adb shell LD_LIBRARY_PATH=#{@destinationDirPath} #{@binary}"
      message "Execution of \"#{@binary}\" completed."
   end

   def clean
      execute "adb shell rm -rf #{@destinationDirPath}"
   end

end
