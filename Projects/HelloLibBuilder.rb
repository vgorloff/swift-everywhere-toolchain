require_relative "ProjectBuilder.rb"

# See also:
# - ios - How to open a .swiftmodule file - Stack Overflow: http://bit.ly/2HET1d9

class HelloLibBuilder < ProjectBuilder

   def initialize(arch = Arch.default)
      component = "hello-lib"
      super(component, arch)
   end

   def executeBuild

      # Lib
      binary = "#{@builds}/libHelloMessages.so"
      execute "cd #{@builds} && #{@swiftc} -emit-library -emit-module -parse-as-library -module-name HelloMessages -o #{binary} #{@sources}/HelloMessage.swift"
      execute "file #{binary}"

      # Exe
      binary = @binary
      execute "cd #{@builds} && #{@swiftc} -emit-executable -I #{@builds} -L #{@builds} -lHelloMessages -o #{binary} #{@sources}/main.swift"
      execute "file #{binary}"
      
      # Swift Libs
      copyLibs()
   end

   def libs
      value = super
      value += Dir["#{@builds}/*.so"]
      return value
   end

end
