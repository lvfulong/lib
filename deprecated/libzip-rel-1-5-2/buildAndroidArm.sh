
current_dir=`pwd`
top_dir=$current_dir
#PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib

export ANDROID_NDK=/Users/helloworldlv/Downloads/android-ndk-r10e
PATH="${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
rm -rf android-arm
mkdir android-arm
cd android-arm

PREFIX="${top_dir}/contrib/install-android/arm"
SDKROOT="${ANDROID_NDK}/platforms/android-21/arch-arm"

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
export  PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -march=armv5te -mtune=xscale -msoft-float  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -march=armv5te -mtune=xscale -msoft-float  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -march=armv5te -mtune=xscale -msoft-float  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -L${PREFIX}/lib"
export CHOST=arm-linux-androideabi
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -march=armv5te -mtune=xscale -msoft-float  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
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
${ANDROID_NDK}/sources/cxx-stl/gnu-libstdc++/4.9/libs/armeabi/include \
${ANDROID_NDK}/sources/cxx-stl/gnu-libstdc++/4.9/include/backward)"  >> toolchain.cmake
echo "set(CMAKE_C_COMPILER arm-linux-androideabi-gcc --sysroot=${SDKROOT})" >> toolchain.cmake
echo "set(CMAKE_CXX_COMPILER arm-linux-androideabi-g++ --sysroot=${SDKROOT})" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH ${PREFIX})" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)" >> toolchain.cmake

tar xvzf ../../libzip-rel-1-5-2.tar.gz
mv libzip-rel-1-5-2 zip && touch zip
cd zip

export CC="arm-linux-androideabi-gcc --sysroot=${SDKROOT}"
export CXX="arm-linux-androideabi-g++ --sysroot=${SDKROOT}"
export LD="arm-linux-androideabi-ld"
export AR="arm-linux-androideabi-ar"
export CCAS="arm-linux-androideabi-gcc --sysroot=${SDKROOT} -c"
export RANLIB="arm-linux-androideabi-ranlib"
export STRIP="arm-linux-androideabi-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -march=armv5te -mtune=xscale -msoft-float  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -march=armv5te -mtune=xscale -msoft-float  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export CXXFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -march=armv5te -mtune=xscale -msoft-float  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export LDFLAGS=" -L${PREFIX}/lib"
cmake . -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_PATH}/toolchain.cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_SHARED_LIBS=OFF

/Applications/Xcode.app/Contents/Developer/usr/bin/make VERBOSE=1 install
cd ../..

##############################################################################################
