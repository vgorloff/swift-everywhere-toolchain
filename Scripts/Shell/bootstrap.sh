#!/bin/bash

# Fixes non-critical error message during provisioning. See: https://serverfault.com/a/670688/518519
export DEBIAN_FRONTEND=noninteractive

export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
SA_CMD="apt-get -y update"
echo "Executing command: \"$SA_CMD\""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
$SA_CMD

# Swift dependencies
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
# Z3 dependency (`apt-get install libz3-dev`) temporary removed due compile error `llvm::Twine(Z3_get_error_msg(Context, Error)));`
# See: https://reviews.llvm.org/D54391
SA_CMD="apt-get -y install mc git-lfs ruby clang python autoconf libtool uuid-dev libicu-dev icu-devtools libbsd-dev libedit-dev libxml2-dev libsqlite3-dev swig libpython-dev libncurses5-dev pkg-config libblocksruntime-dev libcurl4-openssl-dev systemtap-sdt-dev tzdata rsync"
echo "Executing command: \"$SA_CMD\""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
$SA_CMD
