require_relative "../Common/Builder.rb"

class CompilerRTBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.crt, arch)
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/apple/swift-compiler-rt.git", "d4667fe980efc317baf2641bc29ce1d41a1a0a6b")
   end

end
