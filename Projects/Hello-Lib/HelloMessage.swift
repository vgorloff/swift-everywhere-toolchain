import Dispatch
import Foundation

public class HelloMessage {

   public init() {
   }

   public func execute() {

      // ~~~~~~~~~~~~~~ CORE
      print("SA - SwiftCore: Works!")

      // ~~~~~~~~~~~~~~ DISPATCH
      let sema = DispatchSemaphore(value: 0)

      let queue = DispatchQueue(label: "queueName")
      queue.async {
         print("SA - DispatchQueue: Works!")
         sema.signal()
      }

      if sema.wait(timeout: .now() + 10) == .timedOut {
         print("SA - DispatchQueue: Timeout.")
      }

      // ~~~~~~~~~~~~~~ FOUNDATION
      let op = BlockOperation {
         print("SA - BlockOperation: Works!")
      }
      let opQueue = OperationQueue()
      opQueue.addOperations([op], waitUntilFinished: true)

      // ~~~~~~~~~~~~~~~~ Serialization
      let json = ["name": "SA - JSONSerialization/JSONDecoder: Works!"]
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

      // ~~~~~~~~~~ Networking
      print("SA - URLSession: Currently disabled. Will fail with `Segmentation fault`. Seems something in Foundation classes needs to be fixed.")

      // Still works strange. `Segmentation fault`

      // let config = URLSessionConfiguration()
      // let session = URLSession(configuration: config)
      // if let url = URL(string: "https://www.example.com") {
      //    let sema2 = DispatchSemaphore(value: 0)
      //    let task = session.dataTask(with: url) { data, response, error in
      //       if let response = response {
      //          print(response)
      //       }
      //       if let error = error {
      //          print(error)
      //       }
      //       if let data = data {
      //          print(data)
      //       }
      //       sema2.signal()
      //    }
      //    print(task)
      //    task.resume()
      //    if sema2.wait(timeout: .now() + 10) == .timedOut {
      //       print("~~~~~~")
      //    }
      // } else {
      //    print("bad url")
      // }

   }

}
