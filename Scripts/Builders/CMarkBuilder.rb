require_relative "../Common/Builder.rb"

class CMarkBuilder < Builder

   def initialize()
      super(Lib.cmark, Arch.host)
   end

   def executeConfigure
      # See: $SWIFT_REPO/docs/WindowsBuild.md
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja"
      cmd << "-DCMAKE_INSTALL_PREFIX=/"
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DCMARK_TESTS=false"
      cFlags = '-Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector'
      cmd << "-DCMAKE_C_FLAGS='#{cFlags}'"
      cmd << "-DCMAKE_CXX_FLAGS='#{cFlags}'"
      cmd << "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.9"
      cmd << "-DCMAKE_OSX_SYSROOT=#{macOSSDK}"
      cmd << @sources
      execute cmd.join(" ")
   end

   def executeBuild
      execute "cd #{@builds} && ninja"
   end

   def executeInstall
      execute "DESTDIR=#{@installs} cmake --build #{@builds} -- install"
   end

end
