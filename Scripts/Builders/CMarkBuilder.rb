require_relative "../Common/Builder.rb"

class CMarkBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.cmark, arch)
      @sources = SwiftBuilder.new(Arch.default).sources + "/cmark"
   end

   def configure
      # See: $SWIFT_REPO/docs/WindowsBuild.md
      cmd = []
      cmd << "cd #{@build} &&"
      cmd << "cmake -G Ninja"
      cmd << "-DCMAKE_INSTALL_PREFIX=#{@install}"
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << @sources
      execute cmd.join(" ")
      message "LLVM Configure is completed."
   end

   def compile
      execute "cd #{@build} && ninja"
      message "CMark Build is completed."
   end

   def install
      execute "cd #{@build} && ninja install"
      message "CMark Install is completed."
   end

   def make
      prepare
      configure
      compile
      install
   end

   def prepare
      execute "mkdir -p #{@build}"
   end

end
