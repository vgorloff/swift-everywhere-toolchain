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

require_relative "Tool.rb"
require_relative "Lib.rb"
require_relative "Arch.rb"
require_relative "Config.rb"
require_relative "Location.rb"
require_relative "Revision.rb"
require 'pathname'

class Builder < Tool

   attr_reader :builds, :installs, :sources, :numberOfJobs

   def initialize(component, arch)
      super()
      @component = component
      @arch = arch
      @sources = "#{Config.sources}/#{component}"
      @patches = "#{Config.patches}/#{component}"
      @builds = "#{Config.build}/#{platform}-#{arch}/#{component}"
      @installs = "#{Config.install}/#{platform}-#{arch}/#{component}"
      @startSpacer = ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
      @endSpacer =   "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      @dryRun = ENV['SA_DRY_RUN'].to_s.empty? == false
      if isMacOS?
         physicalCPUs = `sysctl -n hw.physicalcpu`.to_i
      else
         physicalCPUs = `grep -c ^processor /proc/cpuinfo`.to_i
      end
      @numberOfJobs = [physicalCPUs - 1, 1].max
   end

   def lib
      return @installs + "/lib"
   end

   def bin
      return @installs + "/bin"
   end

   def include
      return @installs + "/include"
   end

   def usr
      return @installs + "/usr"
   end

   def developerDir
      return `xcode-select --print-path`.strip
   end

   def macOSSDK
      return "#{developerDir}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
   end

   def toolchainPath
      if isMacOS?
         return "#{developerDir}/Toolchains/XcodeDefault.xctoolchain"
      else
         return ""
      end
   end

   def clang
      return toolchainPath + "/usr/bin/clang"
   end

   def configure()
      logStarted("Configure")
      prepare()
      unpatch()
      patch()
      executeConfigure()
      logCompleted("Configure")
   end

   def build
      logStarted("Build")
      prepare()
      executeBuild()
      logCompleted("Build")
   end

   def install
      logStarted("Install")
      removeInstalls()
      executeInstall()
      logCompleted("Install")
   end

   def executeConfigure()
      # Base class does nothing
   end

   def executeBuild()
      # Base class does nothing
   end

   def executeClean()
      # Base class does nothing
   end

   def executeInstall()
      # Base class does nothing
   end

   def patch()
      configurePatches(true)
   end

   def unpatch()
      configurePatches(false)
   end

   def configurePatches(shouldEnable = true)
      # Base class does nothing
   end

   # ------------------------------------

   def logStarted(action)
      puts ""
      print(@startSpacer, 33)
      print("\"#{@component}\" #{action} [#{@arch}] is started.", 36)
   end

   def logCompleted(action)
      print("\"#{@component}\" #{action} [#{@arch}] is completed.", 36)
      print(@endSpacer, 33)
      puts ""
   end

   # ------------------------------------

   def removeInstalls()
      execute "rm -rf \"#{@installs}\""
   end

   def removeBuilds()
      execute "rm -rf \"#{@builds}/\"*"
      execute "find \"#{@builds}\" -type f | xargs -I{} rm -rf \"{}\""
   end

   def prepare()
      execute "mkdir -p \"#{@builds}\""
   end

   def clean
      logStarted("Clean")
      unpatch()
      executeClean()
      removeBuilds()
      cleanGitRepo()
      logCompleted("Clean")
   end

   def make
      configure()
      build()
      install()
      unpatch()
   end

   def rebuild()
      clean()
      make()
   end

   def reset()
      execute "cd #{@sources} && git status && git reset --hard"
      cleanGitRepo()
   end

   def cleanGitRepo()
      # See: https://stackoverflow.com/a/64966/1418981
      execute "cd #{@sources} && git clean --quiet -f -x -d"
      execute "cd #{@sources} && git clean --quiet -f -X"
   end

   def setupSymLink(from, to, isRelative = false)
      removeSymLink(to)
      dirname = File.dirname(to)
      execute "mkdir -p \"#{dirname}\""
      if isRelative
         relativePath = Pathname.new(from).relative_path_from(Pathname.new(dirname))
         execute "cd \"#{dirname}\" && ln -svf \"#{relativePath}\""
      else
         execute "ln -svf \"#{from}\" \"#{to}\""
      end
   end

   def removeSymLink(to)
      if File.exist? to
         execute "rm -vf \"#{to}\""
      end
   end

   def addFile(replacementFile, destinationFile, shouldApply = true)
      if shouldApply
         if !File.exist? destinationFile
            puts "Applying fix \"#{@component}\"..."
            execute "cp -vf \"#{replacementFile}\" \"#{destinationFile}\""
         else
            puts "File \"#{destinationFile}\" exists. Seems you already applied fix for \"#{@component}\". Skipping..."
         end
      else
         message "Removing previously applied fix..."
         if File.exist? destinationFile
            execute "rm -fv #{destinationFile}"
         end
      end
   end

   def configurePatchFile(patchFile, shouldApply = true)
      originalFile = patchFile.sub(@patches, @sources).sub('.diff', '')
      gitRepoRoot = "#{Config.sources}/#{@component}"
      backupFile = "#{originalFile}.orig"
      diffFile = "#{originalFile}.diff"
      if shouldApply
         if !File.exist? backupFile
            puts "Patching \"#{@component}\"..."
            execute "patch --backup #{originalFile} #{patchFile}"
            execute "diff -u #{backupFile} #{originalFile} > #{diffFile} | true"
         else
            puts "Backup file \"#{backupFile}\" exists. Seems you already patched \"#{@component}\". Skipping..."
         end
      else
         message "Removing previously applied patch..."
         execute "cd \"#{gitRepoRoot}\" && git checkout #{originalFile}"
         if File.exist? backupFile
            execute "rm -fv #{backupFile}"
         end
         if File.exist? diffFile
            execute "rm -fv #{diffFile}"
         end
      end
   end

   def libs()
      return []
   end

   def verify()
      command = "greadelf"
      aliasValue = `/bin/bash -lc \"alias #{command}\"`.strip()
      if $?.exitstatus != 0
         message "Skipping verification of so-files due non existed shell alias to \"#{command}\"."
         puts "You can install \"binutils\" via `brew install binutils`, and then `alias greadelf=\"YOUR_BREW_ROOT/opt/binutils/bin/greadelf\"`"
      else
         aliasValue = aliasValue.sub(/\s*alias\s+greadelf\s*=\s*/i, '')
         libs.each { |lib|
            verifyLibrary(aliasValue, lib)
         }
      end
   end

   def verifyLibrary(executable, lib)
      message "Checking #{lib}"
      command = "#{executable} -d #{lib}"
      output = `#{command}`.strip()
      if $?.exitstatus != 0
         message "Execution of command is failed:"
         error command
         raise
      end
      lines = output.split("\n")
      lines = lines.select { |line| line.include?("NEEDED") || line.include?("SONAME") }
      lines.each { |line|
         puts line
         match = line.match(/\[(.+)\]/i)
         fileName = match[1]
         if !fileName.end_with?(".so")
            error "Unexpected library name!"
            error line
            error "Library name should not contain version suffixes."
            raise
         end
      }
   end

end
