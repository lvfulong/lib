current_dir=`pwd`
top_dir=$current_dir
PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib

export ANDROID_NDK=/Users/helloworldlv/Downloads/android-ndk-r10e
PATH="${ANDROID_NDK}/toolchains/x86-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
rm -rf android-x86
mkdir android-x86
cd android-x86

PREFIX="${top_dir}/contrib/install-android/x86"
SDKROOT="${ANDROID_NDK}/platforms/android-21/arch-x86"

tar xvzf ../../zlib-1.2.8.tar.gz
mv zlib-1.2.8 zlib && touch zlib

cd zlib
export CC="i686-linux-android-gcc --sysroot=${SDKROOT}"
export CXX="i686-linux-android-g++ --sysroot=${SDKROOT}"
export LD="i686-linux-android-ld"
export AR="i686-linux-android-ar"
export CCAS="i686-linux-android-gcc --sysroot=${SDKROOT} -c"
export RANLIB="i686-linux-android-ranlib"
export STRIP="i686-linux-android-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I{PREFIX}/include -O1 -DNDEBUG"
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I{PREFIX}/include -O1 -DNDEBUG"
export CXXFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I{PREFIX}/include -O1 -DNDEBUG"
export LDFLAGS=" -L${PREFIX}/lib"
export CHOST=i686-linux-android
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I{PREFIX}/include -O1 -DNDEBUG -fPIC"
./configure --prefix=${PREFIX} --static

/Applications/Xcode.app/Contents/Developer/usr/bin/make install

cd .. 

CMAKE_TOOLCHAIN_PATH=`pwd`
echo "set(_CMAKE_TOOLCHAIN_PREFIX i686-linux-android-)" >> toolchain.cmake
echo "set(CMAKE_SYSTEM_NAME Linux)" >> toolchain.cmake
echo "set(CMAKE_CXX_SYSROOT_FLAG \"\")" >> toolchain.cmake
echo "set(CMAKE_C_SYSROOT_FLAG \"\")" >> toolchain.cmake
echo "include_directories(${ANDROID_NDK}/sources/cxx-stl/gnu-libstdc++/4.9/include  \
${ANDROID_NDK}/sources/cxx-stl/gnu-libstdc++/4.9/libs/x86/include \
${ANDROID_NDK}/sources/cxx-stl/gnu-libstdc++/4.9/include/backward)"  >> toolchain.cmake
echo "set(CMAKE_C_COMPILER i686-linux-android-gcc --sysroot=${SDKROOT})" >> toolchain.cmake
echo "set(CMAKE_CXX_COMPILER i686-linux-android-g++ --sysroot=${SDKROOT})" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH ${PREFIX})" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)" >> toolchain.cmake

tar xvzf ../../libzip-rel-1-5-2.tar.gz
mv libzip-rel-1-5-2 zip && touch zip
cd zip

export CC="i686-linux-android-gcc --sysroot=${SDKROOT}"
export CXX="i686-linux-android-g++ --sysroot=${SDKROOT}"
export LD="i686-linux-android-ld"
export AR="i686-linux-android-ar"
export CCAS="i686-linux-android-gcc --sysroot=${SDKROOT} -c"
export RANLIB="i686-linux-android-ranlib"
export STRIP="i686-linux-android-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG -DHAVE_CONFIG_H=1"
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG -DHAVE_CONFIG_H=1"
export CXXFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG -DHAVE_CONFIG_H=1"
export LDFLAGS=" -L${PREFIX}/lib"
cmake . -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_PATH}/toolchain.cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_SHARED_LIBS=OFF

/Applications/Xcode.app/Contents/Developer/usr/bin/make VERBOSE=1 install
cd ../..

##############################################################################################
