require_relative "../Common/Builder.rb"

class ClangBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.clang, arch)
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/apple/swift-clang.git", "41ac4c42625c7a881ef7a9d2c8fe6f61daacbca0")
   end

end
