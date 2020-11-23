//
//  File.c
//  
//
//  Created by Vlad Gorlov on 23.11.20.
//

#include "CppToC.h"
#include "MyClass.hpp"

void* MyClass_init() {
   return new MyClass();
}

void MyClass_sayHello(void* instance) {
   ((MyClass*)instance)->sayHello();
}

void MyClass_destroy(void* instance) {
   delete ((MyClass*)instance);
}
