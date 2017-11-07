current_dir=`pwd`
top_dir=$current_dir
PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib
export ANDROID_NDK=/Users/layabox_mac/Public/lib/android-ndk-r10e
PATH="${ANDROID_NDK}/toolchains/aarch64-linux-android-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
rm -rf android-arm64
mkdir android-arm64
cd android-arm64
tar xvzf ../../openssl-OpenSSL_1_1_0f.tar.gz
mv openssl-OpenSSL_1_1_0f openssl && touch openssl

PREFIX="${top_dir}/contrib/install-android/arm64"
SDKROOT="${ANDROID_NDK}/platforms/android-21/arch-arm64"

cd openssl

export ANDROID_SYSROOT=${ANDROID_NDK}/platforms/android-21/arch-arm64
export SYSROOT=${ANDROID_SYSROOT}
export NDK_SYSROOT=${ANDROID_SYSROOT}
export ANDROID_NDK_SYSROOT=${ANDROID_SYSROOT}
export CROSS_SYSROOT=${ANDROID_SYSROOT}

export CC="aarch64-linux-android-gcc --sysroot=${SDKROOT}"
export CXX="aarch64-linux-android-g++ --sysroot=${SDKROOT}"
export LD="aarch64-linux-android-ld"
export AR="aarch64-linux-android-ar"
export CCAS="aarch64-linux-android-gcc --sysroot=${SDKROOT} -c"
export RANLIB="aarch64-linux-android-ranlib"
export STRIP="aarch64-linux-android-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export CFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export CXXFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export LDFLAGS=" -no-canonical-prefixes -L${PREFIX}/lib"
./Configure android64-aarch64 --prefix=${PREFIX}  no-shared no-unit-test
/Applications/Xcode.app/Contents/Developer/usr/bin/make install_sw
cd ..


tar xvzf ../../zlib-1.2.8.tar.gz
mv zlib-1.2.8 zlib && touch zlib
cd zlib

export CC="aarch64-linux-android-gcc --sysroot=${SDKROOT}"
export CXX="aarch64-linux-android-g++ --sysroot=${SDKROOT}"
export LD="aarch64-linux-android-ld"
export AR="aarch64-linux-android-ar"
export CCAS="aarch64-linux-android-gcc --sysroot=${SDKROOT} -c"
export RANLIB="aarch64-linux-android-ranlib"
export STRIP="aarch64-linux-android-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -no-canonical-prefixes -L${PREFIX}/lib"
export CHOST=aarch64-linux-android
export CFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
./configure --prefix=${PREFIX} --static
/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ..

CMAKE_TOOLCHAIN_PATH=`pwd`
rm -f toolchain.cmake

echo "set(_CMAKE_TOOLCHAIN_PREFIX aarch64-linux-android-)" >> toolchain.cmake
echo "set(CMAKE_SYSTEM_NAME Linux)" >> toolchain.cmake
echo "set(CMAKE_CXX_SYSROOT_FLAG \"\")" >> toolchain.cmake
echo "set(CMAKE_C_SYSROOT_FLAG \"\")" >> toolchain.cmake
echo "include_directories(${ANDROID_NDK}/sources/cxx-stl/gnu-libstdc++/4.9/include  \
${ANDROID_NDK}/sources/cxx-stl/gnu-libstdc++/4.9/libs/arm64-v8a/include \
${ANDROID_NDK}/sources/cxx-stl/gnu-libstdc++/4.9/include/backward)"  >> toolchain.cmake
echo "set(CMAKE_C_COMPILER aarch64-linux-android-gcc --sysroot=${SDKROOT})" >> toolchain.cmake
echo "set(CMAKE_CXX_COMPILER aarch64-linux-android-g++ --sysroot=${SDKROOT})" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH ${PREFIX})" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)" >> toolchain.cmake


tar xvzf ../../libwebsockets-2.3.0.zip
mv libwebsockets-2.3.0 websockets && touch websockets
cd websockets

export CC="aarch64-linux-android-gcc --sysroot=${SDKROOT}"
export CXX="aarch64-linux-android-g++ --sysroot=${SDKROOT}"
export LD="aarch64-linux-android-ld"
export AR="aarch64-linux-android-ar"
export CCAS="aarch64-linux-android-gcc --sysroot=${SDKROOT} -c"
export RANLIB="aarch64-linux-android-ranlib"
export STRIP="aarch64-linux-android-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -no-canonical-prefixes -L${PREFIX}/lib"
export CFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
cmake . -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_PATH}/toolchain.cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DLWS_WITH_SSL=1 -DLWS_WITHOUT_SERVER=1 -DLWS_WITH_SHARED=0 -DLWS_WITHOUT_TEST_SERVER=1 -DLWS_WITHOUT_TEST_SERVER_EXTPOLL=1 -DLWS_WITHOUT_TEST_PING=1 -DLWS_WITHOUT_TEST_ECHO=1 -DLWS_WITHOUT_TEST_FRAGGLE=1 -DLWS_IPV6=1

/Applications/Xcode.app/Contents/Developer/usr/bin/make VERBOSE=1 install
