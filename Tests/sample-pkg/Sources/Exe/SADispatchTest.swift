//
//  File.swift
//  
//
//  Created by Vlad Gorlov on 06.01.22.
//

import Foundation
import Dispatch

func testDispatch() {
   let sema = DispatchSemaphore(value: 0)

   let queue = DispatchQueue(label: "queueName")
   queue.async {
      print("[SAD] DispatchQueue: Works!")
      sema.signal()
   }

   if sema.wait(timeout: .now() + 10) == .timedOut {
      print("[SAD] DispatchQueue: Timeout.")
   }
}
