require_relative "Tool.rb"

class ADBHelper < Tool

   def initialize()
      super()
      @destinationDirPath = "/data/local/tmp/hello"
   end

   def verify()
      # See: Enable adb debugging on your device – https://developer.android.com/studio/command-line/adb#Enabling
      # On linux `execute "sudo apt-get install android-tools-adb"`
      execute "adb devices" # To run daemon.
      message "Make sure you are enabled \"USB debugging\" on Android device (See :https://developer.android.com/studio/command-line/adb#Enabling)"
      execute "adb devices" # To list devices.
   end

   def deploy(folder)
      message "Deploy of Shared Objects started."
      execute "adb shell rm -rf #{@destinationDirPath}"
      execute "adb shell mkdir -p #{@destinationDirPath}"
      Dir["#{folder}/*"].each { |lib|
         execute "adb push #{lib} #{@destinationDirPath}"
      }
      message "Deploy of Shared Objects completed."
   end

   def run(binary)
      execute "adb shell ls -l #{@destinationDirPath}"
      fullPath = "#{@destinationDirPath}/#{binary}"
      message "Starting execution of \"#{fullPath}\"..."
      execute "adb shell LD_LIBRARY_PATH=#{@destinationDirPath} #{fullPath}"
      message "Execution of \"#{fullPath}\" completed."
   end

   def clean
      execute "adb shell rm -rf #{@destinationDirPath}"
   end

end
