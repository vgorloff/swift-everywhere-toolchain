#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
import Darwin
#elseif os(Windows)
import MSVCRT
#else
import Glibc
#endif

func test() {

   tolower(5) // sysroot/usr/include/ctype.h
   fesetround(6) // sysroot/usr/include/fenv.h
   localeconv() // sysroot/usr/include/locale.h
   #if os(Android)
   isnan(7) // sysroot/usr/include/math.h
   #endif

   //> sysroot/usr/include/stdio.h
   _ = off_t()
   _ = FILE()
   // _ = __sFILE()
   clearerr(nil)
   fclose(nil)
   //<

   #if os(Android)
   _ = __ANDROID_API_Q__ // sysroot/usr/include/android/api-level.h
   #endif

   let file: UnsafeMutablePointer<FILE>? = nil
   _ = file
}
