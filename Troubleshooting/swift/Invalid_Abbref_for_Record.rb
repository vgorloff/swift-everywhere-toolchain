#!/usr/bin/env ruby

require_relative "../Troubleshooter.rb"

class Builder < Troubleshooter
   def initialize()
      super(File.expand_path(File.dirname(__FILE__)))
   @cmd = <<EOM
cd /vagrant/ToolChain/Build/linux-host/swift/stdlib/public/core && /home/linuxbrew/.linuxbrew/Cellar/cmake/3.14.5/bin/cmake -E remove -f /vagrant/ToolChain/Build/linux-host/swift/./lib/swift/android/armv7/Swift.swiftmodule /vagrant/ToolChain/Build/linux-host/swift/./lib/swift/android/armv7/Swift.swiftdoc /vagrant/ToolChain/Build/linux-host/swift/./lib/swift/android/armv7/Swift.swiftinterface && /home/linuxbrew/.linuxbrew/Cellar/cmake/3.14.5/bin/cmake -E make_directory /vagrant/ToolChain/Build/linux-host/swift/./lib/swift/android/armv7 && /home/linuxbrew/.linuxbrew/bin/python /vagrant/ToolChain/Sources/swift/utils/line-directive @/vagrant/ToolChain/Build/linux-host/swift/stdlib/public/core/69kAj.txt -- /vagrant/ToolChain/Build/linux-host/swift/./bin/swiftc -v -emit-module -o /vagrant/ToolChain/Build/linux-host/swift/./lib/swift/android/armv7/Swift.swiftmodule -target armv7-none-linux-androideabi "-I/android-ndk/sources/android/support/include" "-I/android-ndk/sysroot/usr/include" "-I/android-ndk/sysroot/usr/include/arm-linux-androideabi" -resource-dir /vagrant/ToolChain/Build/linux-host/swift/./lib/swift -O -I /vagrant/ToolChain/Build/linux-host/swift/./lib/swift/android/armv7 -module-cache-path /vagrant/ToolChain/Build/linux-host/swift/./module-cache -no-link-objc-runtime -enable-library-evolution -Xfrontend -enforce-exclusivity=unchecked -nostdimport -parse-stdlib -module-name Swift -Xfrontend -group-info-path -Xfrontend /vagrant/ToolChain/Sources/swift/stdlib/public/core/GroupInfo.json -swift-version 5 -runtime-compatibility-version none -disable-autolinking-runtime-compatibility-dynamic-replacements -warn-swift3-objc-inference-complete -Xfrontend -verify-syntax-tree -Xllvm -sil-inline-generics -Xllvm -sil-partial-specialization -Xcc -DswiftCore_EXPORTS -warn-implicit-overrides -module-link-name swiftCore -force-single-frontend-invocation -parse-as-library -emit-parseable-module-interface-path /vagrant/ToolChain/Build/linux-host/swift/./lib/swift/android/armv7/Swift.swiftinterface @/vagrant/ToolChain/Build/linux-host/swift/stdlib/public/core/69kAj.txt

EOM
   @cmd_ = <<EOM
   /vagrant/ToolChain/Build/linux-host/swift/bin/swift -frontend -emit-module -filelist /tmp/sources-4e9fec -supplementary-output-file-map /tmp/supplementaryOutputs-9723f3 -disable-objc-attr-requires-foundation-module -target armv7-none-linux-android -disable-objc-interop -I /android-ndk/sources/android/support/include -I /android-ndk/sysroot/usr/include -I /android-ndk/sysroot/usr/include/arm-linux-androideabi -I /vagrant/ToolChain/Build/linux-host/swift/./lib/swift/android/armv7 -warn-swift3-objc-inference-complete -warn-implicit-overrides -enable-library-evolution -module-cache-path /vagrant/ToolChain/Build/linux-host/swift/./module-cache -module-link-name swiftCore -nostdimport -parse-stdlib -resource-dir /vagrant/ToolChain/Build/linux-host/swift/./lib/swift -swift-version 5 -O -enforce-exclusivity=unchecked -group-info-path /vagrant/ToolChain/Sources/swift/stdlib/public/core/GroupInfo.json -verify-syntax-tree -Xllvm -sil-inline-generics -Xllvm -sil-partial-specialization -Xcc -DswiftCore_EXPORTS -parse-as-library -module-name Swift -o /vagrant/ToolChain/Build/linux-host/swift/./lib/swift/android/armv7/Swift.swiftmodule -runtime-compatibility-version none -disable-autolinking-runtime-compatibility-dynamic-replacements
EOM
   end
end

Builder.new().build()
