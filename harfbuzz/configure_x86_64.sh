
current_dir=`pwd`
top_dir=$current_dir
PATH="${current_dir}/..:${PATH}"
#export PATH

#rm -rf  Contrib
mkdir Contrib
cd Contrib

SDK_VERSION=$(xcodebuild -showsdks | grep iphoneos | sort | tail -n 1 | awk '{print substr($NF,9)}')

##############################################################################################
rm -rf ios-x86_64
mkdir ios-x86_64
cd ios-x86_64

PREFIX="${top_dir}/contrib/install-ios/x86_64"
IOS_PLATFORM=Simulator
SDKROOT=`xcode-select -print-path`/Platforms/iPhone${IOS_PLATFORM}.platform/Developer/SDKs/iPhone${IOS_PLATFORM}${SDK_VERSION}.sdk

cd harfbuzz-2.6.4
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

