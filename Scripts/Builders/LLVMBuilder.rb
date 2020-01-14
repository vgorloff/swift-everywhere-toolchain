#
# The MIT License
#
# Copyright (c) 2019 Volodymyr Gorlov (https://github.com/vgorloff)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

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
      -S #{@sources}/llvm
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
      message "Making symbolic links..."
      # Seems like a workaround. Try to configure include paths in CMAKE settings.
      if enable
         setupSymLink("#{toolchainPath}/usr/include/c++", "#{@builds}/include/c++")
      else
         removeSymLink("#{@builds}/include/c++")
      end
   end

end
