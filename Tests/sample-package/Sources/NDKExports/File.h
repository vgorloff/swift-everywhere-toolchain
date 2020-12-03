//
//  File.h
//
//
//  Created by Vlad Gorlov on 30.11.20.
//

#ifndef File_h
#define File_h

#include "/usr/local/ndk/21.3.6528147/sysroot/usr/include/stdio.h"

#if __ANDROID_API__ >= __ANDROID_API_N__
#include <bits/struct_file.h>
#endif

FILE* __swift_android_get_stdin();

#endif /* File_h */
