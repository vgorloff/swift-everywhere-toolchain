//
//  File.swift
//  
//
//  Created by Vlad Gorlov on 06.01.22.
//

import Foundation

func testOperation() {
   let op = BlockOperation {
      print("[SAF] BlockOperation: Works!")
   }
   let opQueue = OperationQueue()
   opQueue.addOperations([op], waitUntilFinished: true)
}

func testSerialization() {
   let json = ["name": "[SAF] JSONSerialization/JSONDecoder: Works!"]
   do {
      let data = try JSONSerialization.data(withJSONObject: json, options: [])
      struct Person: Decodable {
         let name: String
      }

      let person = try JSONDecoder().decode(Person.self, from: data)
      print(person.name)
   } catch {
      print(error)
   }
}
