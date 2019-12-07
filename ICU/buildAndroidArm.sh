
current_dir=`pwd`
top_dir=$current_dir
#PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib

ARCH="arm"
mkdir -p build-$ARCH && cd build-$ARCH


export ANDROID_NDK=/Users/layabox_mac/Public/lib/android-ndk-r10e
PATH="${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
rm -rf android-arm
mkdir android-arm
cd android-arm

PREFIX="${top_dir}/contrib/install-android/arm"
SDKROOT="${ANDROID_NDK}/platforms/android-14/arch-arm"

ICU_PATH="$(pwd)/../icu4c-65_1-src/icu"
ICU_FLAGS="-I$ICU_PATH/source/common/ -I$ICU_PATH/source/tools/tzcode/ "

export CC="arm-linux-androideabi-gcc --sysroot=${SDKROOT}"
export CXX="arm-linux-androideabi-g++ --sysroot=${SDKROOT}"
export LD="arm-linux-androideabi-ld"
export AR="arm-linux-androideabi-ar"
export CCAS="arm-linux-androideabi-gcc --sysroot=${SDKROOT} -c"
export RANLIB="arm-linux-androideabi-ranlib"
export STRIP="arm-linux-androideabi-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -march=armv5te -mtune=xscale -msoft-float  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 $ICU_FLAGS -DNDEBUG"
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -march=armv5te -mtune=xscale -msoft-float  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 $ICU_FLAGS -DNDEBUG"
export CXXFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -march=armv5te -mtune=xscale -msoft-float  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 $ICU_FLAGS -DNDEBUG"
export LDFLAGS=" -L${PREFIX}/lib"

[ -e Makefile ] && make distclean
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib"  --host="arm-linux-androideabi" --program-prefix="" --enable-static --disable-shared -with-cross-build=$ICU_PATH/../../build-host


/Applications/Xcode.app/Contents/Developer/usr/bin/make install


##############################################################################################
