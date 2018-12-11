## Sources
export SA_SOURCES_ROOT=/vagrant/Sources

export SA_SOURCES_ROOT_ANDK=$SA_SOURCES_ROOT/android-ndk-r18b
export SA_SOURCES_ROOT_ICU=$SA_SOURCES_ROOT/icu
export SA_SOURCES_ROOT_SWIFT=$SA_SOURCES_ROOT/swift

## Build
export SA_BUILD_ROOT=/vagrant/Build

export SA_BUILD_ROOT_ANDK=$SA_BUILD_ROOT/android-ndk
export SA_BUILD_ROOT_ICU=$SA_BUILD_ROOT/icu
export SA_BUILD_ROOT_SWIFT=$SA_BUILD_ROOT/swift

## Install
export SA_INSTALL_ROOT=/vagrant/Install

export SA_INSTALL_ROOT_ANDK=$SA_INSTALL_ROOT/android-ndk
export SA_INSTALL_ROOT_ICU=$SA_INSTALL_ROOT/icu
export SA_INSTALL_ROOT_SWIFT=$SA_INSTALL_ROOT/swift

## Patches
export SA_PATCHES_ROOT=/vagrant/Patches

export SA_PATCHES_ROOT_ICU=$SA_PATCHES_ROOT/icu

## Projects
export SA_PROJECTS_ROOT=/vagrant/Projects


## Misc
export PATH=$PATH:$SA_SOURCES_ANDK
export RUBYOPT=-W0
