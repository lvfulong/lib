cd Contrib
ARCH="x86_64"
mkdir -p build-$ARCH && cd build-$ARCH

DEVELOPER="$(xcode-select --print-path)"
SDKROOT="$(xcodebuild -version -sdk iphonesimulator | grep -E '^Path' | sed 's/Path: //')"


ICU_PATH="$(pwd)/../icu4c-65_1-src/icu"
ICU_FLAGS="-I$ICU_PATH/source/common/ -I$ICU_PATH/source/tools/tzcode/ "

export CXX="$DEVELOPER/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"
export CC="$DEVELOPER/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
export CFLAGS="-isysroot $SDKROOT -I$SDKROOT/usr/include/ -I./include/ -arch $ARCH -miphoneos-version-min=7.0 $ICU_FLAGS"
export CXXFLAGS="-stdlib=libc++ -std=c++11 -isysroot $SDKROOT -I$SDKROOT/usr/include/ -I./include/ -arch $ARCH -miphoneos-version-min=7.0 $ICU_FLAGS"
export LDFLAGS="-stdlib=libc++ -L$SDKROOT/usr/lib/ -isysroot $SDKROOT -Wl,-dead_strip -miphoneos-version-min=7.0 -lstdc++"



[ -e Makefile ] && make distclean

sh $ICU_PATH/source/configure --host=i686-apple-darwin11 --enable-static --disable-shared -with-cross-build=$ICU_PATH/../../build-host
