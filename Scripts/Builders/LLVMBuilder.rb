require_relative "../Common/Builder.rb"

# See:
# - https://stackoverflow.com/questions/40122657/build-llvm-clang4-0-for-android-armeabi
# - LLVM Getting Started: https://llvm.org/docs/GettingStarted.html#requirements
# - CLANG Getting Started: http://clang.llvm.org/get_started.html
# - Building LLVM with CMake — LLVM 9 documentation: https://llvm.org/docs/CMake.html

class LLVMBuilder < Builder

   def initialize()
      super(Lib.llvm, Arch.host)
   end

   def executeConfigure
      setupSymLinks()
      cFlags = "-Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector"
      cmd = []
      cmd << "cd #{@builds} && cmake -G Ninja -S #{@sources} -B #{@builds}"
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DLLVM_INCLUDE_EXAMPLES=false -DLLVM_INCLUDE_TESTS=false -DLLVM_INCLUDE_DOCS=false"
      cmd << "-DLLVM_BUILD_TOOLS=false -DLLVM_INSTALL_BINUTILS_SYMLINKS=false"

      # See also: https://groups.google.com/forum/#!topic/llvm-dev/5qSTO3VUUe4
      cmd << "-DLLVM_TARGETS_TO_BUILD=\"ARM;AArch64;X86\""

      cmd << "-DCMAKE_C_COMPILER:PATH=#{clang} -DCMAKE_CXX_COMPILER:PATH=#{clang}++"
      cmd << "-DLLVM_VERSION_MAJOR:STRING=7 -DLLVM_VERSION_MINOR:STRING=0 -DLLVM_VERSION_PATCH:STRING=0"
      cmd << "-DLLVM_ENABLE_ASSERTIONS=TRUE"
      cmd << "-DCMAKE_C_FLAGS='#{cFlags}' -DCMAKE_CXX_FLAGS='#{cFlags}'"
      cmd << "-DLLVM_BUILD_EXTERNAL_COMPILER_RT=TRUE"
      cmd << "-DCMAKE_INSTALL_PREFIX=/"
      cmd << "-DLLVM_ENABLE_PROJECTS=\"clang;compiler-rt\""

      cmd << "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.9"
      cmd << "-DCMAKE_OSX_SYSROOT=#{macOSSDK}"
      cmd << "-DLLVM_ENABLE_MODULES=FALSE"
      cmd << "-DLLVM_HOST_TRIPLE=x86_64-apple-macosx10.9"

      message "Running cmake..."
      execute cmd.join(" ")
   end

   def executeBuild
      execute "cd #{@builds} && ninja -C #{@builds} -j#{numberOfJobs}"
   end

   def executeInstall
      execute "DESTDIR=#{@installs} cmake --build #{@builds} -- install"
   end

   def setupSymLinks
      # Making needed SymLinks. See: https://llvm.org/docs/GettingStarted.html#git-mirror
      message "Making symbolic links..."
      setupSymLink(ClangBuilder.new(@arch).sources, "#{@sources}/tools/clang", true)
      setupSymLink(CompilerRTBuilder.new(@arch).sources, "#{@sources}/projects/compiler-rt", true)

      # Seems like a workaround. Try to configure include paths in CMAKE settings.
      setupSymLink("#{toolchainPath}/usr/include/c++", "#{@builds}/include/c++")
   end

end
