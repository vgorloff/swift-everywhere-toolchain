require_relative "Common/Tool.rb"

# See also:
# - Enable adb debugging on your device – https://developer.android.com/studio/command-line/adb#Enabling

class ADBHelper < Tool

   def initialize()
      super()
      @destinationDirPath = "/data/local/tmp"
      @swift = SwiftBuilder.new()
      @ndk = AndroidBuilder.new()
      @icu = ICUBuilder.new()
   end

   def verify()
      # On linux `execute "sudo apt-get install android-tools-adb"`
      execute "adb devices" # To run daemon.
      message "Make sure you are enabled \"USB debugging\" on Android device (See :https://developer.android.com/studio/command-line/adb#Enabling)"
      execute "adb devices" # To list devices.
   end

   def deployLibs()
      Dir["#{@swift.installs}/usr/lib/swift/android" + "/*.so"].each { |lib|
         cmd = "adb push #{lib} #{@destinationDirPath}"
         execute cmd
      }
      Dir[@icu.lib + "/*.so*"].select { |lib| !File.symlink?(lib) }.each { |lib|
         destName = File.basename(lib)
         destName = destName.sub("63.1", "63") # Fix for error: CANNOT LINK EXECUTABLE ... library "libicudataswift.so.63" not found
         cmd = "adb push #{lib} #{@destinationDirPath}/#{destName}"
         execute cmd
      }
      cxxLibPath = "#{@ndk.sources}/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a/libc++_shared.so"
      execute "adb push #{cxxLibPath} #{@destinationDirPath}"
   end

   def deployProducts(products)
      products.each { |file|
         cmd = "adb push #{file} #{@destinationDirPath}"
         execute cmd
      }
   end

   def run(binary)
      execute "adb shell ls -l /data/local/tmp"
      execute "adb shell LD_LIBRARY_PATH=#{@destinationDirPath} #{@destinationDirPath}/#{binary}"
   end

   def cleanup(binary)
      execute "adb shell rm #{@destinationDirPath}/#{binary}"
      execute "adb shell rm #{@destinationDirPath}/lib*swift*"
      execute "adb shell rm #{@destinationDirPath}/libc++_shared.so"
      execute "adb shell ls -l /data/local/tmp"
   end

end
