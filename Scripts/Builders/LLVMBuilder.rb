require_relative "../Common/Builder.rb"

# See:
# - https://stackoverflow.com/questions/40122657/build-llvm-clang4-0-for-android-armeabi
# - LLVM Getting Started: https://llvm.org/docs/GettingStarted.html#requirements
# - CLANG Getting Started: http://clang.llvm.org/get_started.html

class LLVMBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.llvm, arch)
   end

   def configure
      logConfigureStarted
      setupSymLinks
      prepare
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja"
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DLLVM_INCLUDE_EXAMPLES=false"
      cmd << "-DLLVM_INCLUDE_TESTS=false"
      cmd << "-DLLVM_INCLUDE_DOCS=false"
      cmd << "-DLLVM_TARGETS_TO_BUILD=\"ARM;AArch64;X86\""

      cmd << "-DCMAKE_C_COMPILER:PATH=#{clang}"
      cmd << "-DCMAKE_CXX_COMPILER:PATH=#{clang}++"
      # cmd << "-DCMAKE_LIBTOOL:PATH="
      if isMacOS?
         cmd << "-DCMAKE_LIBTOOL=#{toolchainPath}/usr/bin/libtool"
         cmd << "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.12"
         cmd << "-DCMAKE_OSX_SYSROOT=#{macOSSDK}"
         cmd << "-DSANITIZER_MIN_OSX_VERSION=10.12"
         cmd << "-DLLVM_ENABLE_MODULES:BOOL=FALSE"
         cmd << "-DLLVM_HOST_TRIPLE:STRING=x86_64-apple-macosx10.12"
      end
      cmd << "-DLLVM_VERSION_MAJOR:STRING=7"
      cmd << "-DLLVM_VERSION_MINOR:STRING=0"
      cmd << "-DLLVM_VERSION_PATCH:STRING=0"
      cmd << "-DCLANG_VERSION_MAJOR:STRING=7"
      cmd << "-DCLANG_VERSION_MINOR:STRING=0"
      cmd << "-DCLANG_VERSION_PATCH:STRING=0"
      cmd << "-DLLVM_ENABLE_ASSERTIONS=TRUE"
      cFlags = "-Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector"
      cmd << "-DCMAKE_C_FLAGS='#{cFlags}'"
      cmd << "-DCMAKE_CXX_FLAGS='#{cFlags}'"
      cmd << "-DLLVM_TOOL_SWIFT_BUILD=NO"
      # cmd << "-DLLVM_ENABLE_LTO:STRING="
      cmd << "-DLLVM_TOOL_COMPILER_RT_BUILD=TRUE"
      cmd << "-DLLVM_BUILD_EXTERNAL_COMPILER_RT=TRUE"
      cmd << "-DLLVM_LIT_ARGS=-sv"
      # cmd << "-DCMAKE_INSTALL_PREFIX=#{@installs}"
      cmd << "-DCMAKE_INSTALL_PREFIX=/usr"
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
      logInstallStarted
      removeInstalls()
      swift = SwiftBuilder.new()
      execute "env DESTDIR=#{swift.installs} cmake --build #{@builds} -- install-llvm-cov install-llvm-profdata install-IndexStore"
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
      if isMacOS?
         setupSymLink("#{toolchainPath}/usr/include/c++", "#{@builds}/include/c++")
      else
         setupSymLink("/usr/include/c++", "#{@builds}/include/c++")
      end
   end

   def clean
      removeBuilds()
      cleanGitRepo()
   end

end
