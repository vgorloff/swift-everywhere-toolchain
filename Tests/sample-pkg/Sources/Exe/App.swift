import Lib
import Foundation
import Dispatch

@main
class App {

   static let shared = App()

   static func main() {
      DispatchQueue.main.async {
         Self.shared.start()
      }
      dispatchMain()
   }

   private lazy var executor = SAConcurrencyMain()
   private let dispatchGroup = DispatchGroup()

   init() {
      fputs("[SA] Starting App...\n", stdout)
   }

   func start() {
      dispatchGroup.enter()
      DispatchQueue.main.async {
         self.peformSimpleActions()
         self.dispatchGroup.leave()
      }

      dispatchGroup.enter()
      DispatchQueue.global().async {
         networkingTest {
            self.dispatchGroup.leave()
         }
      }

      dispatchGroup.enter()
      DispatchQueue.main.async {
         self.executor.execute {
            self.dispatchGroup.leave()
         }
      }

      dispatchGroup.notify(queue: DispatchQueue.main) {
         fputs("[SA] Will exit App...\n", stdout)
         exit(EXIT_SUCCESS)
      }
   }

   func peformSimpleActions() {
      swift_c_sayHello()
      swift_cpp_sayHello()
      //testCoreFoundation()
      coreLibTest()
      testDispatch()
      testOperation()
      testSerialization()
      fflush(stdout)
   }
}
