
current_dir=`pwd`
top_dir=$current_dir
#PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib

export ANDROID_NDK=/Users/LayaBox/lvfulong/lib/android-ndk-r10e
PATH="${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################


PNG_PREFIX="${top_dir}/../png/Contrib/install-android/armv7"
ICU_PREFIX="${top_dir}/../ICU/Contrib/install-android/armv7a"
FREETYPE_PREFIX="${top_dir}/../freetype/Contrib/install-android/armv7"
PREFIX="${top_dir}/contrib/install-android/armv7"
SDKROOT="${ANDROID_NDK}/platforms/android-14/arch-arm"

cd harfbuzz-2.6.4

export ICU_CFLAGS="-I${ICU_PREFIX}/include"
export ICU_LIBS="-L${ICU_PREFIX}/lib"
export FREETYPE_CFLAGS="-I${FREETYPE_PREFIX}/include/freetype2"
export FREETYPE_LIBS="-L${FREETYPE_PREFIX}/lib"
export CC="arm-linux-androideabi-gcc --sysroot=${SDKROOT}"
export CXX="arm-linux-androideabi-g++ --sysroot=${SDKROOT}"
export LD="arm-linux-androideabi-ld"
export AR="arm-linux-androideabi-ar"
export CCAS="arm-linux-androideabi-gcc --sysroot=${SDKROOT} -c"
export RANLIB="arm-linux-androideabi-ranlib"
export STRIP="arm-linux-androideabi-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${FREETYPE_PREFIX}/include/freetype2 -I${ICU_PREFIX}/include -I${PREFIX}/include  -I${SDKROOT}/usr/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export CFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${FREETYPE_PREFIX}/include/freetype2 -I${ICU_PREFIX}/include -I${PREFIX}/include -I${SDKROOT}/usr/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export CXXFLAGS="-march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${FREETYPE_PREFIX}/include/freetype2 -I${ICU_PREFIX}/include -I${PREFIX}/include -I${SDKROOT}/usr/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export LDFLAGS="-lpng -lfreetype -L${PNG_PREFIX}/lib -L${FREETYPE_PREFIX}/lib -L${ICU_PREFIX}/lib  -march=armv7-a -Wl,--fix-cortex-a8 -L${PREFIX}/lib"

[ -e Makefile ] && make distclean
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="arm-linux-androideabi" --target="arm-linux-androideabi" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic --with-libstdc++=yes --with-sysroot="${SDKROOT}"  --with-icu=no


/Applications/Xcode.app/Contents/Developer/usr/bin/make install


##############################################################################################
