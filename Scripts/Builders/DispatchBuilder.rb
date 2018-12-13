require_relative "../Common/Builder.rb"
require_relative "../Common/Config.rb"

# See:
# - Dispatch build script: https://github.com/readdle/swift-android-toolchain/blob/master/build/Linux/040_build_corelibs_libdispatch.sh
class DispatchBuilder < Builder

   def initialize(target = "armv7a")
      super()
      @target = target
      @sourcesDir = Config.swiftSourcesRoot + "/swift-corelibs-libdispatch"
      @buildDir = Config.buildRoot + "/dispatch/" + @target
      @installDir = Config.installRoot + "/dispatch/" + @target
   end

   def prepare
      execute "mkdir -p #{@buildDir}"
      execute "mkdir -p #{@installDir}"
   end

   def configure
      # See: /swift/swift-corelibs-libdispatch/INSTALL.md
      cmd = []
      cmd << "cd #{@buildDir} &&"
      cmd << "cmake -G Ninja -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"
      cmd << "-DCMAKE_SYSTEM_NAME=Android -DCMAKE_SYSTEM_VERSION=#{Config.androidAPI} -DCMAKE_ANDROID_NDK=#{Config.ndkSourcesRoot}"
      cmd << @sourcesDir
      execute cmd.join(" ")
   end

   def build
      # ninja
   end

   def make
      prepare
      configure
      build
   end

end
