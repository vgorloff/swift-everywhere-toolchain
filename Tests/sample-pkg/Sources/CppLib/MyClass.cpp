//
//  File.cpp
//  
//
//  Created by Vlad Gorlov on 23.11.20.
//

#include "MyClass.hpp"

MyClass::MyClass() {
   std::cout << "[C++] constructor." << std::endl;
}

void MyClass::sayHello() {
   std::cout << "[C++] Hello from C++" << std::endl;
}

MyClass::~MyClass() {
   std::cout << "[C++] destructor." << std::endl;
}
