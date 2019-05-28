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
      @builds = "#{Config.build}/#{arch}/#{component}"
      @installs = "#{Config.install}/#{arch}/#{component}"
      @startSpacer = ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
      @endSpacer =   "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      @dryRun = ENV['SA_DRY_RUN'].to_s.empty? == false
      physicalCPUs = `sysctl -n hw.physicalcpu`.to_i
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
      return "#{developerDir}/Toolchains/XcodeDefault.xctoolchain"
   end

   def clang
      return toolchainPath + "/usr/bin/clang"
   end

   def configure()
      logConfigureStarted()
      prepare()
      unpatch()
      patch()
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
      unpatch()
      removeBuilds()
      cleanGitRepo()
   end

   def make
      configure()
      build()
      install()
      unpatch()
   end

   def cleanGitRepo
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
