require_relative "../Common/Builder.rb"
require_relative "../Common/Config.rb"

class CurlBuilder < Builder

   def initialize(target = "armv7a")
      super()
      @target = target
      @sourcesDir = Config.curlSourcesRoot
      @buildDir = Config.buildRoot + "/curl/" + @target
      @installDir = Config.installRoot + "/curl/" + @target
   end

   def checkout
      checkoutIfNeeded(@sourcesDir, "https://github.com/curl/curl.git")
   end

   def prepare
      execute "mkdir -p #{@buildDir}"
      execute "mkdir -p #{@installDir}"
   end

   def configure
      # Arguments took from `swift/swift-corelibs-foundation/build-android`
      cmd = ["cd #{@sourcesDir} &&"]
      cmd << "autoreconf -i"
      execute cmd.join(" ")
   end

   def build

   end

   def make
      checkout
      prepare
      configure
      build
   end

end
