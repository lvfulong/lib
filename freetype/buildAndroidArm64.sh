
current_dir=`pwd`
top_dir=$current_dir
PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib

export ANDROID_NDK=/Users/LayaBox/lvfulong/lib/android-ndk-r10e
PATH="${ANDROID_NDK}/toolchains/aarch64-linux-android-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
rm -rf android-arm64
mkdir android-arm64
cd android-arm64
tar xvzf ../../zlib-1.2.8.tar.gz
mv zlib-1.2.8 zlib && touch zlib

PREFIX="${top_dir}/contrib/install-android/arm64"
SDKROOT="${ANDROID_NDK}/platforms/android-21/arch-arm64"


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
export CHOST=aarch64-linux-android CFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
./configure --prefix=${PREFIX} --static

/Applications/Xcode.app/Contents/Developer/usr/bin/make install

cd .. 
tar xvzf ../../freetype-2.8.1.tar.gz
mv freetype-2.8.1 freetype && touch freetype
cd freetype


export GNUMAKE=/Applications/Xcode.app/Contents/Developer/usr/bin/make
export CC="aarch64-linux-android-gcc --sysroot=${SDKROOT}"
export CXX="aarch64-linux-android-g++ --sysroot=${SDKROOT}"
export LD="aarch64-linux-android-ld"
export AR="aarch64-linux-android-ar"
export CCAS="aarch64-linux-android-gcc --sysroot=${SDKROOT} -c"
export RANLIB="aarch64-linux-android-ranlib" STRIP="aarch64-linux-android-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -no-canonical-prefixes -L${PREFIX}/lib"
./configure --with-harfbuzz=no --with-zlib=yes --without-png --with-bzip2=no --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="aarch64-linux-android" --target="aarch64-linux-android" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic

/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..

##############################################################################################
