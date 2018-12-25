require_relative "../Common/Builder.rb"

class UUIDBuilder < Builder

   def initialize(arch = Arch.default)
      super(Lib.uuid, arch)
      @uuidSources = "#{@sources}/libuuid/src"
   end

   def configure
      configurePatches()
      ndk = AndroidBuilder.new(@arch)
      prepare
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja"
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DCMAKE_INSTALL_PREFIX=#{@installs}"
      if @arch == Arch.host
         cmd << "-DCMAKE_C_COMPILER=clang"
      else
         cmd << "-DCMAKE_TOOLCHAIN_FILE=#{ndk.sources}/build/cmake/android.toolchain.cmake"
         cmd << "-DANDROID_NDK=#{ndk.sources}"
         cmd << "-DANDROID_ABI=armeabi-v7a"
         cmd << "-DANDROID_PLATFORM=android-#{ndk.api}"
         cmd << "-DANDROID_STL=c++_shared"
      end
      cmd << @uuidSources
      execute cmd.join(" ")
      logConfigureCompleted
   end

   def build
      prepare
      execute "cd #{@builds} && ninja"
      logBuildCompleted
   end

   def make
      configure
      build
      install
   end

   def install
      removeInstalls()
      execute "cd #{@builds} && ninja install"
      configurePatches(false)
      logInstallCompleted
   end

   def configurePatches(shouldEnable = true)
      addFile("#{@patches}/CMakeLists.txt", "#{@sources}/libuuid/src/CMakeLists.txt", shouldEnable)
   end

   def clean
      configurePatches(false)
      removeBuilds()
   end

   def prepare
      prepareBuilds()
   end

   def checkout
      checkoutIfNeeded(@sources, "https://github.com/karelzak/util-linux.git", "200769b6c0dff6863089ea2a9ff4ea9ccbd15d0f")
   end

end
