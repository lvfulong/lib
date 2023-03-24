
current_dir=`pwd`
top_dir=$current_dir
#PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib

export ANDROID_NDK=/Users/joychina/Desktop/lvfulong/android-ndk-r10e
PATH="${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
rm -rf android-arm
mkdir android-arm
cd android-arm

PREFIX="${top_dir}/contrib/install-android/arm"
SDKROOT="${ANDROID_NDK}/platforms/android-14/arch-arm"

tar xvzf ../../jpegsrc.v9b.tar.gz
mv jpeg-9b jpeg && touch jpeg
cd jpeg

export CC="arm-linux-androideabi-gcc --sysroot=${SDKROOT}"
export CXX="arm-linux-androideabi-g++ --sysroot=${SDKROOT}"
export LD="arm-linux-androideabi-ld"
export AR="arm-linux-androideabi-ar"
export CCAS="arm-linux-androideabi-gcc --sysroot=${SDKROOT} -c"
export RANLIB="arm-linux-androideabi-ranlib"
export STRIP="arm-linux-androideabi-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -march=armv5te -mtune=xscale -msoft-float  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -march=armv5te -mtune=xscale -msoft-float  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes  -march=armv5te -mtune=xscale -msoft-float  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="arm-linux-androideabi" --target="arm-linux-androideabi" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic


/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..

##############################################################################################
