# Sets the minimum version of CMake required to build your native library.
# This ensures that a certain set of CMake features is available to
# your build.

cmake_minimum_required(VERSION 3.4.1)

project(SwiftNative)

message(STATUS "Setting up project: ${PROJECT_NAME}")
message(STATUS "Android ABI: ${ANDROID_ABI}")

# >>> Configuration section.

if(NOT SA_SWIFT_INSTALL_DIR)
    message(FATAL_ERROR "\"SA_SWIFT_INSTALL_DIR\" variable is not set.\nExpected directory layout \"<SA_SWIFT_INSTALL_DIR>/bin/swift\".")
else()
    set(SA_SWIFT_INSTALL_DIR ${SA_SWIFT_INSTALL_DIR} CACHE FILEPATH "Path to Swift toolchain installation directory.")
endif()

if(NOT SA_NDK_DIR)
    message(FATAL_ERROR "\"SA_NDK_DIR\" variable is not set.\nExpected directory layout \"<SA_NDK_DIR>/ndk-build\".")
else()
    set(SA_NDK_DIR ${SA_NDK_DIR} CACHE FILEPATH "Path to Android NDK directory.")
endif()

if(NOT SA_DISPATCH_INSTALL_DIR)
    message(FATAL_ERROR "\"SA_DISPATCH_INSTALL_DIR\" variable is not set.\nExpected directory layout \"<SA_DISPATCH_INSTALL_DIR>/lib/swift/android/libswiftDispatch.so\".")
else()
    set(SA_DISPATCH_INSTALL_DIR ${SA_DISPATCH_INSTALL_DIR} CACHE FILEPATH "Path to libDispatch installation directory.")
endif()

if(NOT SA_FOUNDATION_INSTALL_DIR)
    message(FATAL_ERROR "\"SA_FOUNDATION_INSTALL_DIR\" variable is not set.\nExpected directory layout \"<SA_FOUNDATION_INSTALL_DIR>/lib/swift/android/libFoundation.so\".")
else()
    set(SA_FOUNDATION_INSTALL_DIR ${SA_FOUNDATION_INSTALL_DIR} CACHE FILEPATH "Path to libFoundation installation directory.")
endif()

if(NOT SA_CURL_INSTALL_DIR)
    message(FATAL_ERROR "\"SA_CURL_INSTALL_DIR\" variable is not set.\nExpected directory layout \"<SA_CURL_INSTALL_DIR>/lib/libcurl.so\".")
else()
    set(SA_CURL_INSTALL_DIR ${SA_CURL_INSTALL_DIR} CACHE FILEPATH "Path to libCURL installation directory.")
endif()

if(NOT SA_ICU_INSTALL_DIR)
    message(FATAL_ERROR "\"SA_ICU_INSTALL_DIR\" variable is not set.\nExpected directory layout \"<SA_ICU_INSTALL_DIR>/lib/libicuucswift.so\".")
else()
    set(SA_ICU_INSTALL_DIR ${SA_ICU_INSTALL_DIR} CACHE FILEPATH "Path to libICU installation directory.")
endif()

if(NOT SA_SSL_INSTALL_DIR)
    message(FATAL_ERROR "\"SA_SSL_INSTALL_DIR\" variable is not set.\nExpected directory layout \"<SA_SSL_INSTALL_DIR>/lib/libssl.so\".")
else()
    set(SA_SSL_INSTALL_DIR ${SA_SSL_INSTALL_DIR} CACHE FILEPATH "Path to libSSL installation directory.")
endif()

if(NOT SA_XML_INSTALL_DIR)
    message(FATAL_ERROR "\"SA_XML_INSTALL_DIR\" variable is not set.\nExpected directory layout \"<SA_XML_INSTALL_DIR>/lib/libxml2.so\".")
else()
    set(SA_XML_INSTALL_DIR ${SA_XML_INSTALL_DIR} CACHE FILEPATH "Path to libXML installation directory.")
endif()

set(SASwiftCompiler "${SA_SWIFT_INSTALL_DIR}/bin/swiftc")
if(EXISTS "${SASwiftCompiler}")
    message(STATUS "Found Swift Compiler: ${SASwiftCompiler}")
else()
    message(FATAL_ERROR "Swift Compiler is not found at path: ${SASwiftCompiler}")
endif()

# <<< Configuration section.

set(SANdkToolchain "${SA_NDK_DIR}/toolchains/llvm/prebuilt/darwin-x86_64")

set(SASwiftFlags "-target" "armv7-none-linux-androideabi")
list(APPEND SASwiftFlags "-v")
list(APPEND SASwiftFlags "-tools-directory" ${SANdkToolchain})
list(APPEND SASwiftFlags "-sdk" "${SA_NDK_DIR}/platforms/${ANDROID_PLATFORM}/arch-arm")
list(APPEND SASwiftFlags "-Xcc" "-I${SANdkToolchain}/sysroot/usr/include" "-Xcc" "-I${SANdkToolchain}/sysroot/usr/include/arm-linux-androideabi")
list(APPEND SASwiftFlags "-Xcc" "-DDEPLOYMENT_TARGET_ANDROID" "-Xcc" "-DDEPLOYMENT_TARGET_LINUX" "-Xcc" "-DDEPLOYMENT_RUNTIME_SWIFT")
list(APPEND SASwiftFlags "-I" "${SA_DISPATCH_INSTALL_DIR}/lib/swift/dispatch")
list(APPEND SASwiftFlags "-I" "${SA_DISPATCH_INSTALL_DIR}/lib/swift/android/armv7")
list(APPEND SASwiftFlags "-I" "${SA_DISPATCH_INSTALL_DIR}/lib/swift")
list(APPEND SASwiftFlags "-I" "${SA_FOUNDATION_INSTALL_DIR}/lib/swift/android/armv7")
list(APPEND SASwiftFlags "-I" "${SA_FOUNDATION_INSTALL_DIR}/lib/swift/CoreFoundation")
list(APPEND SASwiftFlags "-I" "${SA_FOUNDATION_INSTALL_DIR}/lib/swift")
list(APPEND SASwiftFlags "-L" "${SA_NDK_DIR}/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a")
list(APPEND SASwiftFlags "-L" "${SANdkToolchain}/lib/gcc/arm-linux-androideabi/4.9.x")
list(APPEND SASwiftFlags "-L" "${SA_FOUNDATION_INSTALL_DIR}/lib/swift/android")
list(APPEND SASwiftFlags "-L" "${SA_DISPATCH_INSTALL_DIR}/lib/swift/android")
list(APPEND SASwiftFlags "-L" "${SA_SWIFT_INSTALL_DIR}/lib/swift/android")

set(SANativeLibsDir "${CMAKE_CURRENT_SOURCE_DIR}/../../../build/swift/${ANDROID_ABI}")
set(SaLibOutput "${SANativeLibsDir}/libHelloMessages.so")
file(GLOB SALibInput "${CMAKE_CURRENT_SOURCE_DIR}/*.swift")

add_custom_command(
        OUTPUT ${SaLibOutput}
        DEPENDS ${SALibInput}
        COMMAND ${SASwiftCompiler} -emit-library -emit-module -parse-as-library -module-name HelloMessages -Xlinker -soname -Xlinker libHelloMessages.so ${SASwiftFlags} -o ${SaLibOutput} ${SALibInput}
        COMMAND file ${SaLibOutput}
        COMMENT "Building Swift Shared library"
        VERBATIM
)

add_custom_target(SASwiftCompile DEPENDS ${SaLibOutput})

# Copy

set(SaCopyStatus "${CMAKE_CURRENT_BINARY_DIR}/SwiftNative-CopyLins.stamp")

set(SASwiftLibs "")
file(GLOB SwiftLibsTmp "${SA_FOUNDATION_INSTALL_DIR}/lib/swift/android/*.so")
list(APPEND SASwiftLibs ${SwiftLibsTmp})
file(GLOB SwiftLibsTmp "${SA_DISPATCH_INSTALL_DIR}/lib/swift/android/*.so")
list(APPEND SASwiftLibs ${SwiftLibsTmp})
file(GLOB SwiftLibsTmp "${SA_SWIFT_INSTALL_DIR}/lib/swift/android/*.so")
list(APPEND SASwiftLibs ${SwiftLibsTmp})
file(GLOB SwiftLibsTmp "${SA_CURL_INSTALL_DIR}/lib/*.so")
list(APPEND SASwiftLibs ${SwiftLibsTmp})
file(GLOB SwiftLibsTmp "${SA_ICU_INSTALL_DIR}/lib/*.so")
list(APPEND SASwiftLibs ${SwiftLibsTmp})
file(GLOB SwiftLibsTmp "${SA_SSL_INSTALL_DIR}/lib/*.so")
list(APPEND SASwiftLibs ${SwiftLibsTmp})
file(GLOB SwiftLibsTmp "${SA_XML_INSTALL_DIR}/lib/*.so")
list(APPEND SASwiftLibs ${SwiftLibsTmp})
file(GLOB SwiftLibsTmp "${SA_NDK_DIR}/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a/libc++*.so")
list(APPEND SASwiftLibs ${SwiftLibsTmp})

add_custom_command(
        OUTPUT ${SaCopyStatus}
        DEPENDS ${SaLibOutput}
        COMMAND cp -v ${SASwiftLibs} ${SANativeLibsDir}
        COMMAND cmake -E touch ${SaCopyStatus}
        COMMENT "Copying prebuilt libraries"
        VERBATIM
)

add_custom_target(SASwiftCopy DEPENDS ${SaCopyStatus})

# >>> Dependencies

# Also import existing library on Gradle configuration level.
# https://developer.android.com/studio/projects/gradle-external-native-builds#jniLibs

add_library(swift_HelloMessages SHARED IMPORTED)
set_target_properties(swift_HelloMessages PROPERTIES IMPORTED_LOCATION ${SaLibOutput})

# <<<

# Specifies a library name, specifies whether the library is STATIC or
# SHARED, and provides relative paths to the source code. You can
# define multiple libraries by adding multiple add_library() commands,
# and CMake builds them for you. When you build your app, Gradle
# automatically packages shared libraries with your APK.

file(GLOB SABridgeLibSources "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp")

add_library(SABridge SHARED ${SABridgeLibSources})
add_dependencies(SABridge SASwiftCompile SASwiftCopy)
target_link_libraries(SABridge swift_HelloMessages)
