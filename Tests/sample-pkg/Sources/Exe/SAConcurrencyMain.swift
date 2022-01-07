//
//  File.swift
//  
//
//  Created by Vlad Gorlov on 01.01.22.
//

import Foundation
#if os(Android)
import _Concurrency
#endif

public class SAConcurrencyMain {

   private var task: Task<Void, Error>?

   public init() {
      print("[SAC] Concurrency: Init")
   }

   public func execute(completion: @escaping () -> Void) {
      print("[SAC] Concurrency: Start")
#if !false
      task = Task.detached(priority: .high) {
         let urls = await self.getURLs()
         print("[SAC] Concurrency: Got \(urls.count) urls.")
         print("[SAC] Concurrency: End")
         completion()
      }
#else // Below works on macOS but crashes on Android. See: https://github.com/vgorloff/swift-everywhere-toolchain/issues/138
      Task {
         let task = Task.detached(priority: .userInitiated) { () -> Int in
            let urls = await self.getURLs()
            return urls.count
         }
         let value = await task.value
         print("[SAC] Concurrency: Got \(value) urls.")
         print("[SAC] Concurrency: End")
         completion()
      }
#endif
   }

   private func getURLs() async -> [String] {
      Thread.sleep(forTimeInterval: 1)
      return ["https://docs.swift.org/", "https://google.com/", "https://ibm.com/"]
   }

}
