require_relative "../Common/Builder.rb"

class LLVMBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.llvm, arch)
      @sources = SwiftBuilder.new(Arch.default).sources + "/llvm"
   end

   def configure
      # See:
      # - LLVM Getting Started: https://llvm.org/docs/GettingStarted.html#requirements
      # - CLANG Getting Started: http://clang.llvm.org/get_started.html
      cmd = []
      cmd << "cd #{@build} &&"
      cmd << "cmake -G Ninja"
      cmd << "-DCMAKE_INSTALL_PREFIX=#{@install}"
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      # See: https://stackoverflow.com/questions/40122657/build-llvm-clang4-0-for-android-armeabi
      # Line below still cause build failure.
      # cmd << "-DLLVM_TARGETS_TO_BUILD=\"ARM;AArch64\" -DLLVM_DEFAULT_TARGET_TRIPLE=\"arm-linux-androideabi\""
      cmd << @sources
      execute cmd.join(" ")
      message "LLVM Configure is completed."
   end

   def compile
      execute "cd #{@build} && ninja"
      message "LLVM Build is completed."
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
