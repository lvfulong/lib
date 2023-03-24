current_dir=`pwd`
top_dir=$current_dir
PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib

export ANDROID_NDK=/Users/LayaBox/lvfulong/lib/android-ndk-r10e
PATH="${ANDROID_NDK}/toolchains/x86-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
PNG_PREFIX="${top_dir}/../png/Contrib/install-android/x86"
ICU_PREFIX="${top_dir}/../ICU/Contrib/install-android/x86"
FREETYPE_PREFIX="${top_dir}/../freetype/Contrib/install-android/x86"
PREFIX="${top_dir}/contrib/install-android/x86"
SDKROOT="${ANDROID_NDK}/platforms/android-19/arch-x86"

cd harfbuzz-2.6.4

export ICU_CFLAGS="-I${ICU_PREFIX}/include"
export ICU_LIBS="-L${ICU_PREFIX}/lib"
export FREETYPE_CFLAGS="-I${FREETYPE_PREFIX}/include/freetype2"
export FREETYPE_LIBS="-L${FREETYPE_PREFIX}/lib"
export CC="i686-linux-android-gcc --sysroot=${SDKROOT}"
export CXX="i686-linux-android-g++ --sysroot=${SDKROOT}"
export LD="i686-linux-android-ld"
export AR="i686-linux-android-ar"
export CCAS="i686-linux-android-gcc --sysroot=${SDKROOT} -c"
export RANLIB="i686-linux-android-ranlib"
export STRIP="i686-linux-android-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat -I${FREETYPE_PREFIX}/include/freetype2 -I${ICU_PREFIX}/include -I${PREFIX}/include -O1 -DNDEBUG -DHAVE_CONFIG_H=1"
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${FREETYPE_PREFIX}/include/freetype2 -I${ICU_PREFIX}/include -I${PREFIX}/include -O1 -DNDEBUG -DHAVE_CONFIG_H=1"
export CXXFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${FREETYPE_PREFIX}/include/freetype2 -I${ICU_PREFIX}/include -I${PREFIX}/include -O1 -DNDEBUG -DHAVE_CONFIG_H=1"
export LDFLAGS="-lpng -lfreetype -L${PNG_PREFIX}/lib -L${FREETYPE_PREFIX}/lib -L${ICU_PREFIX}/lib  -L${PREFIX}/lib"

[ -e Makefile ] && make distclean
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="i686-linux-android" --target="i686-linux-android" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic  --with-icu=no

/Applications/Xcode.app/Contents/Developer/usr/bin/make install


##############################################################################################
