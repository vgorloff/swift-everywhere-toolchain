# Sets the minimum version of CMake required to build your native library.
# This ensures that a certain set of CMake features is available to
# your build.

cmake_minimum_required(VERSION 3.4.1)

project(SwiftNative)

message(STATUS "Setting up project: ${PROJECT_NAME}")
message(STATUS "Android ABI: ${ANDROID_ABI}")

if("${ANDROID_ABI}" STREQUAL "arm64-v8a")
    set(SaNdkPlatform "aarch64-linux-android")
elseif("${ANDROID_ABI}" STREQUAL "x86")
    set(SaNdkPlatform "i686-linux-android")
elseif("${ANDROID_ABI}" STREQUAL "armeabi-v7a")
    set(SaNdkPlatform "arm-linux-androideabi")
elseif("${ANDROID_ABI}" STREQUAL "x86_64")
    set(SaNdkPlatform "x86_64-linux-android")
else()
    message(FATAL_ERROR "Unknown or not supported by Swift toolchain architecture: \"${ANDROID_ABI}\".")
endif()
message(STATUS "Android Tripple: ${SaNdkPlatform}")

# >>> Configuration section.

if(NOT SA_SWIFT_TOOLCHAIN_DIR)
    message(FATAL_ERROR "\"SA_SWIFT_TOOLCHAIN_DIR\" variable is not set.\nExpected directory layout \"<SA_SWIFT_TOOLCHAIN_DIR>/bin/swift\".")
else()
    set(SA_SWIFT_TOOLCHAIN_DIR ${SA_SWIFT_TOOLCHAIN_DIR} CACHE FILEPATH "Path to Swift toolchain installation directory.")
endif()

set(SASwiftCompiler "${SA_SWIFT_TOOLCHAIN_DIR}/bin/swiftc-${SaNdkPlatform}")
set(SASwiftCopyLibs "${SA_SWIFT_TOOLCHAIN_DIR}/bin/copy-libs-${SaNdkPlatform}")

# <<< Configuration section.

set(SANativeLibsDir "${CMAKE_CURRENT_SOURCE_DIR}/../../../build/swift/${ANDROID_ABI}")
set(SaLibOutput "${SANativeLibsDir}/libHelloMessages.so")
file(GLOB SALibInput "${CMAKE_CURRENT_SOURCE_DIR}/*.swift")

add_custom_command(
        OUTPUT ${SaLibOutput}
        DEPENDS ${SALibInput}
        COMMAND ${SASwiftCompiler} -emit-library -emit-module -parse-as-library -module-name HelloMessages -Xlinker -soname -Xlinker libHelloMessages.so -o ${SaLibOutput} ${SALibInput}
        COMMAND file ${SaLibOutput}
        COMMENT "Building Swift Shared library"
        VERBATIM
)

add_custom_target(SASwiftCompile DEPENDS ${SaLibOutput})

# Copy

set(SaCopyStatus "${CMAKE_CURRENT_BINARY_DIR}/SwiftNative-CopyLins.stamp")
add_custom_command(
        OUTPUT ${SaCopyStatus}
        DEPENDS ${SaLibOutput}
        COMMAND ${SASwiftCopyLibs} ${SANativeLibsDir}
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
