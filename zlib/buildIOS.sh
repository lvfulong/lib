
current_dir=`pwd`
top_dir=$current_dir
PATH="${current_dir}/..:${PATH}"
#export PATH

#rm -rf  Contrib
mkdir Contrib
cd Contrib

SDK_VERSION=$(xcodebuild -showsdks | grep iphoneos | sort | tail -n 1 | awk '{print substr($NF,9)}')

##############################################################################################
rm -rf ios-armv7
mkdir ios-armv7
cd ios-armv7
tar xvzf ../../zlib-1.2.8.tar.gz
mv zlib-1.2.8 zlib && touch zlib

PREFIX="${top_dir}/contrib/install-ios/armv7"
IOS_PLATFORM=OS
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk


cd zlib
export  CC="xcrun clang"
export  CXX="xcrun clang++"
export  LD="xcrun ld"
export  AR="xcrun ar"
export  CCAS="gas-preprocessor.pl xcrun clang -c"
export  RANLIB="xcrun ranlib" 
export  STRIP="xcrun strip"
export  PATH="${PREFIX}/bin:${PATH}" 
export  CPPFLAGS="-isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0   -mcpu=cortex-a8 -I${PREFIX}/include -03 -DNDEBUG"
export  CFLAGS="-isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0   -mcpu=cortex-a8 -I${PREFIX}/include -03 -DNDEBUG"
export  CXXFLAGS="-isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0   -mcpu=cortex-a8 -I${PREFIX}/include -03 -DNDEBUG"
export  LDFLAGS="-L${SDKROOT}/usr/lib -arch armv7 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
export  CHOST=arm-apple-darwin
export  CFLAGS="-isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0   -mcpu=cortex-a8 -I${PREFIX}/include -03 -DNDEBUG"
./configure --prefix=${PREFIX} --static --zprefix
/Applications/Xcode.app/Contents/Developer/usr/bin/make install

cd ../..

##############################################################################################
rm -rf ios-arm64
mkdir ios-arm64
cd ios-arm64
tar xvzf ../../zlib-1.2.8.tar.gz
mv zlib-1.2.8 zlib && touch zlib

PREFIX="${top_dir}/contrib/install-ios/arm64"
IOS_PLATFORM=OS
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk

cd zlib
export  CC="xcrun clang"
export  CXX="xcrun clang++" 
export  LD="xcrun ld" 
export  AR="xcrun ar" 
export  CCAS="gas-preprocessor.pl xcrun clang -c" 
export  RANLIB="xcrun ranlib" STRIP="xcrun strip" 
export  PATH="${PREFIX}/bin:${PATH}" 
export  CPPFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  CFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  CXXFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  LDFLAGS=" -L${SDKROOT}/usr/lib -arch arm64 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
export  CHOST=arm-apple-darwin 
export  CFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG "
./configure --prefix=${PREFIX} --static --zprefix

/Applications/Xcode.app/Contents/Developer/usr/bin/make install

cd ../..
##############################################################################################
rm -rf ios-i386
mkdir ios-i386
cd ios-i386
tar xvzf ../../zlib-1.2.8.tar.gz
mv zlib-1.2.8 zlib && touch zlib

PREFIX="${top_dir}/contrib/install-ios/i386"
IOS_PLATFORM=Simulator
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk

cd zlib
export  CC="xcrun clang" 
export  CXX="xcrun clang++" 
export  LD="xcrun ld" 
export  AR="xcrun ar" 
export  CCAS="gas-preprocessor.pl xcrun clang -c" 
export  RANLIB="xcrun ranlib" 
export  STRIP="xcrun strip" 
export  PATH="${PREFIX}/bin:${PATH}" 
export  CPPFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  CFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  CXXFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  LDFLAGS=" -L${SDKROOT}/usr/lib -arch i386 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
export   CHOST=i386-apple-darwin 
export  CFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG "
./configure --prefix=${PREFIX} --static --zprefix
/Applications/Xcode.app/Contents/Developer/usr/bin/make install


cd ../..
##############################################################################################
rm -rf ios-x86_64
mkdir ios-x86_64
cd ios-x86_64
tar xvzf ../../zlib-1.2.8.tar.gz
mv zlib-1.2.8 zlib && touch zlib

PREFIX="${top_dir}/contrib/install-ios/x86_64"
IOS_PLATFORM=Simulator
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk

cd zlib
export CC="xcrun clang"
export CXX="xcrun clang++"
export LD="xcrun ld"
export AR="xcrun ar"
export CCAS="gas-preprocessor.pl xcrun clang -c"
export RANLIB="xcrun ranlib" STRIP="xcrun strip"
export  PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch x86_64 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
export CHOST=x86_64-apple-darwin export
CFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG "
./configure --prefix=${PREFIX} --static --zprefix


/Applications/Xcode.app/Contents/Developer/usr/bin/make install

cd ../..
##############################################################################################
lipo -create install-ios/armv7/lib/libz.a install-ios/arm64/lib/libz.a install-ios/x86_64/lib/libz.a install-ios/i386/lib/libz.a -output install-ios/libz.a
