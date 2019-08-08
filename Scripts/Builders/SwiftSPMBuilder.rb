require_relative "../Common/Builder.rb"

class SwiftSPMBuilder < Builder

   def initialize()
      super(Lib.swiftSPM, Arch.host)
      @sources = "#{Config.sources}/#{Lib.swift}"
      @cmark = CMarkBuilder.new()
      @llvm = LLVMBuilder.new()
      @clang = ClangBuilder.new(@arch)
   end

   def executeConfigure
      cmd = []
      cmd << "cd #{@builds} &&"
      cmd << "cmake -G Ninja" # --trace --debug-output"
      # -DCMAKE_C_COMPILER=/Volumes/Data/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang
      # -DCMAKE_CXX_COMPILER=/Volumes/Data/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++
      # -DCMAKE_LIBTOOL=/Volumes/Data/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/libtool
      # -DLLVM_VERSION_MAJOR=7 -DLLVM_VERSION_MINOR=0 -DLLVM_VERSION_PATCH=0 -DCLANG_VERSION_MAJOR=7
      # -DCLANG_VERSION_MINOR=0 -DCLANG_VERSION_PATCH=0 -DCMAKE_MAKE_PROGRAM=/Volumes/Data/Developer/Brew/bin/ninja
      cmd << "-DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE"
      cmd << "-DSWIFT_FORCE_OPTIMIZED_TYPECHECKER=FALSE"
      cmd << "-DSWIFT_STDLIB_ENABLE_STDLIBCORE_EXCLUSIVITY_CHECKING=FALSE"
      # -DSWIFT_LIPO=/Volumes/Data/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/lipo
      cmd << "-DCMAKE_C_FLAGS= -Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector"
      cmd << "-DCMAKE_CXX_FLAGS= -Wno-unknown-warning-option -Werror=unguarded-availability-new -fno-stack-protector"
      cmd << "-DCMAKE_BUILD_TYPE=Release"
      cmd << "-DLLVM_ENABLE_ASSERTIONS=TRUE"
      cmd << "-DSWIFT_ANALYZE_CODE_COVERAGE=FALSE"
      cmd << "-DSWIFT_STDLIB_BUILD_TYPE=Release"
      cmd << "-DSWIFT_STDLIB_ASSERTIONS=TRUE"
      cmd << "-DSWIFT_STDLIB_USE_NONATOMIC_RC=FALSE"
      cmd << "-DSWIFT_ENABLE_RUNTIME_FUNCTION_COUNTERS=TRUE"
      # cmd << "-DSWIFT_NATIVE_LLVM_TOOLS_PATH="
      # cmd << "-DSWIFT_NATIVE_CLANG_TOOLS_PATH="
      # cmd << "-DSWIFT_NATIVE_SWIFT_TOOLS_PATH="
      cmd << "-DSWIFT_INCLUDE_TOOLS=TRUE"
      cmd << "-DSWIFT_BUILD_REMOTE_MIRROR=TRUE"
      cmd << "-DSWIFT_STDLIB_SIL_DEBUGGING=FALSE"
      cmd << "-DSWIFT_CHECK_INCREMENTAL_COMPILATION=FALSE"
      cmd << "-DSWIFT_REPORT_STATISTICS=FALSE"
      cmd << "-DSWIFT_BUILD_DYNAMIC_STDLIB=TRUE"
      cmd << "-DSWIFT_BUILD_STATIC_STDLIB=FALSE"
      cmd << "-DSWIFT_BUILD_DYNAMIC_SDK_OVERLAY=TRUE"
      cmd << "-DSWIFT_BUILD_STATIC_SDK_OVERLAY=FALSE"
      cmd << "-DSWIFT_BUILD_PERF_TESTSUITE=FALSE"
      cmd << "-DSWIFT_BUILD_EXTERNAL_PERF_TESTSUITE=FALSE"
      cmd << "-DSWIFT_BUILD_EXAMPLES=FALSE"
      cmd << "-DSWIFT_INCLUDE_TESTS=FALSE"
      cmd << "-DSWIFT_EMBED_BITCODE_SECTION=FALSE"
      cmd << "-DSWIFT_TOOLS_ENABLE_LTO="
      cmd << "-DSWIFT_BUILD_RUNTIME_WITH_HOST_COMPILER=FALSE"
      cmd << "-DLIBDISPATCH_CMAKE_BUILD_TYPE=Release"
      # cmd << "-DSWIFTLIB_DEPLOYMENT_VERSION_XCTEST_IOS=8.0"
      cmd << "-DSWIFT_DARWIN_DEPLOYMENT_VERSION_OSX=10.9"
      # cmd << "-DSWIFT_DARWIN_DEPLOYMENT_VERSION_IOS=7.0"
      # cmd << "-DSWIFT_DARWIN_DEPLOYMENT_VERSION_TVOS=9.0"
      # cmd << "-DSWIFT_DARWIN_DEPLOYMENT_VERSION_WATCHOS=2.0"
      cmd << "-DSWIFT_HOST_TRIPLE=x86_64-apple-macosx10.9"
      cmd << "-DSWIFT_HOST_VARIANT=macosx"
      cmd << "-DSWIFT_HOST_VARIANT_SDK=OSX"
      cmd << "-DSWIFT_HOST_VARIANT_ARCH=x86_64"
      # cmd << "'-DLLVM_LIT_ARGS=-sv -j 3'"
      # cmd << "-DCOVERAGE_DB="
      cmd << "-DSWIFT_DARWIN_XCRUN_TOOLCHAIN=default"
      cmd << "-DSWIFT_AST_VERIFIER=TRUE"
      cmd << "-DSWIFT_SIL_VERIFY_ALL=FALSE"
      cmd << "-DSWIFT_RUNTIME_ENABLE_LEAK_CHECKER=FALSE"
      cmd << "-DCMAKE_INSTALL_PREFIX=/"
      cmd << "-DClang_DIR=#{@llvm.builds}/lib/cmake/clang"
      cmd << "-DLLVM_DIR=#{@llvm.builds}/lib/cmake/llvm"
      cmd << "-DSWIFT_PATH_TO_CMARK_SOURCE=#{@cmark.sources}"
      cmd << "-DSWIFT_PATH_TO_CMARK_BUILD=#{@cmark.builds}"
      # cmd << "-DSWIFT_PATH_TO_LIBDISPATCH_SOURCE=/Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Sources/swift-corelibs-libdispatch"
      # cmd << "-DSWIFT_PATH_TO_LIBDISPATCH_BUILD=/Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Sources/build/Ninja-RelWithDebInfoAssert/libdispatch-macosx-x86_64"
      # cmd << "-DSWIFT_CMARK_LIBRARY_DIR=/Volumes/Data/Repositories/Projects/swift-everywhere-toolchain/ToolChain/Sources/build/Ninja-RelWithDebInfoAssert/cmark-macosx-x86_64/src"
      cmd << "-DSWIFT_SDKS=OSX"
      cmd << "-DSWIFT_EXEC=#{builds}/bin/swiftc"
      cmd << @sources
      execute cmd.join(" \\\n   ")
   end

   def executeBuild
      setupSymLinks(true)
      execute "cd #{@builds} && ninja -j#{numberOfJobs} all swift-stdlib-macosx-x86_64"
      setupSymLinks(false)
   end

   def executeInstall
      setupSymLinks(true)
      execute "DESTDIR=#{@installs} cmake --build #{@builds} --target install"
      setupSymLinks(false)
   end

   def setupSymLinks(enable)
      # Seems like a workaround. Try to configure include paths in CMAKE settings.
      if enable
         setupSymLink("#{toolchainPath}/usr/include/c++", "#{@llvm.builds}/include/c++")
      else
         removeSymLink("#{@llvm.builds}/include/c++")
      end
   end
end