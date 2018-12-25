require_relative "Tool.rb"

# See also:
# - Enable adb debugging on your device – https://developer.android.com/studio/command-line/adb#Enabling

class ADBHelper < Tool

   def initialize()
      super()
      @destinationDirPath = "/data/local/tmp/hello"
      @swift = SwiftBuilder.new()
      @ndk = AndroidBuilder.new()
      @icu = ICUBuilder.new()
      @curl = CurlBuilder.new()
      @ssl = OpenSSLBuilder.new()
      @xml = XMLBuilder.new()
   end

   def verify()
      # On linux `execute "sudo apt-get install android-tools-adb"`
      execute "adb devices" # To run daemon.
      message "Make sure you are enabled \"USB debugging\" on Android device (See :https://developer.android.com/studio/command-line/adb#Enabling)"
      execute "adb devices" # To list devices.
   end

   def deployLibs()
      execute "adb shell rm -rf #{@destinationDirPath}"
      execute "adb shell mkdir -p #{@destinationDirPath}"
      Dir["#{@swift.installs}/usr/lib/swift/android" + "/*.so"].each { |lib|
         execute "adb push #{lib} #{@destinationDirPath}"
      }
      Dir[@icu.lib + "/*.so*"].select { |lib| !File.symlink?(lib) }.each { |lib|
         destName = File.basename(lib)
         destName = destName.sub("63.1", "63") # Fix for error: CANNOT LINK EXECUTABLE ... library "libicudataswift.so.63" not found
         execute "adb push #{lib} #{@destinationDirPath}/#{destName}"
      }
      Dir[@curl.lib + "/*.so"].each { |lib|
         execute "adb push #{lib} #{@destinationDirPath}"
      }
      Dir[@xml.lib + "/*.so"].each { |lib|
         execute "adb push #{lib} #{@destinationDirPath}"
      }
      Dir[@ssl.lib + "/*.so*"].select { |lib| !File.symlink?(lib) }.each { |lib|
         execute "adb push #{lib} #{@destinationDirPath}"
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
      execute "adb shell ls -l #{@destinationDirPath}"
      execute "adb shell LD_LIBRARY_PATH=#{@destinationDirPath} #{@destinationDirPath}/#{binary}"
   end

   def clean
      execute "adb shell rm -rf #{@destinationDirPath}"
   end

end
