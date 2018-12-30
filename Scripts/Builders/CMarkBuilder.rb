require_relative "../Common/Builder.rb"

class CMarkBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.cmark, arch)
   end

   def configure
      logConfigureStarted
      prepare
      # See: $SWIFT_REPO/docs/WindowsBuild.md
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja"
      cmd << "-DCMAKE_C_COMPILER=#{clang}"
      cmd << "-DCMAKE_CXX_COMPILER=#{clang}++"
      cmd << "-DCMAKE_INSTALL_PREFIX=#{@installs}"
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DCMARK_TESTS=false"
      if isMacOS?
         cFlags = '-Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector'
         cmd << "-DCMAKE_C_FLAGS='#{cFlags}'"
         cmd << "-DCMAKE_CXX_FLAGS='#{cFlags}'"
         cmd << "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.9"
         cmd << "-DCMAKE_OSX_SYSROOT=#{macOSSDK}"
      end
      cmd << @sources
      execute cmd.join(" ")
      logConfigureCompleted
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/apple/swift-cmark.git", "32fa49671d0fc5d1f65d2bcbabfb1511a9d65c27")
   end

   def build
      logBuildStarted
      prepare
      execute "cd #{@builds} && ninja"
      logBuildCompleted
   end

   def install
      logInstallStarted
      removeInstalls()
      execute "cd #{@builds} && ninja install"
      logInstallCompleted
   end

   def make
      configure
      build
      install
   end

   def prepare
      prepareBuilds()
   end

   def clean
      removeBuilds()
      cleanGitRepo()
   end

end
