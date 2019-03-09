require_relative "../Common/Builder.rb"

class ClangBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.clang, arch)
   end

end
