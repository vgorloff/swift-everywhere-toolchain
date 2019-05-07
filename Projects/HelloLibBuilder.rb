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

      cmd = ["cd #{@builds} &&"]
      cmd << "#{@toolchainDir}/bin/swiftc -emit-library -emit-module -parse-as-library -module-name HelloMessages"
      cmd += swiftFlags
      cmd << "-o #{binary}"
      cmd << "#{@sources}/HelloMessage.swift"

      execute cmd.join(" ")
      execute "file #{binary}"

      # Exe

      binary = @binary

      cmd = ["cd #{@builds} &&"]
      cmd << "#{@toolchainDir}/bin/swiftc -emit-executable -I #{@builds} -L #{@builds} -lHelloMessages"
      cmd += swiftFlags
      cmd << "-o #{binary}"
      cmd << "#{@sources}/main.swift"

      execute cmd.join(" ")
      execute "file #{binary}"
   end

   def libs
      value = super
      value += Dir["#{@builds}/*.so"]
      return value
   end

end
