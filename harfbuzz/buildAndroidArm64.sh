
current_dir=`pwd`
top_dir=$current_dir
#PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib

export ANDROID_NDK=/Users/LayaBox/lvfulong/lib/android-ndk-r10e
PATH="${ANDROID_NDK}/toolchains/aarch64-linux-android-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
PNG_PREFIX="${top_dir}/../png/Contrib/install-android/arm64"
ICU_PREFIX="${top_dir}/../ICU/Contrib/install-android/aarch64"
FREETYPE_PREFIX="${top_dir}/../freetype/Contrib/install-android/arm64"
PREFIX="${top_dir}/contrib/install-android/arm64"
SDKROOT="${ANDROID_NDK}/platforms/android-21/arch-arm64"

cd harfbuzz-2.6.4

export ICU_CFLAGS="-I${ICU_PREFIX}/include"
export ICU_LIBS="-L${ICU_PREFIX}/lib"
export FREETYPE_CFLAGS="-I${FREETYPE_PREFIX}/include/freetype2"
export FREETYPE_LIBS="-L${FREETYPE_PREFIX}/lib"
export CC="aarch64-linux-android-gcc  --sysroot=${SDKROOT}"
export CXX="aarch64-linux-android-g++ --sysroot=${SDKROOT}"
export LD="aarch64-linux-android-ld"
export AR="aarch64-linux-android-ar"
export CCAS="aarch64-linux-android-gcc --sysroot=${SDKROOT} -c"
export RANLIB="aarch64-linux-android-ranlib"
export STRIP="aarch64-linux-android-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes  -I${FREETYPE_PREFIX}/include/freetype2 -I${ICU_PREFIX}/include -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export CFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes  -I${FREETYPE_PREFIX}/include/freetype2 -I${ICU_PREFIX}/include -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export CXXFLAGS=" -fpic -ffunction-sections  -funwind-tables  -fstack-protector  -no-canonical-prefixes  -I${FREETYPE_PREFIX}/include/freetype2 -I${ICU_PREFIX}/include -I${PREFIX}/include -O3 -DNDEBUG -DHAVE_CONFIG_H=1"
export LDFLAGS="-lpng -lfreetype -L${PNG_PREFIX}/lib -L${FREETYPE_PREFIX}/lib  -no-canonical-prefixes -L${PREFIX}/lib"

[ -e Makefile ] && make distclean
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="aarch64-linux-android" --target="aarch64-linux-android" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic  --with-icu=no
/Applications/Xcode.app/Contents/Developer/usr/bin/make install


##############################################################################################
