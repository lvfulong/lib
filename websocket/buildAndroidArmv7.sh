current_dir=`pwd`
top_dir=$current_dir
PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib
export ANDROID_NDK=/Users/layabox_mac/Music/lib/android-ndk-r12b
PATH="${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
rm -rf android-armv7
mkdir android-armv7
cd android-armv7
tar xvzf ../../openssl-OpenSSL_1_1_0f.tar.gz
mv openssl-OpenSSL_1_1_0f openssl && touch openssl

PREFIX="${top_dir}/contrib/install-android/armv7"
SDKROOT="${ANDROID_NDK}/platforms/android-14/arch-arm"

cd openssl

export ANDROID_SYSROOT=${ANDROID_NDK}/platforms/android-14/arch-arm
export SYSROOT=${ANDROID_SYSROOT}
export NDK_SYSROOT=${ANDROID_SYSROOT}
export ANDROID_NDK_SYSROOT=${ANDROID_SYSROOT}
export CROSS_SYSROOT=${ANDROID_SYSROOT}


export CC="arm-linux-androideabi-gcc --sysroot=${SDKROOT}"
export CXX="arm-linux-androideabi-g++ --sysroot=${SDKROOT}"
export LD="arm-linux-androideabi-ld"
export AR="arm-linux-androideabi-ar"
export CCAS="arm-linux-androideabi-gcc --sysroot=${SDKROOT} -c"
export RANLIB="arm-linux-androideabi-ranlib"
export STRIP="arm-linux-androideabi-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export CFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export CXXFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export LDFLAGS=" -march=armv7-a -Wl,--fix-cortex-a8 -L${PREFIX}/lib"
./Configure android-armeabi --prefix=${PREFIX}  no-shared no-unit-test
/Applications/Xcode.app/Contents/Developer/usr/bin/make install_sw
cd ..


tar xvzf ../../zlib-1.2.8.tar.gz
mv zlib-1.2.8 zlib && touch zlib
cd zlib

export CC="arm-linux-androideabi-gcc --sysroot=${SDKROOT}"
export CXX="arm-linux-androideabi-g++ --sysroot=${SDKROOT}"
export LD="arm-linux-androideabi-ld"
export AR="arm-linux-androideabi-ar"
export CCAS="arm-linux-androideabi-gcc --sysroot=${SDKROOT} -c"
export RANLIB="arm-linux-androideabi-ranlib"
export STRIP="arm-linux-androideabi-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -march=armv7-a -Wl,--fix-cortex-a8 -L${PREFIX}/lib"
export CHOST=arm-linux-androideabi
export CFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
./configure --prefix=${PREFIX} --static

/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ..

CMAKE_TOOLCHAIN_PATH=`pwd`
rm -f toolchain.cmake
echo "set(_CMAKE_TOOLCHAIN_PREFIX arm-linux-androideabi-)" >> toolchain.cmake
echo "set(CMAKE_SYSTEM_NAME Linux)" >> toolchain.cmake
echo "set(CMAKE_CXX_SYSROOT_FLAG \"\")" >> toolchain.cmake
echo "set(CMAKE_C_SYSROOT_FLAG \"\")" >> toolchain.cmake
echo "include_directories(${ANDROID_NDK}/sources/cxx-stl/gnu-libstdc++/4.9/include  \
${ANDROID_NDK}/sources/cxx-stl/gnu-libstdc++/4.9/libs/armeabi-v7a/include \
${ANDROID_NDK}/sources/cxx-stl/gnu-libstdc++/4.9/include/backward)"  >> toolchain.cmake
echo "set(CMAKE_C_COMPILER arm-linux-androideabi-gcc --sysroot=${SDKROOT})" >> toolchain.cmake
echo "set(CMAKE_CXX_COMPILER arm-linux-androideabi-g++ --sysroot=${SDKROOT})" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH ${PREFIX})" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)" >> toolchain.cmake


tar xvzf ../../libwebsockets-2.3.0.zip
mv libwebsockets-2.3.0 websockets && touch websockets
cd websockets

export CC="arm-linux-androideabi-gcc --sysroot=${SDKROOT}"
export CXX="arm-linux-androideabi-g++ --sysroot=${SDKROOT}"
export LD="arm-linux-androideabi-ld"
export AR="arm-linux-androideabi-ar"
export CCAS="arm-linux-androideabi-gcc --sysroot=${SDKROOT} -c"
export RANLIB="arm-linux-androideabi-ranlib"
export STRIP="arm-linux-androideabi-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -march=armv7-a -Wl,--fix-cortex-a8 -L${PREFIX}/lib"
export CFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
cmake . -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_PATH}/toolchain.cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DLWS_WITH_SSL=1 -DLWS_WITHOUT_SERVER=1 -DLWS_WITH_SHARED=0 -DLWS_WITHOUT_TEST_SERVER=1 -DLWS_WITHOUT_TEST_SERVER_EXTPOLL=1 -DLWS_WITHOUT_TEST_PING=1 -DLWS_WITHOUT_TEST_ECHO=1 -DLWS_WITHOUT_TEST_FRAGGLE=1 -DLWS_IPV6=1

/Applications/Xcode.app/Contents/Developer/usr/bin/make VERBOSE=1 install