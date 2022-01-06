//
//  File.swift
//  
//
//  Created by Vlad Gorlov on 01.01.22.
//

import Foundation

public class SAConcurrencyMain {

   public init() {
      print("SA - Concurrency: Init")
   }

   public func execute(completion: @escaping () -> Void) {
      print("SA - Concurrency: Start")
      Task {
         let task = Task.detached(priority: .userInitiated) { () -> Int in
            let urls = await self.getURLs()
            return urls.count
         }
         let value = await task.value
         print("SA - Concurrency: Got \(value) urls.")
         print("SA - Concurrency: End")
         completion()
      }
   }

   private func getURLs() async -> [String] {
      Thread.sleep(forTimeInterval: 1)
      return ["https://docs.swift.org/", "https://google.com/", "https://ibm.com/"]
   }

}
