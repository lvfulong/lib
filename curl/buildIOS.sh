
current_dir=`pwd`
top_dir=$current_dir
PATH="${current_dir}/..:${PATH}"
#export PATH

#rm -rf  Contrib
mkdir Contrib
cd Contrib

SDK_VERSION=$(xcodebuild -showsdks | grep iphoneos | sort | tail -n 1 | awk '{print substr($NF,9)}')

rm -rf openssl
mkdir openssl
cd openssl
tar xvzf ../../../OpenSSL-for-iPhone-master.zip
#mv OpenSSL-for-iPhone-master openssl && touch openssl
./OpenSSL-for-iPhone-master/build-libssl.sh --version=1.1.0f --deprecated --targets="ios-sim-cross-x86_64 ios-sim-cross-i386 ios64-cross-arm64 ios-cross-armv7"

cd include
rm -rf opensslconf.h
echo "#ifdef __arm64__">>opensslconf.h
echo "#include \"opensslconf_ios_arm64.h\"">> opensslconf.h
echo "#elif __arm__">> opensslconf.h
echo "#include  \"opensslconf_ios_armv7.h\"">> opensslconf.h
echo "#elif __i386__">> opensslconf.h
echo "#include  \"opensslconf_ios_i386.h\"">> opensslconf.h
echo "#elif __x86_64__">> opensslconf.h
echo "#include  \"opensslconf_ios_x86_64.h\"">> opensslconf.h
echo "#else">> opensslconf.h
echo "#error \"Unsupported architecture!\"">> opensslconf.h
echo "#endif">> opensslconf.h

cp ../bin/opensslconf_ios_armv7.h .
cp ../bin/opensslconf_ios_arm64.h .
cp ../bin/opensslconf_ios_i386.h .
cp ../bin/opensslconf_ios_x86_64.h .

cd ../..
#cd ..


##############################################################################################
rm -rf ios-armv7
mkdir ios-armv7
cd ios-armv7

PREFIX="${top_dir}/contrib/install-ios/armv7"
IOS_PLATFORM=OS
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk

tar xvzf ../../zlib-1.2.8.tar.gz
mv zlib-1.2.8 zlib && touch zlib
cd zlib

export CC="xcrun clang"
export CXX="xcrun clang++"
export LD="xcrun ld"
export AR="xcrun ar"
export CCAS="gas-preprocessor.pl xcrun clang -c"
export RANLIB="xcrun ranlib"
export STRIP="xcrun strip"
export  PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch armv7 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
export CHOST=arm-apple-darwin
export CFLAGS=" -isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG "
./configure --prefix=${PREFIX} --static
/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ..



cp ${top_dir}/Contrib/openssl/bin/iPhoneOS10.3-armv7.sdk/lib/libssl.a ${PREFIX}/lib
cp ${top_dir}/Contrib/openssl/bin/iPhoneOS10.3-armv7.sdk/lib/libcrypto.a ${PREFIX}/lib
mkdir ${PREFIX}/include/openssl
cp  ${top_dir}/Contrib/openssl/include/* ${PREFIX}/include/openssl


tar xvzf ../../curl-7.56.0.tar.gz
mv curl-7.56.0 curl && touch curl
#tar xvzf ../../curl-7.52.1.tar.gz
#mv curl-7.52.1 curl && touch curl
mkdir -p -- ${PREFIX}/share/aclocal&&cd curl&&autoreconf -fiv -I${PREFIX}/share/aclocal

export CC="xcrun clang"
export CXX="xcrun clang++"
export LD="xcrun ld"
export AR="xcrun ar"
export CCAS="gas-preprocessor.pl xcrun clang -c"
export RANLIB="xcrun ranlib"
export STRIP="xcrun strip"
export  PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export CFLAGS=" -isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch armv7 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="arm-apple-darwin" --target="arm-apple-darwin" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic \
--with-ssl=${PREFIX} \
--with-zlib \
--enable-ipv6 \
--disable-ldap
/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..

##############################################################################################
rm -rf ios-arm64
mkdir ios-arm64
cd ios-arm64

PREFIX="${top_dir}/contrib/install-ios/arm64"
IOS_PLATFORM=OS
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk


tar xvzf ../../zlib-1.2.8.tar.gz
mv zlib-1.2.8 zlib && touch zlib
cd zlib
export CC="xcrun clang"
export CXX="xcrun clang++"
export LD="xcrun ld"
export AR="xcrun ar"
export CCAS="gas-preprocessor.pl xcrun clang -c"
export RANLIB="xcrun ranlib"
export STRIP="xcrun strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch arm64 -isysroot ${SDKROOT}-miphoneos-version-min=8.0 -L${PREFIX}/lib"
export CHOST=arm-apple-darwin
export CFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG "
./configure --prefix=${PREFIX} --static
/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ..


cp ${top_dir}/Contrib/openssl/bin/iPhoneOS10.3-arm64.sdk/lib/libssl.a ${PREFIX}/lib
cp ${top_dir}/Contrib/openssl/bin/iPhoneOS10.3-arm64.sdk/lib/libcrypto.a ${PREFIX}/lib
mkdir ${PREFIX}/include/openssl
cp  ${top_dir}/Contrib/openssl/include/* ${PREFIX}/include/openssl


tar xvzf ../../curl-7.56.0.tar.gz
mv curl-7.56.0 curl && touch curl
#tar xvzf ../../curl-7.52.1.tar.gz
#mv curl-7.52.1 curl && touch curl
mkdir -p -- ${PREFIX}/share/aclocal&&cd curl&&autoreconf -fiv -I${PREFIX}/share/aclocal

export CC="xcrun clang"
export CXX="xcrun clang++"
export LD="xcrun ld"
export AR="xcrun ar"
export CCAS="gas-preprocessor.pl xcrun clang -c"
export RANLIB="xcrun ranlib"
export STRIP="xcrun strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export CFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch arm64 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="arm-apple-darwin" --target="arm-apple-darwin" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic \
--with-ssl=${PREFIX} \
--with-zlib \
--enable-ipv6 \
--disable-ldap
/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..
##############################################################################################
rm -rf ios-i386
mkdir ios-i386
cd ios-i386

PREFIX="${top_dir}/contrib/install-ios/i386"
IOS_PLATFORM=Simulator
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk

tar xvzf ../../zlib-1.2.8.tar.gz
mv zlib-1.2.8 zlib && touch zlib
cd zlib
export CC="xcrun clang"
export CXX="xcrun clang++"
export LD="xcrun ld"
export AR="xcrun ar"
export CCAS="gas-preprocessor.pl xcrun clang -c"
export RANLIB="xcrun ranlib"
export STRIP="xcrun strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch i386 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
export CHOST=i386-apple-darwin
export CFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG "
./configure --prefix=${PREFIX} --static
/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ..


cp ${top_dir}/Contrib/openssl/bin/iPhoneSimulator10.3-i386.sdk/lib/libssl.a ${PREFIX}/lib
cp ${top_dir}/Contrib/openssl/bin/iPhoneSimulator10.3-i386.sdk/lib/libcrypto.a ${PREFIX}/lib
mkdir ${PREFIX}/include/openssl
cp  ${top_dir}/Contrib/openssl/include/* ${PREFIX}/include/openssl


tar xvzf ../../curl-7.56.0.tar.gz
mv curl-7.56.0 curl && touch curl
#tar xvzf ../../curl-7.52.1.tar.gz
#mv curl-7.52.1 curl && touch curl
mkdir -p -- ${PREFIX}/share/aclocal&&cd curl&&autoreconf -fiv -I${PREFIX}/share/aclocal

export CC="xcrun clang"
export CXX="xcrun clang++"
export LD="xcrun ld"
export AR="xcrun ar"
export CCAS="gas-preprocessor.pl xcrun clang -c"
export RANLIB="xcrun ranlib"
export STRIP="xcrun strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export CFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch i386 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="i386-apple-darwin" --target="i386-apple-darwin" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic \
--with-ssl=${PREFIX} \
--with-zlib \
--enable-ipv6 \
--disable-ldap
/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..
##############################################################################################
rm -rf ios-x86_64
mkdir ios-x86_64
cd ios-x86_64

PREFIX="${top_dir}/contrib/install-ios/x86_64"
IOS_PLATFORM=Simulator
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk

tar xvzf ../../zlib-1.2.8.tar.gz
mv zlib-1.2.8 zlib && touch zlib
cd zlib
export CC="xcrun clang"
export CXX="xcrun clang++"
export LD="xcrun ld"
export AR="xcrun ar"
export CCAS="gas-preprocessor.pl xcrun clang -c"
export RANLIB="xcrun ranlib"
export STRIP="xcrun strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch x86_64 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
export CHOST=x86_64-apple-darwin
export CFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG "
./configure --prefix=${PREFIX} --static

/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ..


cp ${top_dir}/Contrib/openssl/bin/iPhoneSimulator10.3-x86_64.sdk/lib/libssl.a ${PREFIX}/lib
cp ${top_dir}/Contrib/openssl/bin/iPhoneSimulator10.3-x86_64.sdk/lib/libcrypto.a ${PREFIX}/lib
mkdir ${PREFIX}/include/openssl
cp  ${top_dir}/Contrib/openssl/include/* ${PREFIX}/include/openssl



tar xvzf ../../curl-7.56.0.tar.gz
mv curl-7.56.0 curl && touch curl
#tar xvzf ../../curl-7.52.1.tar.gz
#mv curl-7.52.1 curl && touch curl
mkdir -p -- ${PREFIX}/share/aclocal&&cd curl&&autoreconf -fiv -I${PREFIX}/share/aclocal

export CC="xcrun clang"
export CXX="xcrun clang++"
export LD="xcrun ld"
export AR="xcrun ar"
export CCAS="gas-preprocessor.pl xcrun clang -c"
export RANLIB="xcrun ranlib"
export STRIP="xcrun strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export CFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch x86_64 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="x86_64-apple-darwin" --target="x86_64-apple-darwin" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic \
--with-ssl=${PREFIX} \
--with-zlib \
--enable-ipv6 \
--disable-ldap
/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..

##############################################################################################
lipo -create install-ios/armv7/lib/libz.a install-ios/arm64/lib/libz.a install-ios/x86_64/lib/libz.a install-ios/i386/lib/libz.a -output install-ios/libz.a
lipo -create install-ios/armv7/lib/libcurl.a install-ios/arm64/lib/libcurl.a install-ios/x86_64/lib/libcurl.a install-ios/i386/lib/libcurl.a -output install-ios/libcurl.a
lipo -create install-ios/armv7/lib/libssl.a install-ios/arm64/lib/libssl.a install-ios/x86_64/lib/libssl.a install-ios/i386/lib/libssl.a -output install-ios/libssl.a
lipo -create install-ios/armv7/lib/libcrypto.a install-ios/arm64/lib/libcrypto.a install-ios/x86_64/lib/libcrypto.a install-ios/i386/lib/libcrypto.a -output install-ios/libcrypto.a
