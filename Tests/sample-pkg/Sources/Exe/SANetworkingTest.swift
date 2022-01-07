//
//  File.swift
//  
//
//  Created by Vlad Gorlov on 06.01.22.
//

import Foundation

#if os(Android)
import FoundationNetworking
#endif

func networkingTest(completion: @escaping () -> Void) {

   fputs("[SAN] Will start networking request...\n", stdout)

   let url = URL(string: "http://www.example.com")!
   let task = URLSession.shared.dataTask(with: url) { data, response, error in
      if let response = response as? HTTPURLResponse {
         print("[SAN] statusCode: \(response.statusCode)")
      }
      if let error = error {
         print("[SAN] Error: \(error)")
      }
      if let data = data {
         print("[SAN] \(data)")
      }
      completion()
   }
   task.resume()
}
