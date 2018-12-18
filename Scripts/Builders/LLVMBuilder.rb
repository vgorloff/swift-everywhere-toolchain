require_relative "../Common/Builder.rb"

class LLVMBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.llvm, arch)
      @clang = ClangBuilder.new()
      @crt = CompilerRTBuilder.new()
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
      cmd << "-DLLVM_TARGETS_TO_BUILD=\"ARM;AArch64;X86\""
      # cmd << "-DLLVM_DEFAULT_TARGET_TRIPLE=\"arm-linux-androideabi\""
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
      checkoutIfNeeded(@sources, "https://git.llvm.org/git/llvm.git")
   end

   def prepare()
      execute "mkdir -p #{@build}"
      # Making needed SymLinks. See: https://llvm.org/docs/GettingStarted.html#git-mirror
      message "Making symbolic links..."
      execute "ln -svf \"#{@clang.sources}\" \"#{@sources}/tools\""
      execute "ln -svf \"#{@crt.sources}\" \"#{@sources}/projects\""
      message "LLVM Prepare is Done!"
   end

   def clean
      execute "rm -rf #{@build}"
      execute "rm -rf #{@install}"
   end

end
