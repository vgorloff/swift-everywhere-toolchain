require_relative "../Common/Builder.rb"

class CMarkBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.cmark, arch)
   end

   def executeConfigure
      # See: $SWIFT_REPO/docs/WindowsBuild.md
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja"
      cmd << "-DCMAKE_C_COMPILER=#{llvmToolchain}/bin/clang"
      cmd << "-DCMAKE_CXX_COMPILER=#{llvmToolchain}/bin/clang++"
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
   end

   def executeBuild
      execute "cd #{@builds} && ninja"
   end

   def executeInstall
      execute "cd #{@builds} && ninja install"
   end

end
