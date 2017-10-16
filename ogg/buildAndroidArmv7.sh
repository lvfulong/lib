
current_dir=`pwd`
top_dir=$current_dir
PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib

export ANDROID_NDK=/Users/layabox_mac/Music/lib/android-ndk-r12b
PATH="${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
rm -rf android-armv7
mkdir android-armv7
cd android-armv7
tar xvzf ../../libogg-1.3.2.tar.gz
mv libogg-1.3.2 libogg && touch libogg

PREFIX="${top_dir}/contrib/install-android/armv7"
SDKROOT="${ANDROID_NDK}/platforms/android-14/arch-arm"


cd libogg
export CC="arm-linux-androideabi-gcc --sysroot=${SDKROOT}"
export CXX="arm-linux-androideabi-g++ --sysroot=${SDKROOT}"
export LD="arm-linux-androideabi-ld"
export AR="arm-linux-androideabi-ar"
export CCAS="arm-linux-androideabi-gcc --sysroot=${SDKROOT} -c"
export RANLIB="arm-linux-androideabi-ranlib"
export STRIP="arm-linux-androideabi-strip"
export  PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -march=armv7-a -Wl,--fix-cortex-a8 -L${PREFIX}/lib"
export CHOST=arm-linux-androideabi
export CFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG -fPIC"
./configure --prefix=${PREFIX} --build="x86_64-apple-darwin14" --host="arm-linux-androideabi" --target="arm-linux-androideabi" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic


/Applications/Xcode.app/Contents/Developer/usr/bin/make install

cd .. 
tar xvzf ../../libvorbis-1.3.5.tar.gz
mv libvorbis-1.3.5 libvorbis && touch libvorbis

cd libvorbis
export CC="arm-linux-androideabi-gcc --sysroot=${SDKROOT}"
export CXX="arm-linux-androideabi-g++ --sysroot=${SDKROOT}"
export LD="arm-linux-androideabi-ld"
export AR="arm-linux-androideabi-ar"
export CCAS="arm-linux-androideabi-gcc --sysroot=${SDKROOT} -c"
export RANLIB="arm-linux-androideabi-ranlib"
export STRIP="arm-linux-androideabi-strip"
export PATH="${PREFIX}/bin:${PATH}"
export CPPFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export CFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export CXXFLAGS=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp  -mthumb -fomit-frame-pointer -fno-strict-aliasing -DANDROID  -Wa,--noexecstack -Wformat  -I${PREFIX}/include -O3 -DNDEBUG"
export LDFLAGS=" -march=armv7-a -Wl,--fix-cortex-a8 -L${PREFIX}/lib"
./configure --prefix=${PREFIX} --datarootdir="${PREFIX}/share" --includedir="${PREFIX}/include" --libdir="${PREFIX}/lib" --build="x86_64-apple-darwin14" --host="arm-linux-androideabi" --target="arm-linux-androideabi" --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic


/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..

##############################################################################################
