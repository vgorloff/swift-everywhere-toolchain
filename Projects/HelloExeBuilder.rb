require_relative "ProjectBuilder.rb"

# See:
# -  Build error: No such module "SwiftGlibc" – https://lists.swift.org/pipermail/swift-dev/Week-of-Mon-20160919/002955.html
class HelloExeBuilder < ProjectBuilder

   def initialize(arch = Arch.default)
      component = "hello-exe"
      super(component, arch)
   end

   def executeBuild
     execute "cd #{@builds} && #{@swiftc} -emit-executable -o #{@binary} #{@sources}/main.swift"
     execute "file #{@binary}"
     copyLibs()
   end

end
