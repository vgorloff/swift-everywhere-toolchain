#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
      @cmd = <<EOM
      cd /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/llbuild &&

      /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/swift/bin/swiftc \
      -output-file-map products/llbuildSwift/CMakeFiles/llbuildSwift.dir/Release/output-file-map.json -incremental \
      -j 12 -emit-library \
      -o lib/libllbuildSwift.dylib \
      -module-name llbuildSwift -module-link-name llbuildSwift -emit-module -emit-module-path products/llbuildSwift/llbuildSwift.swiftmodule -emit-dependencies -DllbuildSwift_EXPORTS \
      -Xfrontend -target-cpu -Xfrontend x86-64 -target-cpu x86-64 \
      -Xlinker -v -Xlinker -arch -Xlinker x86_64 \
      -Xfrontend -target -Xfrontend x86_64-apple-macos10.10 -target x86_64-apple-macos10.10 \
      -v -O \
      -sdk /Volumes/Apps/Developer/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk -target -apple-macosx10.10 \
      -sdk /Volumes/Apps/Developer/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk \




      -I /Volumes/Apps/Developer/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/12.0.0/include




      -I /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/llbuild/include -I /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/llbuild/products/libllbuild/include -I /Volumes/Apps/Developer/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/llbuild/products/llbuildSwift/BuildSystemBindings.swift /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/llbuild/products/llbuildSwift/CoreBindings.swift /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/llbuild/products/llbuildSwift/BuildDBBindings.swift /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/llbuild/products/llbuildSwift/BuildKey.swift /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/llbuild/products/llbuildSwift/Internals.swift /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Sources/llbuild/products/llbuildSwift/BuildValue.swift  \
      -Xlinker -install_name -Xlinker @rpath/libllbuildSwift.dylib  \
      -L /Volumes/Shared/Git/MyProjects/swift-everywhere-toolchain/ToolChain/Build/darwin-host/llbuild/lib \
      -Xlinker -rpath -Xlinker @loader_path:@loader_path/../../macosx  \
      lib/libllbuild.dylib  /usr/lib/libsqlite3.dylib
EOM
   end

end

Builder.new().build()
