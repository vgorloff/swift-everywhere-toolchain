require_relative "../Scripts/ProjectBuilder.rb"

# See:
# -  Build error: No such module "SwiftGlibc" – https://lists.swift.org/pipermail/swift-dev/Week-of-Mon-20160919/002955.html
class Builder < ProjectBuilder

   def initialize(arch)
      @root = File.dirname(__FILE__)
      super("hello-exe", arch)
   end

   def executeBuild
      binary = "#{@builds}/#{@component}"
      execute "cd #{@builds} && #{@swiftc} -emit-executable -o #{binary} #{@sources}/main.swift"
      execute "file #{binary}"
      copyLibs()
   end

end
