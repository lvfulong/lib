current_dir=`pwd`
top_dir=$current_dir
PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib

export ANDROID_NDK=/Users/joychina/Desktop/lvfulong/android-ndk-r10e
PATH="${ANDROID_NDK}/toolchains/x86_64-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
rm -rf android-x86_64
mkdir android-x86_64
cd android-x86_64

PREFIX="${top_dir}/contrib/install-android/x86_64"
SDKROOT="${ANDROID_NDK}/platforms/android-21/arch-x86_64"

tar xvzf ../../jpegsrc.v9b.tar.gz
mv jpeg-9b jpeg && touch jpeg
cd jpeg

export CC="x86_64-linux-android-gcc --sysroot=${SDKROOT}"
export CXX="x86_64-linux-android-g++ --sysroot=${SDKROOT}"
export LD="x86_64-linux-android-ld"
export AR="x86_64-linux-android-ar"
export CCAS="x86_64-linux-android-gcc --sysroot=${SDKROOT} -c"
export RANLIB="x86_64-linux-android-ranlib"
export STRIP="x86_64-linux-android-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG"
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG"
export CXXFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG"
export LDFLAGS=" -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="x86_64-linux-android" --target="x86_64-linux-android" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic

/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..

##############################################################################################
