
current_dir=`pwd`
top_dir=$current_dir
PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib

export ANDROID_NDK=/Users/LayaBox/lvfulong/lib/android-ndk-r10e
PATH="${ANDROID_NDK}/toolchains/x86_64-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
rm -rf android-x86_64
mkdir android-x86_64
cd android-x86_64
tar xvzf ../../libogg-1.3.2.tar.gz
mv libogg-1.3.2 libogg && touch libogg

PREFIX="${top_dir}/contrib/install-android/x86_64"
SDKROOT="${ANDROID_NDK}/platforms/android-21/arch-x86_64"


cd libogg
export CC="x86_64-linux-android-gcc --sysroot=${SDKROOT}"
export CXX="x86_64-linux-android-g++ --sysroot=${SDKROOT}"
export LD="x86_64-linux-android-ld"
export AR="x86_64-linux-android-ar"
export CCAS="x86_64-linux-android-gcc --sysroot=${SDKROOT} -c"
export RANLIB="x86_64-linux-android-ranlib"
export STRIP="x86_64-linux-android-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I{PREFIX}/include -O1 -DNDEBUG"
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I{PREFIX}/include -O1 -DNDEBUG"
export CXXFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I{PREFIX}/include -O1 -DNDEBUG"
#export LDFLAGS=" -L${PREFIX}/lib"
export CHOST=x86_64-linux-android
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I{PREFIX}/include -O1 -DNDEBUG -fPIC"
./configure --prefix=${PREFIX} --build="x86_64-apple-darwin14" --host="i686-linux-android" --target="i686-linux-android" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic


/Applications/Xcode.app/Contents/Developer/usr/bin/make install

cd .. 
tar xvzf ../../libvorbis-1.3.5.tar.gz
mv libvorbis-1.3.5 libvorbis && touch libvorbis

cd libvorbis
export CC="i686-linux-android-gcc --sysroot=${SDKROOT}"
export CXX="i686-linux-android-g++ --sysroot=${SDKROOT}"
export LD="i686-linux-android-ld"
export AR="i686-linux-android-ar"
export CCAS="i686-linux-android-gcc --sysroot=${SDKROOT} -c"
export RANLIB="i686-linux-android-ranlib"
export STRIP="i686-linux-android-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG"
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG"
export CXXFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -fomit-frame-pointer -fstrict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O1 -DNDEBUG"
export LDFLAGS=" -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="x86_64-linux-android" --target="x86_64-linux-android" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic

/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..

##############################################################################################
