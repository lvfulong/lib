
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
tar xvzf ../../libogg-1.3.2.tar.gz
mv libogg-1.3.2 libogg && touch libogg

PREFIX="${top_dir}/contrib/install-ios/armv7"
IOS_PLATFORM=OS
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk


cd libogg
export  CC="xcrun clang"
export  CXX="xcrun clang++" 
export  LD="xcrun ld" 
export  AR="xcrun ar" 
export  CCAS="gas-preprocessor.pl xcrun clang -c" 
export  RANLIB="xcrun ranlib" 
export  STRIP="xcrun strip" 
export  PATH="${PREFIX}/bin:${PATH}" 
export  CPPFLAGS="-isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG"
export  CFLAGS="-isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG"
export  CXXFLAGS="-isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG"
export  LDFLAGS="-L${SDKROOT}/usr/lib -arch armv7 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --build="x86_64-apple-darwin14" --host="arm-apple-darwin" --target="arm-apple-darwin" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic

/Applications/Xcode.app/Contents/Developer/usr/bin/make install


cd .. 
tar xvzf ../../libvorbis-1.3.5.tar.gz
mv libvorbis-1.3.5 libvorbis && touch libvorbis

cd libvorbis


export  CC="xcrun clang"
export  CXX="xcrun clang++" 
export  LD="xcrun ld" 
export  AR="xcrun ar" 
export  CCAS="gas-preprocessor.pl xcrun clang -c" 
export  RANLIB="xcrun ranlib" 
export  STRIP="xcrun strip" 
export  PATH="${PREFIX}/bin:${PATH}" 
export  CPPFLAGS="-isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG"
export  CFLAGS="-isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG"
export  CXXFLAGS="-isysroot ${SDKROOT} -arch armv7 -miphoneos-version-min=8.0 -mcpu=cortex-a8  -I${PREFIX}/include -O3 -DNDEBUG"
export  LDFLAGS="-L${SDKROOT}/usr/lib -arch armv7 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="arm-apple-darwin" --target="arm-apple-darwin" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic

/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..

##############################################################################################
rm -rf ios-arm64
mkdir ios-arm64
cd ios-arm64
tar xvzf ../../libogg-1.3.2.tar.gz
mv libogg-1.3.2 libogg && touch libogg

PREFIX="${top_dir}/contrib/install-ios/arm64"
IOS_PLATFORM=OS
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk

cd libogg
export  CC="xcrun clang" 
export  CXX="xcrun clang++" 
export  LD="xcrun ld" 
export  AR="xcrun ar" 
export  CCAS="gas-preprocessor.pl xcrun clang -c" 
export  RANLIB="xcrun ranlib" 
export  STRIP="xcrun strip" 
export  PATH="${PREFIX}/bin:${PATH}" 
export  CPPFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  CFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  CXXFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  LDFLAGS=" -L${SDKROOT}/usr/lib -arch arm64 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --build="x86_64-apple-darwin14" --host="arm-apple-darwin" --target="arm-apple-darwin" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic



/Applications/Xcode.app/Contents/Developer/usr/bin/make install

cd .. 
tar xvzf ../../libvorbis-1.3.5.tar.gz
mv libvorbis-1.3.5 libvorbis && touch libvorbis

cd libvorbis

export  CC="xcrun clang" 
export  CXX="xcrun clang++" 
export  LD="xcrun ld" 
export  AR="xcrun ar" 
export  CCAS="gas-preprocessor.pl xcrun clang -c" 
export  RANLIB="xcrun ranlib" 
export  STRIP="xcrun strip" 
export  PATH="${PREFIX}/bin:${PATH}" 
export  CPPFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  CFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  CXXFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  LDFLAGS=" -L${SDKROOT}/usr/lib -arch arm64 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="arm-apple-darwin" --target="arm-apple-darwin" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic


/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..
##############################################################################################
rm -rf ios-i386
mkdir ios-i386
cd ios-i386
tar xvzf ../../libogg-1.3.2.tar.gz
mv libogg-1.3.2 libogg && touch libogg

PREFIX="${top_dir}/contrib/install-ios/i386"
IOS_PLATFORM=Simulator
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk

cd libogg
export  CC="xcrun clang" 
export  CXX="xcrun clang++" 
export  LD="xcrun ld" 
export  AR="xcrun ar" 
export  CAS="gas-preprocessor.pl xcrun clang -c" 
export  RANLIB="xcrun ranlib" 
export  STRIP="xcrun strip" 
export  PATH="${PREFIX}/bin:${PATH}"  
export  CPPFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  CFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  CXXFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  LDFLAGS=" -L${SDKROOT}/usr/lib -arch i386 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --build="x86_64-apple-darwin14" --host="i386-apple-darwin" --target="i386-apple-darwin" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic

/Applications/Xcode.app/Contents/Developer/usr/bin/make install

cd .. 
tar xvzf ../../libvorbis-1.3.5.tar.gz
mv libvorbis-1.3.5 libvorbis && touch libvorbis

cd libvorbis

export  CC="xcrun clang" 
export  CXX="xcrun clang++" 
export  LD="xcrun ld" 
export  AR="xcrun ar" 
export  CAS="gas-preprocessor.pl xcrun clang -c" 
export  RANLIB="xcrun ranlib" 
export  STRIP="xcrun strip" 
export  PATH="${PREFIX}/bin:${PATH}"  
export  CPPFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  CFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  CXXFLAGS=" -isysroot ${SDKROOT} -arch i386 -miphoneos-version-min=8.0  -I${PREFIX}/include -O3 -DNDEBUG"
export  LDFLAGS=" -L${SDKROOT}/usr/lib -arch i386 -isysroot ${SDKROOT} -miphoneos-version-min=8.0 -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="i386-apple-darwin" --target="i386-apple-darwin" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic

/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..
##############################################################################################
rm -rf ios-x86_64
mkdir ios-x86_64
cd ios-x86_64
tar xvzf ../../libogg-1.3.2.tar.gz
mv libogg-1.3.2 libogg && touch libogg

PREFIX="${top_dir}/contrib/install-ios/x86_64"
IOS_PLATFORM=Simulator
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk

cd libogg
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
./configure --prefix=${PREFIX} --build="x86_64-apple-darwin14" --host="x86_64-apple-darwin" --target="x86_64-apple-darwin" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic



/Applications/Xcode.app/Contents/Developer/usr/bin/make install

cd .. 
tar xvzf ../../libvorbis-1.3.5.tar.gz
mv libvorbis-1.3.5 libvorbis && touch libvorbis

cd libvorbis

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
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="x86_64-apple-darwin" --target="x86_64-apple-darwin" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic


/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..
##############################################################################################
lipo -create install-ios/armv7/lib/libogg.a install-ios/arm64/lib/libogg.a install-ios/x86_64/lib/libogg.a install-ios/i386/lib/libogg.a -output install-ios/libogg.a
lipo -create install-ios/armv7/lib/libvorbis.a install-ios/arm64/lib/libvorbis.a install-ios/x86_64/lib/libvorbis.a install-ios/i386/lib/libvorbis.a -output install-ios/libvorbis.a
lipo -create install-ios/armv7/lib/libvorbisfile.a install-ios/arm64/lib/libvorbisfile.a install-ios/x86_64/lib/libvorbisfile.a install-ios/i386/lib/libvorbisfile.a -output install-ios/libvorbisfile.a
