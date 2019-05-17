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
      setupSymLinks(true)
      cFlags = "-Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector"
      cmd = <<EOM
      cd #{@builds} && cmake -G Ninja
      -S #{@sources}
      -B #{@builds}
      -DCMAKE_BUILD_TYPE=Release
      -DLLVM_INCLUDE_EXAMPLES=false -DLLVM_INCLUDE_TESTS=false -DLLVM_INCLUDE_DOCS=false
      -DLLVM_BUILD_TOOLS=false -DLLVM_INSTALL_BINUTILS_SYMLINKS=false

      # See also: https://groups.google.com/forum/#!topic/llvm-dev/5qSTO3VUUe4
      -DLLVM_TARGETS_TO_BUILD=\"ARM;AArch64;X86\"

      -DLLVM_ENABLE_ASSERTIONS=TRUE
      -DLLVM_BUILD_EXTERNAL_COMPILER_RT=TRUE
      -DCMAKE_INSTALL_PREFIX=/
      -DLLVM_ENABLE_PROJECTS=\"clang;compiler-rt\"
EOM
      executeCommands cmd
      setupSymLinks(false)
   end

   def executeBuild
      setupSymLinks(true)
      execute "cd #{@builds} && ninja -C #{@builds} -j#{numberOfJobs}"
      setupSymLinks(false)
   end

   def executeInstall
      setupSymLinks(true)
      execute "DESTDIR=#{@installs} cmake --build #{@builds} --target install"
      setupSymLinks(false)
   end

   def setupSymLinks(enable)
      # Making needed SymLinks. See: https://llvm.org/docs/GettingStarted.html#git-mirror
      message "Making symbolic links..."
      setupSymLink(ClangBuilder.new(@arch).sources, "#{@sources}/tools/clang", true)
      setupSymLink(CompilerRTBuilder.new(@arch).sources, "#{@sources}/projects/compiler-rt", true)

      # Seems like a workaround. Try to configure include paths in CMAKE settings.
      if enable
         setupSymLink("#{toolchainPath}/usr/include/c++", "#{@builds}/include/c++")
      else
         removeSymLink("#{@builds}/include/c++")
      end
   end

end
