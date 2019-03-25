require_relative "ICUBuilder.rb"

class ICUHostBuilder < ICUBuilder

   def initialize()
      super(Arch.host)
   end

   def executeConfigure
      cmd = ["cd #{@builds} &&"]
      cmd << "CFLAGS='-Os'"
      cmd << "CXXFLAGS='--std=c++11'"
      cmd << "#{@sources}/source/runConfigureICU MacOSX --prefix=#{@installs}"
      cmd << "--enable-static --enable-shared=no --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no"
      cmd << "--enable-layoutex=no --enable-tools=no --enable-tests=no --enable-samples=no --enable-dyload=no"
      execute cmd.join(" ")
   end

end
