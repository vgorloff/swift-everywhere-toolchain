require_relative "../Scripts/ProjectBuilder.rb"

# See also:
# - ios - How to open a .swiftmodule file - Stack Overflow: http://bit.ly/2HET1d9

class Builder < ProjectBuilder

   def initialize(arch = Arch.default)
      @root = File.dirname(__FILE__)
      super("hello-package", arch)
   end

   def executeBuild
      binary1 = "#{@builds}/#{@config}/Exe"
      binary2 = "#{@builds}/#{@config}/libLib.so"
      execute "cd #{@builds} && #{@swiftBuildCmd}"
      execute "file #{binary1}"
      execute "file #{binary2}"
   end

end
