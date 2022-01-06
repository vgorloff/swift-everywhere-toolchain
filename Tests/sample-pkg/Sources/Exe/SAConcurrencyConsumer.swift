//
//  File.swift
//  
//
//  Created by Vlad Gorlov on 01.01.22.
//

import Foundation
import SAConcurrency

class SAConcurrencyConsumer {

   private lazy var executor = SAConcurrencyMain()

   func consume() {
      let sema = DispatchSemaphore(value: 0)
      executor.execute {
         sema.signal()
      }
      if sema.wait(timeout: .now() + 10) == .timedOut {
         fatalError("Timeout should never happen")
      }
   }

}
