
current_dir=`pwd`
top_dir=$current_dir
PATH="${current_dir}/..:${PATH}"
#export PATH

#rm -rf  Contrib
mkdir Contrib
cd Contrib

SDK_VERSION=$(xcodebuild -showsdks | grep iphoneos | sort | tail -n 1 | awk '{print substr($NF,9)}')

##############################################################################################
PNG_PREFIX="${top_dir}/../png/Contrib/install-ios/arm64"
ICU_PREFIX="${top_dir}/../ICU/Contrib/build-arm64"
FREETYPE_PREFIX="${top_dir}/../freetype/Contrib/install-ios/arm64"
PREFIX="${top_dir}/contrib/install-ios/arm64"
IOS_PLATFORM=OS
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk

cd harfbuzz-2.6.4

export ICU_CFLAGS="-I${ICU_PREFIX}/include"
export ICU_LIBS="-L${ICU_PREFIX}/lib"
export FREETYPE_CFLAGS="-I${FREETYPE_PREFIX}/include/freetype2"
export FREETYPE_LIBS="-L${FREETYPE_PREFIX}/lib"
export  CC="xcrun clang" 
export  CXX="xcrun clang++" 
export  LD="xcrun ld" 
export  AR="xcrun ar" 
export  CCAS="gas-preprocessor.pl xcrun clang -c" 
export  RANLIB="xcrun ranlib" 
export  STRIP="xcrun strip" 
export  PATH="${PREFIX}/bin:${PATH}" 
export  CPPFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0 -I${FREETYPE_PREFIX}/include/freetype2 -I${ICU_PREFIX}/include -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export  CFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0 -I${FREETYPE_PREFIX}/include/freetype2 -I${ICU_PREFIX}/include -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export  CXXFLAGS=" -isysroot ${SDKROOT} -arch arm64 -miphoneos-version-min=8.0 -I${FREETYPE_PREFIX}/include/freetype2 -I${ICU_PREFIX}/include -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export  LDFLAGS="-lpng -lfreetype -lbz2 -L${PNG_PREFIX}/lib -L${FREETYPE_PREFIX}/lib -L${SDKROOT}/usr/lib -arch arm64 -isysroot ${SDKROOT} -miphoneos-version-min=8.0"

[ -e Makefile ] && make distclean
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="arm-apple-darwin" --target="arm-apple-darwin" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic


/Applications/Xcode.app/Contents/Developer/usr/bin/make install
