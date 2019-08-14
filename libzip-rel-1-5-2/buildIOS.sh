
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

PREFIX="${top_dir}/contrib/install-ios/armv7"
IOS_PLATFORM=OS
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk


tar xvzf ../../libzip-rel-1-5-2.tar.gz
mv libzip-rel-1-5-2 zip && touch zip

cd zip
export  CC="xcrun clang"
export  CXX="xcrun clang++" 
export  LD="xcrun ld" 
export  AR="xcrun ar" 
export  CCAS="gas-preprocessor.pl xcrun clang -c" 
export  RANLIB="xcrun ranlib" 
export  STRIP="xcrun strip" 
export  PATH="${PREFIX}/bin:${PATH}" 
export  CPPFLAGS="-isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export  CFLAGS="-isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export  CXXFLAGS="-isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export  LDFLAGS="-L${SDKROOT}/usr/lib -arch armv7 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="arm-apple-darwin" --target="arm-apple-darwin" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic

/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..

##############################################################################################
rm -rf ios-arm64
mkdir ios-arm64
cd ios-arm64

PREFIX="${top_dir}/contrib/install-ios/arm64"
IOS_PLATFORM=OS
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk


tar xvzf ../libzip-rel-1-5-2.tar.gz
mv libzip-rel-1-5-2 zip && touch zip

cd zip
export  CC="xcrun clang" 
export  CXX="xcrun clang++" 
export  LD="xcrun ld" 
export  AR="xcrun ar" 
export  CCAS="gas-preprocessor.pl xcrun clang -c" 
export  RANLIB="xcrun ranlib" 
export  STRIP="xcrun strip" 
export  PATH="${PREFIX}/bin:${PATH}" 
export  CPPFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export  CFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export  CXXFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export  LDFLAGS=" -L${SDKROOT}/usr/lib -arch arm64 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="arm-apple-darwin" --target="arm-apple-darwin" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic


/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..
##############################################################################################
rm -rf ios-i386
mkdir ios-i386
cd ios-i386

PREFIX="${top_dir}/contrib/install-ios/i386"
IOS_PLATFORM=Simulator
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk

tar xvzf ../../libzip-rel-1-5-2.tar.gz
mv libzip-rel-1-5-2 zip && touch zip

cd zip
export  CC="xcrun clang" 
export  CXX="xcrun clang++" 
export  LD="xcrun ld" 
export  AR="xcrun ar" 
export  CAS="gas-preprocessor.pl xcrun clang -c" 
export  RANLIB="xcrun ranlib" 
export  STRIP="xcrun strip" 
export  PATH="${PREFIX}/bin:${PATH}"  
export  CPPFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export  CFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export  CXXFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export  LDFLAGS=" -L${SDKROOT}/usr/lib -arch i386 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="i386-apple-darwin" --target="i386-apple-darwin" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic

/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..
##############################################################################################
rm -rf ios-x86_64
mkdir ios-x86_64
cd ios-x86_64

PREFIX="${top_dir}/contrib/install-ios/x86_64"
IOS_PLATFORM=Simulator
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk

tar xvzf ../../libzip-rel-1-5-2.tar.gz
mv libzip-rel-1-5-2 zip && touch zip

cd zip
export CC="xcrun clang"
export CXX="xcrun clang++"
export LD="xcrun ld"
export AR="xcrun ar"
export CCAS="gas-preprocessor.pl xcrun clang -c"
export RANLIB="xcrun ranlib" STRIP="xcrun strip"
export  PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export CFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export CXXFLAGS=" -isysroot ${SDKROOT} -arch x86_64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export LDFLAGS=" -L${SDKROOT}/usr/lib -arch x86_64 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="x86_64-apple-darwin" --target="x86_64-apple-darwin" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic


/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..
##############################################################################################
lipo -create install-ios/armv7/lib/libzip.a install-ios/arm64/lib/libzip.a install-ios/x86_64/lib/libzip.a install-ios/i386/lib/libzip.a -output install-ios/libzip.a
