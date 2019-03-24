import Foundation

@_cdecl("Java_com_home_helloNDK_SwiftLib_sayHello")
public func sayHello() -> Int {
   // fatalError()
   return Int(Date().timeIntervalSince1970)
}