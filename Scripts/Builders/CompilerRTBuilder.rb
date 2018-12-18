require_relative "../Common/Builder.rb"

class CompilerRTBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.crt, arch)
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/apple/swift-compiler-rt.git")
   end

end
