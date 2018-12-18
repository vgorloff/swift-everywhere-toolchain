require_relative "../Common/Builder.rb"

class ClangBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.clang, arch)
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/apple/swift-clang.git")
   end

end
