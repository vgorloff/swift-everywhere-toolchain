require_relative "../Common/Builder.rb"

class CompilerRTBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.crt, arch)
   end

end
