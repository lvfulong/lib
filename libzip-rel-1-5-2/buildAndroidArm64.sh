
current_dir=`pwd`
top_dir=$current_dir
#PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib

export ANDROID_NDK=/Users/helloworldlv/Downloads/android-ndk-r10e
PATH="${ANDROID_NDK}/toolchains/aarch64-linux-android-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
rm -rf android-arm64
mkdir android-arm64
cd android-arm64

PREFIX="${top_dir}/contrib/install-android/arm64"
SDKROOT="${ANDROID_NDK}/platforms/android-21/arch-arm64"

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
./configure --prefix=${PREFIX} --static --zprefix
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

tar xvzf ../../libzip-rel-1-5-2.tar.gz
mv libzip-rel-1-5-2 zip && touch zip
cd zip

export CC="aarch64-linux-android-gcc  --sysroot=${SDKROOT}"
export CXX="aarch64-linux-android-g++ --sysroot=${SDKROOT}"
export LD="aarch64-linux-android-ld"
export AR="aarch64-linux-android-ar"
export CCAS="aarch64-linux-android-gcc --sysroot=${SDKROOT} -c"
export RANLIB="aarch64-linux-android-ranlib"
export STRIP="aarch64-linux-android-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export CFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export CXXFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export LDFLAGS=" -no-canonical-prefixes -L${PREFIX}/lib"
cmake . -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_PATH}/toolchain.cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_SHARED_LIBS=OFF

/Applications/Xcode.app/Contents/Developer/usr/bin/make VERBOSE=1 install
cd ../..

##############################################################################################
