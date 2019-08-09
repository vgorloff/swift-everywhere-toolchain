// swift-tools-version:5.0

import PackageDescription

let package = Package(
   name: "HelloJNI",
   products: [
      // See: https://theswiftdev.com/2019/01/14/all-about-the-swift-package-manager-and-the-swift-toolchain/
      .library(name: "Lib", type: .dynamic, targets: ["Lib"])
   ],
   targets: [
      .target(name: "Lib"),
      .target(name: "Exe")
   ]
)