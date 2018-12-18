require_relative "../Common/Builder.rb"

class CompilerRTBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.crt, arch)
   end

   def checkout
      checkoutIfNeeded(@sources, "https://git.llvm.org/git/compiler-rt.git")
   end

end
