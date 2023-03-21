current_dir=`pwd`
top_dir=$current_dir
PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib

export ANDROID_NDK=/Users/joychina/Desktop/lvfulong/android-ndk-r21e
export ANDROID_NDK_ROOT=/Users/joychina/Desktop/lvfulong/android-ndk-r21e
PATH="${ANDROID_NDK}/toolchains/llvm/prebuilt/darwin-x86_64/bin:${ANDROID_NDK}/toolchains/x86_64-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
rm -rf android-x86_64
mkdir android-x86_64
cd android-x86_64

PREFIX="${top_dir}/contrib/install-android/x86_64"
SDKROOT="${ANDROID_NDK}/toolchains/llvm/prebuilt/darwin-x86_64/sysroot"

tar xvzf ../../openssl-3.1.0.tar.gz
mv openssl-3.1.0 openssl && touch openssl

cd openssl

export ANDROID_SYSROOT=${ANDROID_NDK}/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
#export SYSROOT=${ANDROID_SYSROOT}
export NDK_SYSROOT=${ANDROID_SYSROOT}
export ANDROID_NDK_SYSROOT=${ANDROID_SYSROOT}
#export CROSS_SYSROOT=${ANDROID_SYSROOT}


#export CC="x86_64-linux-android-gcc --sysroot=${SDKROOT}"
#export CXX="x86_64-linux-android-g++ --sysroot=${SDKROOT}"
#export LD="x86_64-linux-android-ld"
#export AR="x86_64-linux-android-ar"
#export CCAS="x86_64-linux-android-gcc --sysroot=${SDKROOT} -c"
##export RANLIB="x86_64-linux-android-ranlib"
#export STRIP="x86_64-linux-android-strip"
#export PATH="${PREFIX}/bin:${PATH}"
#export CPPFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG -fPIC"
#export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG -fPIC"
#export CXXFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG -fPIC"
#export LDFLAGS=" -L${PREFIX}/lib"
./Configure android-x86_64 -m64 -D__ANDROID_API__=21 --prefix=${PREFIX}  no-shared no-unit-test
#/Applications/Xcode.app/Contents/Developer/usr/bin/make
/Applications/Xcode.app/Contents/Developer/usr/bin/make install_sw
cd ..


tar xvzf ../../zlib-1.2.8.tar.gz
mv zlib-1.2.8 zlib && touch zlib
cd zlib

export CC="x86_64-linux-android-gcc --sysroot=${SDKROOT}"
export CXX="x86_64-linux-android-g++ --sysroot=${SDKROOT}"
export LD="x86_64-linux-android-ld"
export AR="x86_64-linux-android-ar"
export CCAS="x86_64-linux-android-gcc --sysroot=${SDKROOT} -c"
export RANLIB="x86_64-linux-android-ranlib"
export STRIP="x86_64-linux-android-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG"
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG"
export CXXFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG"
export LDFLAGS=" -L${PREFIX}/lib"
export CHOST=x86_64-linux-android
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG -fPIC"
./configure --prefix=${PREFIX} --static
/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ..

tar xvzf ../../curl-7.56.0.tar.gz
mv curl-7.56.0 curl && touch curl
#tar xvzf ../../curl-7.52.1.tar.gz
#mv curl-7.52.1 curl && touch curl
mkdir -p -- ${PREFIX}/share/aclocal && cd curl && autoreconf -fiv -I${PREFIX}/share/aclocal
export CC="x86_64-linux-android-gcc --sysroot=${SDKROOT}"
export CXX="x86_64-linux-android-g++ --sysroot=${SDKROOT}"
export LD="x86_64-linux-android-ld"
export AR="x86_64-linux-android-ar"
export CCAS="x86_64-linux-android-gcc --sysroot=${SDKROOT} -c"
export RANLIB="x86_64-linux-android-ranlib"
export STRIP="x86_64-linux-android-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG -fPIC"
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG -fPIC"
export CXXFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG -fPIC"
export LDFLAGS=" -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="x86_64-linux-android" --target="x86_64-linux-android" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic \
--with-ssl=${PREFIX} \
--with-zlib \
--enable-ipv6 \
--disable-ldap \
--without-libidn --without-librtmp
/Applications/Xcode.app/Contents/Developer/usr/bin/make install
