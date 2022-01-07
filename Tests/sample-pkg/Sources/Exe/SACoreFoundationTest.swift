//
//  File.swift
//  
//
//  Created by Vlad Gorlov on 06.01.22.
//

import Foundation
import CoreFoundation

func testCoreFoundation() {
   print("[SAF] Checking CoreFoundation")
#if os(Android)
   let mode = kCFRunLoopDefaultMode
#else
   let mode = CFRunLoopMode.defaultMode
#endif

   let result = CFRunLoopRunInMode(mode, 1.0, false)
   //let x = kCFRunLoopRunFinished // This line won't compile on Android
   _ = CFRunLoopRunResult.finished
   switch result {
   case .finished:
      break
   case .handledSource:
      break
   case .stopped:
      break
   case .timedOut:
      break
   @unknown default:
      break
   }
}
