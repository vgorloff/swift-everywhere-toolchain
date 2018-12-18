require_relative "../Common/Builder.rb"

# See:
# - build llvm clang4.0 for android armeabi - https://stackoverflow.com/questions/40122657/build-llvm-clang4-0-for-android-armeabi
# - LLVM Getting Started: https://llvm.org/docs/GettingStarted.html#requirements
# - CLANG Getting Started: http://clang.llvm.org/get_started.html

class LLVMBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.llvm, arch)
      @sources = SwiftBuilder.new(Arch.default).sources + "/llvm"
   end

   def configure
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
      message "LLVM Compile is completed."
   end

   def install
      execute "cd #{@build} && ninja install"
      message "LLVM Install is completed."
   end

   def make
      prepare
      configure
      compile
      install
   end

   def checkout
      puts "Implement LLVM Download"
   end

   def prepare()
      execute "mkdir -p #{@build}"
   end

end
