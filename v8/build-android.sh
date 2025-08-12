#!/bin/bash

set -e

# Check if the number of arguments is 1
if [ $# -ne 1 ]; then
    echo "Usage: $0 <architecture>"
    exit 1
fi

# Get the value of the first argument
ARCH="$1"

# Check if the argument value is "arm64", "arm", "x86" or "x64"
if [ "${ARCH}" != "arm64" ] && [ "${ARCH}" != "arm" ] && [ "${ARCH}" != "x64" ] && [ "${ARCH}" != "x86" ]; then
    echo "Architecture must be 'arm64', 'arm', 'x86' or 'x64'"
    exit 1
fi

# If there is 1 argument and its value is "arm64" or "x64", continue with the rest of the script
echo "Valid architecture: ${ARCH}"

# Set v8_enable_pointer_compression based on architecture
if [ "${ARCH}" = "arm64" ] || [ "${ARCH}" = "x64" ]; then
    POINTER_COMPRESSION="true"
    echo "Enabling pointer compression for ${ARCH}"
else
    POINTER_COMPRESSION="false"
    echo "Disabling pointer compression for ${ARCH}"
fi

# Set v8_enable_sandbox based on architecture (64-bit only)
if [ "${ARCH}" = "arm64" ] || [ "${ARCH}" = "x64" ]; then
    ENABLE_SANDBOX="true"
    echo "Enabling sandbox for 64-bit architecture ${ARCH}"
else
    ENABLE_SANDBOX="false"
    echo "Disabling sandbox for 32-bit architecture ${ARCH}"
fi


NDK_ROOT_R28=/home/ubuntu/lfl/android-ndk-r28c

echo "NDK_ROOT_R28=${NDK_ROOT_R28}"

ARGS="target_os=\"android\"
target_cpu=\"${ARCH}\"
v8_target_cpu=\"${ARCH}\"
use_thin_lto=false
use_lld=true
clang_use_chrome_plugins=false
chrome_pgo_phase=0
is_component_build=false
v8_monolithic=true
use_custom_libcxx=false
is_debug=false
v8_use_external_startup_data=false
is_official_build=true
v8_enable_i18n_support=false
treat_warnings_as_errors=false
symbol_level=0
v8_enable_webassembly=true
v8_enable_sandbox=${ENABLE_SANDBOX}
v8_enable_pointer_compression=${POINTER_COMPRESSION}
android_ndk_root=\"${NDK_ROOT_R28}\"
android_ndk_version=\"r28c\"
android32_ndk_api_level=19
android64_ndk_api_level=21
use_custom_libunwind=false
use_ml_inliner=false"


gn gen out/android --args="${ARGS}"

#ninja -C out/android v8_monolith d8 -v
ninja -C out/android v8_monolith