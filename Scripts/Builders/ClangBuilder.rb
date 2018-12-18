require_relative "../Common/Builder.rb"

class ClangBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.clang, arch)
   end

   def checkout
      checkoutIfNeeded(@sources, "https://git.llvm.org/git/clang.git")
   end

end
