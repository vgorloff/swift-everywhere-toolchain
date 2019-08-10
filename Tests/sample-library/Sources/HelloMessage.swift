import Dispatch
import Foundation
import FoundationNetworking

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

      let config = URLSessionConfiguration.default
      let session = URLSession(configuration: config)
      if let url = URL(string: "https://www.example.com") {
         let sema2 = DispatchSemaphore(value: 0)
         let task = session.dataTask(with: url) { data, response, error in
            if let response = response {
               print("Response: \(response)")
            }
            if let error = error {
               print("Error: \(error)")
            }
            if let data = data {
               print(data)
            }
            sema2.signal()
         }
         print("URL Task: \(task)")
         task.resume()
         if sema2.wait(timeout: .now() + 10) == .timedOut {
            print("~~~~~~")
         }
      } else {
         print("bad url")
      }

   }

}
