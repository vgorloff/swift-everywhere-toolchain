require_relative "../Common/Builder.rb"

class CMarkBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.cmark, arch)
   end

   def configure
      # See: $SWIFT_REPO/docs/WindowsBuild.md
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja"
      cmd << "-DCMAKE_INSTALL_PREFIX=#{@installs}"
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << @sources
      execute cmd.join(" ")
      logConfigureCompleted
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/apple/swift-cmark.git")
   end

   def build
      execute "cd #{@builds} && ninja"
      logBuildCompleted
   end

   def install
      execute "cd #{@builds} && ninja install"
      logInstallCompleted
   end

   def make
      prepare
      configure
      build
      install
   end

   def prepare
      execute "mkdir -p #{@builds}"
   end

end
