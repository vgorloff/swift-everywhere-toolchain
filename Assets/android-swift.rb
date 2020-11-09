#!/usr/bin/env ruby
#
# The MIT License
#
# Copyright (c) 2019 Volodymyr Gorlov (https://github.com/vgorloff)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

require 'fileutils'

class SwiftBuilder

   def initialize()
      @isVerbose = false
      @knownTargets = [
         "aarch64-unknown-linux-android", "armv7-none-linux-androideabi",
         "i686-unknown-linux-android", "x86_64-unknown-linux-android"
      ]
      @arguments = []
      targetTrippleIndex = -1
      ARGV.each_with_index { |val, index|
         if val == '-v'
            @isVerbose = true
         elsif val == '--android-target'
            targetTrippleIndex = index + 1
         elsif targetTrippleIndex == index
            @targetTripple = val
         else
            @arguments << val
         end
      }
      if @targetTripple.nil?
         warnOnInvalidTarget()
         exit(1)
      end
      if !@knownTargets.include?(@targetTripple)
         warnOnInvalidTarget()
         exit(1)
      end
      @ndkApiVersion = "24"
      if @targetTripple == "aarch64-unknown-linux-android"
         @swiftArch = "aarch64"
         @ndkArch = "aarch64-linux-android"
         @cppArch = "arm64-v8a"
         @ndkPlatformArch = "arm64"
         @clang = "aarch64-linux-android#{@ndkApiVersion}-clang"
      elsif @targetTripple == "armv7-none-linux-androideabi"
         @swiftArch = "armv7"
         @ndkArch = "arm-linux-androideabi"
         @cppArch = "armeabi-v7a"
         @ndkPlatformArch = "arm"
         @clang = "armv7a-linux-androideabi#{@ndkApiVersion}-clang"
      elsif @targetTripple == "i686-unknown-linux-android"
         @swiftArch = "i686"
         @ndkArch = "i686-linux-android"
         @cppArch = "x86"
         @ndkPlatformArch = "x86"
         @clang = "i686-linux-android#{@ndkApiVersion}-clang"
      elsif @targetTripple == "x86_64-unknown-linux-android"
         @swiftArch = "x86_64"
         @ndkArch = "x86_64-linux-android"
         @cppArch = "x86_64"
         @ndkPlatformArch = "x86_64"
         @clang = "x86_64-linux-android#{@ndkApiVersion}-clang"
      end
      @toolchainDir = File.dirname(File.dirname(File.dirname(__FILE__)))
      @ndkPath = "/usr/local/ndk/20.1.5948944"
      @ndkGccVersion = "4.9"
      @ndkToolChain = "#{@ndkPath}/toolchains/llvm/prebuilt/darwin-x86_64"
   end

   def warnOnInvalidTarget()
      puts("Please provide valid build target.\nKnown targets:")
      @knownTargets.map { |value| puts "   --android-target #{value}" }
   end

   def compile()
      args = swiftcArgs()
      passedArguments = @arguments.join(" ")
      passedArguments = passedArguments.gsub(/-Xlinker\s+-install_name/, '') # Removing non-Android options.
      passedArguments = passedArguments.gsub(/-Xlinker\s+@rpath\/.+?\.dylib/, '') # Removing non-Android options.
      passedArguments = passedArguments.gsub(/-rpath\s+@loader_path/, '') # Removing non-Android options.
      cmd = "#{@toolchainDir}/usr/bin/swiftc " + args.join(" ") + " " + passedArguments
      if @isVerbose
         puts cmd
      end
      system cmd
      exit($?.exitstatus)
   end

   def swiftcArgs()
      args = []
      if @isVerbose
         args << "-v"
         args << "-Xcc -v"
      end
      args << "-swift-version 5"
      args << "-target #{@targetTripple}"
      args << "-tools-directory #{@ndkToolChain}/bin"

      # See:
      # - https://github.com/apple/swift/pull/26366/files
      # - https://github.com/apple/swift/pull/25990#issuecomment-522344255
      args << "-Xcc --sysroot=#{@ndkPath}/sysroot"
      args << "-Xclang-linker --sysroot=#{@ndkPath}/platforms/android-#{@ndkApiVersion}/arch-#{@ndkPlatformArch}"
      args << "-Xclang-linker --gcc-toolchain=#{@ndkToolChain}"

      args << "-Xcc -I#{@ndkToolChain}/sysroot/usr/include -Xcc -I#{@ndkToolChain}/sysroot/usr/include/#{@ndkArch}"
      args << "-L #{@ndkPath}/sources/cxx-stl/llvm-libc++/libs/#{@cppArch}"
      args << "-L #{@ndkToolChain}/lib/gcc/#{@ndkArch}/#{@ndkGccVersion}.x" # Link the Android NDK's -lstdc++ and libgcc.
      args << "-L #{@ndkToolChain}/sysroot/usr/lib/#{@ndkArch}/#{@ndkApiVersion}" # Link the Android NDK's -lc++
      args << "-L #{@toolchainDir}/usr/lib/swift/android/#{@swiftArch}"
      return args
   end

   def copyLibs()
      destination = @arguments.first
      if destination.nil?
         puts "! Destination directory to copy \"#{@swiftArch}\" libraries is not provided."
         exit(1)
      end

      if @isVerbose
         puts "Copying \"#{@swiftArch}\" libraries to \"#{destination}\""
      end
      system "mkdir -p \"#{destination}\""

      files = Dir["#{@toolchainDir}/usr/lib/swift/android/#{@swiftArch}" + "/*.so"]
      files << "#{@ndkPath}/sources/cxx-stl/llvm-libc++/libs/#{@cppArch}/libc++_shared.so"
      files.each { |lib|
         dst = File.join(destination, File.basename(lib))
         if !FileUtils.uptodate?(dst, [lib])
            if @isVerbose
               puts "- Copying \"#{lib}\" to \"#{dst}\""
            end
            FileUtils.copy_entry(lib, dst, false, false, true)
         end
      }
   end

   def build()
      cmd = []
      cmd << "SWIFT_EXEC=\"#{@toolchainDir}/usr/bin/swiftc-#{@ndkArch}\""
      # cmd << "CC=#{@ndkToolChain}/bin/#{@clang}"
      # cmd << "CXX=#{@ndkToolChain}/bin/#{@clang}++"
      cmd << "swift build"
      if @isVerbose
         # cmd << "-v"
         cmd << "-Xswiftc -v"
      end
      cmd << "-Xswiftc -target -Xswiftc #{@targetTripple}"
      cmd << "-Xswiftc -sdk -Xswiftc #{@toolchainDir}"
      # cmd << "-Xswiftc -swift-version -Xswiftc 5"
      # cmd << "-Xlinker -L -Xlinker #{@ndkToolChain}/sysroot/usr/lib/#{@ndkArch}/#{@ndkApiVersion}"
      cmd = cmd.join(" ") + " " + @arguments.join(" ")
      if @isVerbose
         puts cmd
      end
      system cmd
      status = $?.exitstatus
      if status.zero?
         binaryDir = `swift build --show-bin-path #{@arguments.join(" ")}`.strip()
         libs = Dir["#{binaryDir}/**/*.dylib"]
         libs.each { |lib|
            destination = lib.sub(/\.dylib$/, '.so')
            if !FileUtils.uptodate?(destination, [lib])
               if @isVerbose
                  puts "- Copying \"#{lib}\" to \"#{destination}\""
               end
               FileUtils.copy_entry(lib, destination, false, false, true)
            end
         }
      end
      exit(status)
   end

end
