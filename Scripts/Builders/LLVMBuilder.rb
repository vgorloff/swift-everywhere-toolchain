require_relative "../Common/Builder.rb"

class LLVMBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.llvm, arch)
   end

   def configure
      # See:
      # - LLVM Getting Started: https://llvm.org/docs/GettingStarted.html#requirements
      # - CLANG Getting Started: http://clang.llvm.org/get_started.html
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja"
      cmd << "-DCMAKE_INSTALL_PREFIX=#{@installs}"
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      # See: https://stackoverflow.com/questions/40122657/build-llvm-clang4-0-for-android-armeabi
      # Line below still cause build failure.
      cmd << "-DLLVM_TARGETS_TO_BUILD=\"ARM;AArch64;X86\""
      # cmd << "-DLLVM_DEFAULT_TARGET_TRIPLE=\"arm-linux-androideabi\""
      cmd << @sources
      execute cmd.join(" ")
      logConfigureCompleted()
   end

   def build
      execute "cd #{@builds} && ninja"
      logBuildCompleted()
   end

   def install
      execute "cd #{@builds} && ninja install"
      logInstallCompleted()
   end

   def make
      prepare
      configure
      compile
      install
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/apple/swift-llvm.git")
   end

   def prepare()
      execute "mkdir -p #{@builds}"
      # Making needed SymLinks. See: https://llvm.org/docs/GettingStarted.html#git-mirror
      message "Making symbolic links..."
      @clang = ClangBuilder.new()
      @crt = CompilerRTBuilder.new()
      execute "ln -svf \"#{@clang.sources}\" \"#{@sources}/tools/clang\""
      execute "ln -svf \"#{@crt.sources}\" \"#{@sources}/projects/compiler-rt\""
      message "LLVM Prepare is Done!"
   end

   def clean
      execute "rm -rf #{@builds}"
      execute "rm -rf #{@installs}"
   end

end
