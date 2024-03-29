import Lib

swift_c_sayHello()
swift_cpp_sayHello()

// ~~~~~~~~~~~~~~ CORE
print("SA - SwiftCore: Works!")

#if true
// ~~~~~~~~~~~~~~ DISPATCH
import Dispatch
let sema = DispatchSemaphore(value: 0)

let queue = DispatchQueue(label: "queueName")
queue.async {
   print("SA - DispatchQueue: Works!")
   sema.signal()
}

if sema.wait(timeout: .now() + 10) == .timedOut {
   print("SA - DispatchQueue: Timeout.")
}
#endif


#if true // CoreFoundation
import CoreFoundation

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
#endif // CoreFoundation


#if true
// ~~~~~~~~~~~~~~ FOUNDATION
import Foundation

let op = BlockOperation {
   print("SA - BlockOperation: Works!")
}
let opQueue = OperationQueue()
opQueue.addOperations([op], waitUntilFinished: true)
#endif


#if true
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
#endif


#if true
#if os(Android)
import FoundationNetworking
#endif

let config = URLSessionConfiguration.default
let session = URLSession(configuration: config)
if let url = URL(string: "http://www.example.com") {
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
#endif

// let consumer = SAConcurrencyConsumer()
// consumer.consume()
