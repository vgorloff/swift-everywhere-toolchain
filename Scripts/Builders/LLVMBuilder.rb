require_relative "../Common/Builder.rb"

class LLVMBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.llvm, arch)
   end

   def configure
      logConfigureStarted
      setupSymLinks
      prepare
      # See:
      # - LLVM Getting Started: https://llvm.org/docs/GettingStarted.html#requirements
      # - CLANG Getting Started: http://clang.llvm.org/get_started.html
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja"
      cmd << "-DCMAKE_INSTALL_PREFIX=#{@installs}"
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DLLVM_INCLUDE_EXAMPLES=false"
      cmd << "-DLLVM_INCLUDE_TESTS=false"
      cmd << "-DLLVM_INCLUDE_DOCS=false"
      # See: https://stackoverflow.com/questions/40122657/build-llvm-clang4-0-for-android-armeabi
      # Line below still cause build failure.
      cmd << "-DLLVM_TARGETS_TO_BUILD=\"ARM;AArch64;X86\""
      # cmd << "-DLLVM_DEFAULT_TARGET_TRIPLE=\"arm-linux-androideabi\""

      # New settings

      cmd << "-DCMAKE_C_COMPILER:PATH=/usr/bin/clang"
      cmd << "-DCMAKE_CXX_COMPILER:PATH=/usr/bin/clang++"
      cmd << "-DCMAKE_LIBTOOL:PATH="
      cmd << "-DLLVM_VERSION_MAJOR:STRING=7"
      cmd << "-DLLVM_VERSION_MINOR:STRING=0"
      cmd << "-DLLVM_VERSION_PATCH:STRING=0"
      cmd << "-DCLANG_VERSION_MAJOR:STRING=7"
      cmd << "-DCLANG_VERSION_MINOR:STRING=0"
      cmd << "-DCLANG_VERSION_PATCH:STRING=0"
      # cmd << "-DCMAKE_MAKE_PROGRAM=/usr/bin/ninja"
      cmd << "-DLLVM_ENABLE_ASSERTIONS=TRUE"
      # cmd << "-DLLVM_TARGETS_TO_BUILD='ARM;AArch64;X86'"
      cmd << "-DCMAKE_C_FLAGS=' -Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector'"
      cmd << "-DCMAKE_CXX_FLAGS=' -Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector'"
      # cmd << "-DCMAKE_C_FLAGS_RELWITHDEBINFO='-O2 -DNDEBUG'"
      # cmd << "-DCMAKE_CXX_FLAGS_RELWITHDEBINFO='-O2 -DNDEBUG'"
      # cmd << "-DCMAKE_BUILD_TYPE:STRING=Release"
      cmd << "-DLLVM_TOOL_SWIFT_BUILD:BOOL=NO"
      # cmd << "-DLLVM_INCLUDE_DOCS:BOOL=TRUE"
      cmd << "-DLLVM_ENABLE_LTO:STRING="
      cmd << "-DLLVM_TOOL_COMPILER_RT_BUILD:BOOL=TRUE"
      cmd << "-DLLVM_BUILD_EXTERNAL_COMPILER_RT:BOOL=TRUE"
      cmd << "-DLLVM_LIT_ARGS=-sv"
      # cmd << "-DCMAKE_INSTALL_PREFIX:PATH=/usr/"
      cmd << "-DINTERNAL_INSTALL_PREFIX=local"

      cmd << @sources
      execute cmd.join(" ")
      logConfigureCompleted()
   end

   def build
      logBuildStarted
      prepare
      execute "cd #{@builds} && ninja"
      logBuildCompleted()
   end

   def install
      return
      logInstallStarted
      removeInstalls()
      execute "cd #{@builds} && ninja install"
      logInstallCompleted()
   end

   def make
      configure
      build
      install
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/apple/swift-llvm.git", "f63b283c7143aef31863d5915c28ee79ed390be3")
   end

   def prepare()
      prepareBuilds()
   end

   def setupSymLinks
      # Making needed SymLinks. See: https://llvm.org/docs/GettingStarted.html#git-mirror
      message "Making symbolic links..."
      clang = ClangBuilder.new()
      crt = CompilerRTBuilder.new()
      setupSymLink(clang.sources, "#{@sources}/tools/clang")
      setupSymLink(crt.sources, "#{@sources}/projects/compiler-rt")
      setupSymLink("/usr/include/c++", "#{@builds}/include/c++")
   end

   def clean
      removeBuilds()
      cleanGitRepo()
   end

end
