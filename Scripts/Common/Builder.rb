require_relative "Tool.rb"
require_relative "Lib.rb"
require_relative "Arch.rb"
require_relative "Config.rb"
require_relative "Location.rb"
require_relative "Revision.rb"

class Builder < Tool

   attr_reader :builds, :installs, :sources
   attr_writer :llvm

   def initialize(component, arch)
      @component = component
      @arch = arch
      @sources = "#{Config.sources}/#{component}"
      @patches = "#{Config.patches}/#{component}"
      @builds = "#{Config.build}/#{arch}#{suffix}/#{component}"
      @installs = "#{Config.install}/#{arch}#{suffix}/#{component}"
      @startSpacer = ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
      @endSpacer =   "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      @dryRun = ENV['SA_DRY_RUN'].to_s.empty? == false
      @llvm = nil
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

   def llvm
      if @llvm.nil?
         @llvm = LLVMBuilder.new(@arch).installs + "/usr"
      end
      return @llvm
   end

   def configure()
      logConfigureStarted()
      prepare()
      executeConfigure()
      logConfigureCompleted()
   end

   def build
      logBuildStarted()
      prepare()
      executeBuild()
      logBuildCompleted()
   end

   def install
      logInstallStarted()
      removeInstalls()
      executeInstall()
      logInstallCompleted()
   end

   def executeConfigure()
      # Base class does nothing
   end

   def executeBuild()
      # Base class does nothing
   end

   def executeInstall()
      # Base class does nothing
   end

   # ------------------------------------

   def logStarted(action)
      puts ""
      print(@startSpacer, 33)
      print("\"#{@component}\" #{action} is started.", 36)
   end

   def logCompleted(action)
      print("\"#{@component}\" #{action} is completed.", 36)
      print(@endSpacer, 33)
      puts ""
   end

   def logConfigureStarted
      logStarted("Configure")
   end

   def logBuildStarted
      logStarted("Build")
   end

   def logInstallStarted
      logStarted("Install")
   end

   def logSetupCompleted
      logCompleted("Setup")
   end

   def logBuildCompleted
      logCompleted("Build")
   end

   def logConfigureCompleted
      logCompleted("Configure")
   end

   def logInstallCompleted
      logCompleted("Install")
   end

   # ------------------------------------

   def removeInstalls()
      execute "rm -rf \"#{@installs}\""
   end

   def removeBuilds()
      execute "rm -rf \"#{@builds}\""
   end

   def prepare()
      execute "mkdir -p \"#{@builds}\""
   end

   def clean
      removeBuilds()
      cleanGitRepo()
   end

   def make
      configure()
      build()
      install()
   end

   def cleanGitRepo
      # See: https://stackoverflow.com/a/64966/1418981
      execute "cd #{@sources} && git clean --quiet -f -x -d"
      execute "cd #{@sources} && git clean --quiet -f -X"
   end

   def setupSymLink(from, to, shouldCreate = true)
      if File.exist? to
         execute "rm -vf \"#{to}\""
      end
      if shouldCreate
         execute "mkdir -p \"#{File.dirname(to)}\""
         execute "ln -svf \"#{from}\" \"#{to}\""
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
      configurePatch(originalFile, patchFile, shouldApply)
   end

   def configurePatch(originalFile, patchFile, shouldApply = true)
      gitRepoRoot = "#{Config.sources}/#{@component}"
      backupFile = "#{originalFile}.orig"
      if shouldApply
         if !File.exist? backupFile
            puts "Patching \"#{@component}\"..."
            execute "patch --backup #{originalFile} #{patchFile}"
         else
            puts "Backup file \"#{backupFile}\" exists. Seems you already patched \"#{@component}\". Skipping..."
         end
      else
         message "Removing previously applied patch..."
         execute "cd \"#{gitRepoRoot}\" && git checkout #{originalFile}"
         if File.exist? backupFile
            execute "rm -fv #{backupFile}"
         end
      end
   end

end
