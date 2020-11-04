
class Automation < Tool

   def fixModuleMaps()
      moduleMaps = Dir["#{Config.toolchainDir}/usr/lib/swift/**/glibc.modulemap"]
      moduleMaps.each { |file|
         puts "* Correcting \"#{file}\""
         contents = File.read(file)
         contents = contents.gsub(/header\s+\".+sysroot/, "header \"/usr/local/ndk/sysroot")
         File.write(file, contents)
      }
   end

   def copyToolchainFiles()
     toolchainDir = "#{Config.toolchainDir}/usr"

     @archsToBuild.each { |arch|

       root = ICUBuilder.new(arch).installs
       files = Dir["#{root}/lib/*.so"].reject { |file| file.include?("libicutestswift.so") }
       copyLibFiles(files, root, toolchainDir, arch)

       root = OpenSSLBuilder.new(arch).installs
       files = Dir["#{root}/lib/*.so"]
       copyLibFiles(files, root, toolchainDir, arch)

       root = CurlBuilder.new(arch).installs
       files = Dir["#{root}/lib/*.so"]
       copyLibFiles(files, root, toolchainDir, arch)

       root = XMLBuilder.new(arch).installs
       files = Dir["#{root}/lib/*.so"]
       copyLibFiles(files, root, toolchainDir, arch)
     }
   end

   def copyLibFiles(files, source, destination, arch)
     if arch == Arch.armv7a
        archPath = "armv7"
     elsif arch == Arch.x86
        archPath = "i686"
     elsif arch == Arch.aarch64
        archPath = "aarch64"
     elsif arch == Arch.x64
        archPath = "x86_64"
     end
     files.each { |file|
       dst = file.sub(source, destination).sub("/lib/", "/lib/swift/android/#{archPath}/")
       puts "- Copying \"#{file}\""
       FileUtils.mkdir_p(File.dirname(dst))
       FileUtils.copy_entry(file, dst, false, false, true)
     }
   end

end
