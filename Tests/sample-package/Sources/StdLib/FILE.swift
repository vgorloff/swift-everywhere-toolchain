#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
import Darwin
#elseif os(Windows)
import MSVCRT
#else
import Glibc
#endif
import NDKExports

func test() {

   tolower(5) // sysroot/usr/include/ctype.h
   fesetround(6) // sysroot/usr/include/fenv.h
   localeconv() // sysroot/usr/include/locale.h
   #if os(Android)
   isnan(7) // sysroot/usr/include/math.h
   #endif

   #if os(Android)
   _ = __swift_android_get_stdin()
   _ = Glibc.stdin!
   _ = Glibc.stderr!
   _ = Glibc.stdout!
   #endif

   _ = FOPEN_MAX

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
