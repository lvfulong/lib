
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
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=6.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=6.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=6.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch armv7 -isysroot ${SDKROOT} -miphoneos-version-min=6.0 -L${PREFIX}/lib"
export CHOST=arm-apple-darwin
export CFLAGS=" -isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=6.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG "
./configure --prefix=${PREFIX} --static
/Applications/Xcode.app/Contents/Developer/usr/bin/make install

cd ..

CMAKE_TOOLCHAIN_PATH=`pwd`
rm -f toolchain.cmake
echo "set(CMAKE_SYSTEM_NAME Darwin)" >> toolchain.cmake
echo "set(CMAKE_C_FLAGS  -isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=6.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG)" >> toolchain.cmake
echo "set(CMAKE_CXX_FLAGS  -isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=6.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG)" >> toolchain.cmake
echo "set(CMAKE_LD_FLAGS  -L${SDKROOT}/usr/lib -arch armv7 -isysroot ${SDKROOT} -miphoneos-version-min=6.0 -L${PREFIX}/lib)" >> toolchain.cmake
echo "set(CMAKE_AR ar CACHE FILEPATH "Archiver")" >> toolchain.cmake
echo "set(CMAKE_OSX_SYSROOT ${SDKROOT})" >> toolchain.cmake
echo "set(_CMAKE_TOOLCHAIN_PREFIX arm-apple-darwin-)" >> toolchain.cmake
echo "set(CMAKE_C_COMPILER xcrun clang)" >> toolchain.cmake
echo "set(CMAKE_CXX_COMPILER xcrun clang++)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH ${PREFIX})" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)" >> toolchain.cmake

cp ${top_dir}/Contrib/openssl/bin/iPhoneOS10.3-armv7.sdk/lib/libssl.a ${PREFIX}/lib
cp ${top_dir}/Contrib/openssl/bin/iPhoneOS10.3-armv7.sdk/lib/libcrypto.a ${PREFIX}/lib
mkdir ${PREFIX}/include/openssl
cp  ${top_dir}/Contrib/openssl/include/* ${PREFIX}/include/openssl

tar xvzf ../../libwebsockets-2.3.0.zip
mv libwebsockets-2.3.0 websockets && touch websockets
cd websockets

export CC="xcrun clang"
export CXX="xcrun clang++"
export LD="xcrun ld"
export AR="xcrun ar"
export CCAS="gas-preprocessor.pl xcrun clang -c"
export RANLIB="xcrun ranlib"
export STRIP="xcrun strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=6.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -isysroot ${SDKROOT}  -arch armv7 -miphoneos-version-min=6.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=6.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch armv7 -isysroot ${SDKROOT} -miphoneos-version-min=6.0 -L${PREFIX}/lib"
export CFLAGS=" -isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=6.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG "
cmake . -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_PATH}/toolchain.cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DLWS_WITH_SSL=1 -DLWS_WITHOUT_SERVER=1 -DLWS_WITH_SHARED=0 -DLWS_WITHOUT_TEST_SERVER=1 -DLWS_WITHOUT_TEST_SERVER_EXTPOLL=1 -DLWS_WITHOUT_TEST_PING=1 -DLWS_WITHOUT_TEST_ECHO=1 -DLWS_WITHOUT_TEST_FRAGGLE=1 -DLWS_IPV6=1
/Applications/Xcode.app/Contents/Developer/usr/bin/make VERBOSE=1 install

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
export CPPFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch arm64 -isysroot ${SDKROOT} -miphoneos-version-min=6.0 -L${PREFIX}/lib"
export CHOST=arm-apple-darwin
export CFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG "
./configure --prefix=${PREFIX} --static
/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ..


CMAKE_TOOLCHAIN_PATH=`pwd`
rm -f toolchain.cmake
echo "set(CMAKE_SYSTEM_NAME Darwin)" >> toolchain.cmake
echo "set(CMAKE_C_FLAGS  -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG)" >> toolchain.cmake
echo "set(CMAKE_CXX_FLAGS  -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG)" >> toolchain.cmake
echo "set(CMAKE_LD_FLAGS  -L${SDKROOT}/usr/lib -arch arm64 -isysroot ${SDKROOT} -miphoneos-version-min=6.0 -L${PREFIX}/lib)" >> toolchain.cmake
echo "set(CMAKE_AR ar CACHE FILEPATH "Archiver")" >> toolchain.cmake
echo "set(CMAKE_OSX_SYSROOT ${SDKROOT})" >> toolchain.cmake
echo "set(_CMAKE_TOOLCHAIN_PREFIX arm-apple-darwin-)" >> toolchain.cmake
echo "set(CMAKE_C_COMPILER xcrun clang)" >> toolchain.cmake
echo "set(CMAKE_CXX_COMPILER xcrun clang++)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH ${PREFIX})" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)" >> toolchain.cmake


cp ${top_dir}/Contrib/openssl/bin/iPhoneOS10.3-arm64.sdk/lib/libssl.a ${PREFIX}/lib
cp ${top_dir}/Contrib/openssl/bin/iPhoneOS10.3-arm64.sdk/lib/libcrypto.a ${PREFIX}/lib
mkdir ${PREFIX}/include/openssl
cp  ${top_dir}/Contrib/openssl/include/* ${PREFIX}/include/openssl

tar xvzf ../../libwebsockets-2.3.0.zip
mv libwebsockets-2.3.0 websockets && touch websockets
cd websockets

export CC="xcrun clang"
export CXX="xcrun clang++"
export LD="xcrun ld"
export AR="xcrun ar"
export CCAS="gas-preprocessor.pl xcrun clang -c"
export RANLIB="xcrun ranlib"
export STRIP="xcrun strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch arm64 -isysroot ${SDKROOT} -miphoneos-version-min=6.0 -L${PREFIX}/lib"
export CFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG "
cmake . -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_PATH}/toolchain.cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DLWS_WITH_SSL=1 -DLWS_WITHOUT_SERVER=1 -DLWS_WITH_SHARED=0 -DLWS_WITHOUT_TEST_SERVER=1 -DLWS_WITHOUT_TEST_SERVER_EXTPOLL=1 -DLWS_WITHOUT_TEST_PING=1 -DLWS_WITHOUT_TEST_ECHO=1 -DLWS_WITHOUT_TEST_FRAGGLE=1 -DLWS_IPV6=1
/Applications/Xcode.app/Contents/Developer/usr/bin/make VERBOSE=1 install

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
export CPPFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch i386 -isysroot ${SDKROOT} -miphoneos-version-min=6.0 -L${PREFIX}/lib"
export CHOST=i386-apple-darwin
export CFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG "
./configure --prefix=${PREFIX} --static

/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ..


CMAKE_TOOLCHAIN_PATH=`pwd`
rm -f toolchain.cmake
echo "set(CMAKE_SYSTEM_NAME Darwin)" >> toolchain.cmake
echo "set(CMAKE_C_FLAGS  -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG)" >> toolchain.cmake
echo "set(CMAKE_CXX_FLAGS  -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG)" >> toolchain.cmake
echo "set(CMAKE_LD_FLAGS  -L${SDKROOT}/usr/lib -arch i386 -isysroot ${SDKROOT} -miphoneos-version-min=6.0 -L${PREFIX}/lib)" >> toolchain.cmake
echo "set(CMAKE_AR ar CACHE FILEPATH "Archiver")" >> toolchain.cmake
echo "set(CMAKE_OSX_SYSROOT ${SDKROOT})" >> toolchain.cmake
echo "set(_CMAKE_TOOLCHAIN_PREFIX i386-apple-darwin-)" >> toolchain.cmake
echo "set(CMAKE_C_COMPILER xcrun clang)" >> toolchain.cmake
echo "set(CMAKE_CXX_COMPILER xcrun clang++)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH ${PREFIX})" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)" >> toolchain.cmake


cp ${top_dir}/Contrib/openssl/bin/iPhoneSimulator10.3-i386.sdk/lib/libssl.a ${PREFIX}/lib
cp ${top_dir}/Contrib/openssl/bin/iPhoneSimulator10.3-i386.sdk/lib/libcrypto.a ${PREFIX}/lib
mkdir ${PREFIX}/include/openssl
cp  ${top_dir}/Contrib/openssl/include/* ${PREFIX}/include/openssl

tar xvzf ../../libwebsockets-2.3.0.zip
mv libwebsockets-2.3.0 websockets && touch websockets
cd websockets

export CC="xcrun clang"
export CXX="xcrun clang++"
export LD="xcrun ld"
export AR="xcrun ar"
export CCAS="gas-preprocessor.pl xcrun clang -c"
export RANLIB="xcrun ranlib"
export STRIP="xcrun strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch i386 -isysroot ${SDKROOT} -miphoneos-version-min=6.0 -L${PREFIX}/lib"
export CFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG "
cmake . -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_PATH}/toolchain.cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DLWS_WITH_SSL=1 -DLWS_WITHOUT_SERVER=1 -DLWS_WITH_SHARED=0 -DLWS_WITHOUT_TEST_SERVER=1 -DLWS_WITHOUT_TEST_SERVER_EXTPOLL=1 -DLWS_WITHOUT_TEST_PING=1 -DLWS_WITHOUT_TEST_ECHO=1 -DLWS_WITHOUT_TEST_FRAGGLE=1 -DLWS_IPV6=1
/Applications/Xcode.app/Contents/Developer/usr/bin/make VERBOSE=1 install
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
export CPPFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch x86_64 -isysroot ${SDKROOT} -miphoneos-version-min=6.0 -L${PREFIX}/lib"
export CHOST=x86_64-apple-darwin
export CFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG "
./configure --prefix=${PREFIX} --static
/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ..


CMAKE_TOOLCHAIN_PATH=`pwd`
rm -f toolchain.cmake
echo "set(CMAKE_SYSTEM_NAME Darwin)" >> toolchain.cmake
echo "set(CMAKE_C_FLAGS  -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG)" >> toolchain.cmake
echo "set(CMAKE_CXX_FLAGS  -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG)" >> toolchain.cmake
echo "set(CMAKE_LD_FLAGS  -L${SDKROOT}/usr/lib -arch x86_64 -isysroot ${SDKROOT} -miphoneos-version-min=6.0 -L${PREFIX}/lib)" >> toolchain.cmake
echo "set(CMAKE_AR ar CACHE FILEPATH "Archiver")" >> toolchain.cmake
echo "set(CMAKE_OSX_SYSROOT ${SDKROOT})" >> toolchain.cmake
echo "set(_CMAKE_TOOLCHAIN_PREFIX x86_64-apple-darwin-)" >> toolchain.cmake
echo "set(CMAKE_C_COMPILER xcrun clang)" >> toolchain.cmake
echo "set(CMAKE_CXX_COMPILER xcrun clang++)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH ${PREFIX})" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)" >> toolchain.cmake
echo "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)" >> toolchain.cmake

cp ${top_dir}/Contrib/openssl/bin/iPhoneSimulator10.3-x86_64.sdk/lib/libssl.a ${PREFIX}/lib
cp ${top_dir}/Contrib/openssl/bin/iPhoneSimulator10.3-x86_64.sdk/lib/libcrypto.a ${PREFIX}/lib
mkdir ${PREFIX}/include/openssl
cp  ${top_dir}/Contrib/openssl/include/* ${PREFIX}/include/openssl

tar xvzf ../../libwebsockets-2.3.0.zip
mv libwebsockets-2.3.0 websockets && touch websockets
cd websockets

export CC="xcrun clang"
export CXX="xcrun clang++"
export LD="xcrun ld"
export AR="xcrun ar"
export CCAS="gas-preprocessor.pl xcrun clang -c"
export RANLIB="xcrun ranlib"
export STRIP="xcrun strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch x86_64 -isysroot ${SDKROOT} -miphoneos-version-min=6.0 -L${PREFIX}/lib"
export CFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=6.0  -I${PREFIX}/include -O3 -DNDEBUG "
cmake . -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_PATH}/toolchain.cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DLWS_WITH_SSL=1 -DLWS_WITHOUT_SERVER=1 -DLWS_WITH_SHARED=0 -DLWS_WITHOUT_TEST_SERVER=1 -DLWS_WITHOUT_TEST_SERVER_EXTPOLL=1 -DLWS_WITHOUT_TEST_PING=1 -DLWS_WITHOUT_TEST_ECHO=1 -DLWS_WITHOUT_TEST_FRAGGLE=1 -DLWS_IPV6=1
/Applications/Xcode.app/Contents/Developer/usr/bin/make VERBOSE=1 install
cd ../..

##############################################################################################
lipo -create install-ios/armv7/lib/libz.a install-ios/arm64/lib/libz.a install-ios/x86_64/lib/libz.a install-ios/i386/lib/libz.a -output install-ios/libz.a
lipo -create install-ios/armv7/lib/libwebsockets.a install-ios/arm64/lib/libwebsockets.a install-ios/x86_64/lib/libwebsockets.a install-ios/i386/lib/libwebsockets.a -output install-ios/libwebsockets.a
lipo -create install-ios/armv7/lib/libssl.a install-ios/arm64/lib/libssl.a install-ios/x86_64/lib/libssl.a install-ios/i386/lib/libssl.a -output install-ios/libssl.a
lipo -create install-ios/armv7/lib/libcrypto.a install-ios/arm64/lib/libcrypto.a install-ios/x86_64/lib/libcrypto.a install-ios/i386/lib/libcrypto.a -output install-ios/libcrypto.a
