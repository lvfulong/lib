current_dir=`pwd`
top_dir=$current_dir
PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib
export ANDROID_NDK=/Users/layabox_mac/Public/lib/android-ndk-r10e
PATH="${ANDROID_NDK}/toolchains/x86-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
rm -rf android-x86
mkdir android-x86
cd android-x86

PREFIX="${top_dir}/contrib/install-android/x86"
SDKROOT="${ANDROID_NDK}/platforms/android-19/arch-x86"

tar xvzf ../../openssl-OpenSSL_1_1_0f.tar.gz
mv openssl-OpenSSL_1_1_0f openssl && touch openssl

cd openssl

export ANDROID_SYSROOT=${ANDROID_NDK}/platforms/android-19/arch-x86
export SYSROOT=${ANDROID_SYSROOT}
export NDK_SYSROOT=${ANDROID_SYSROOT}
export ANDROID_NDK_SYSROOT=${ANDROID_SYSROOT}
export CROSS_SYSROOT=${ANDROID_SYSROOT}


export CC="i686-linux-android-gcc --sysroot=${SDKROOT}"
export CXX="i686-linux-android-g++ --sysroot=${SDKROOT}"
export LD="i686-linux-android-ld"
export AR="i686-linux-android-ar"
export CCAS="i686-linux-android-gcc --sysroot=${SDKROOT} -c"
export RANLIB="i686-linux-android-ranlib"
export STRIP="i686-linux-android-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG -fPIC"
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG -fPIC"
export CXXFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG -fPIC"
export LDFLAGS=" -L${PREFIX}/lib"
./Configure android-x86 --prefix=${PREFIX}  no-shared no-unit-test

/Applications/Xcode.app/Contents/Developer/usr/bin/make install_sw
cd ..


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
export CPPFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG"
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG"
export CXXFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG"
export LDFLAGS=" -L${PREFIX}/lib"
export CHOST=i686-linux-android
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG -fPIC"
./configure --prefix=${PREFIX} --static
/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ..

tar xvzf ../../curl-7.56.0.tar.gz
mv curl-7.56.0 curl && touch curl
#tar xvzf ../../curl-7.52.1.tar.gz
#mv curl-7.52.1 curl && touch curl
mkdir -p -- ${PREFIX}/share/aclocal && cd curl && autoreconf -fiv -I${PREFIX}/share/aclocal
export CC="i686-linux-android-gcc --sysroot=${SDKROOT}"
export CXX="i686-linux-android-g++ --sysroot=${SDKROOT}"
export LD="i686-linux-android-ld"
export AR="i686-linux-android-ar"
export CCAS="i686-linux-android-gcc --sysroot=${SDKROOT} -c"
export RANLIB="i686-linux-android-ranlib"
export STRIP="i686-linux-android-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG -fPIC"
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG -fPIC"
export CXXFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG -fPIC"
export LDFLAGS=" -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="i686-linux-android" --target="i686-linux-android" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic \
--with-ssl=${PREFIX} \
--with-zlib \
--enable-ipv6 \
--disable-ldap \
--without-libidn --without-librtmp
/Applications/Xcode.app/Contents/Developer/usr/bin/make install
