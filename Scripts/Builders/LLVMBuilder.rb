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
      logConfigureStarted()
      setupSymLinks()
      prepare()
      cFlags = "-Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector"
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja"
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DLLVM_INCLUDE_EXAMPLES=false -DLLVM_INCLUDE_TESTS=false -DLLVM_INCLUDE_DOCS=false"
      cmd << "-DLLVM_TARGETS_TO_BUILD=\"ARM;AArch64;X86\""
      cmd << "-DCMAKE_C_COMPILER:PATH=#{clang} -DCMAKE_CXX_COMPILER:PATH=#{clang}++"
      cmd << "-DLLVM_VERSION_MAJOR:STRING=7 -DLLVM_VERSION_MINOR:STRING=0 -DLLVM_VERSION_PATCH:STRING=0"
      cmd << "-DCLANG_VERSION_MAJOR:STRING=7 -DCLANG_VERSION_MINOR:STRING=0 -DCLANG_VERSION_PATCH:STRING=0"
      cmd << "-DLLVM_ENABLE_ASSERTIONS=TRUE"
      cmd << "-DCMAKE_C_FLAGS='#{cFlags}' -DCMAKE_CXX_FLAGS='#{cFlags}'"
      cmd << "-DLLVM_TOOL_SWIFT_BUILD=NO"
      cmd << "-DLLVM_TOOL_COMPILER_RT_BUILD=TRUE"
      cmd << "-DLLVM_BUILD_EXTERNAL_COMPILER_RT=TRUE"
      cmd << "-DLLVM_LIT_ARGS=-sv"
      cmd << "-DCMAKE_INSTALL_PREFIX=/usr"
      cmd << "-DINTERNAL_INSTALL_PREFIX=local"

      if isMacOS?
         cmd << "-DCMAKE_LIBTOOL=#{toolchainPath}/usr/bin/libtool"
         cmd << "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.9"
         cmd << "-DCMAKE_OSX_SYSROOT=#{macOSSDK}"
         cmd << "-DSANITIZER_MIN_OSX_VERSION=10.9"
         cmd << "-DLLVM_ENABLE_MODULES=FALSE"
         cmd << "-DLLVM_HOST_TRIPLE=x86_64-apple-macosx10.9"
      end

      cmd << @sources
      execute cmd.join(" ")
      logConfigureCompleted()
   end

   def build
      logBuildStarted()
      prepare()
      execute "cd #{@builds} && ninja"
      logBuildCompleted()
   end

   def install
      logInstallStarted()
      removeInstalls()
      execute "env DESTDIR=#{@installs} cmake --build #{@builds} -- install"
      logInstallCompleted()
   end

   def setupSymLinks
      # Making needed SymLinks. See: https://llvm.org/docs/GettingStarted.html#git-mirror
      message "Making symbolic links..."
      clang = ClangBuilder.new(@arch)
      crt = CompilerRTBuilder.new(@arch)
      setupSymLink(clang.sources, "#{@sources}/tools/clang")
      setupSymLink(crt.sources, "#{@sources}/projects/compiler-rt")
      if isMacOS?
         setupSymLink("#{toolchainPath}/usr/include/c++", "#{@builds}/include/c++")
      else
         setupSymLink("/usr/include/c++", "#{@builds}/include/c++")
      end
   end

end
