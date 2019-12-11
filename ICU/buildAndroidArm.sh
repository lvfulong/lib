
current_dir=`pwd`
top_dir=$current_dir
#PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib

ARCH="arm"
#mkdir -p build-$ARCH && cd build-$ARCH
DEVELOPER="$(xcode-select --print-path)"
SDKROOT="$(xcodebuild -version -sdk iphoneos | grep -E '^Path' | sed 's/Path: //')"

export ANDROID_NDK=/Users/LayaBox/lvfulong/lib/android-ndk-r10e
PATH="${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
rm -rf android-arm
mkdir android-arm
cd android-arm

PREFIX="${top_dir}/contrib/install-android/arm"
SDKROOT="${ANDROID_NDK}/platforms/android-14/arch-arm"

ICU_PATH="$(pwd)/../../icu"
ICU_FLAGS="-I$ICU_PATH/source/common/ -I$ICU_PATH/source/tools/tzcode/ "

export CXX="$DEVELOPER/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"
export CC="$DEVELOPER/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"

#export CC="arm-linux-androideabi-gcc --sysroot=${SDKROOT}"
#export CXX="arm-linux-androideabi-g++ --sysroot=${SDKROOT}"
#export LD="arm-linux-androideabi-ld"
#export AR="arm-linux-androideabi-ar"
#export CCAS="arm-linux-androideabi-gcc --sysroot=${SDKROOT} -c"
#export RANLIB="arm-linux-androideabi-ranlib"
#export STRIP="arm-linux-androideabi-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes   -mtune=xscale -msoft-float  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 $ICU_FLAGS -DNDEBUG"
export CFLAGS="-isysroot $SDKROOT -I$SDKROOT/usr/include/ -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -mtune=xscale -msoft-float  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 $ICU_FLAGS -DNDEBUG"
export CXXFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes   -mtune=xscale -msoft-float  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 $ICU_FLAGS -DNDEBUG -std=c++11 -stdlib=libc++"
export LDFLAGS=" -stdlib=libc++ -L$SDKROOT/usr/lib/ -isysroot $SDKROOT -Wl,-dead_strip -lstdc++"

[ -e Makefile ] && make distclean
sh $ICU_PATH/source/configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib"  --host="arm-linux-androideabi" --program-prefix="" --enable-static --disable-shared -with-cross-build=$ICU_PATH/../build-host


/Applications/Xcode.app/Contents/Developer/usr/bin/make install


##############################################################################################
