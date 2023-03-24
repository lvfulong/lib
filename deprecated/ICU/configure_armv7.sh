cd Contrib
ARCH="armv7"
mkdir -p build-$ARCH && cd build-$ARCH


DEVELOPER="$(xcode-select --print-path)"
SDKROOT="$(xcodebuild -version -sdk iphoneos | grep -E '^Path' | sed 's/Path: //')"


ICU_PATH="$(pwd)/../icu4c-65_1-src/icu"
ICU_FLAGS="-I$ICU_PATH/source/common/ -I$ICU_PATH/source/tools/tzcode/ "

export CXX="$DEVELOPER/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"
export CC="$DEVELOPER/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
export CFLAGS="-isysroot $SDKROOT -I$SDKROOT/usr/include/ -I./include/ -arch $ARCH -miphoneos-version-min=8.0 $ICU_FLAGS -DNDEBUG"
export CXXFLAGS="-stdlib=libc++ -std=c++11 -isysroot $SDKROOT -I$SDKROOT/usr/include/ -I./include/ -arch $ARCH -miphoneos-version-min=8.0 $ICU_FLAGS -DNDEBUG"
export LDFLAGS="-stdlib=libc++ -L$SDKROOT/usr/lib/ -isysroot $SDKROOT -Wl,-dead_strip -miphoneos-version-min=8.0 -lstdc++"



[ -e Makefile ] && make distclean
PREFIX="$(pwd)"
sh $ICU_PATH/source/configure --prefix=${PREFIX} --host=arm-apple-darwin --enable-static --disable-shared -with-cross-build=$ICU_PATH/../../build-host
/Applications/Xcode.app/Contents/Developer/usr/bin/make install