//
//  File.swift
//  
//
//  Created by Vlad Gorlov on 23.11.20.
//

import Foundation
import CppLib

public func swift_cpp_sayHello() {

   let instance = MyClass_init()
   MyClass_sayHello(instance)
   MyClass_destroy(instance)
}

