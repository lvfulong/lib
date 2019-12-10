mkdir android
cd android
../icu/source/runConfigureICU MacOSX --prefix=`pwd`/prebuilts CFLAGS="-Os" CXXFLAGS="--std=c++11" --enable-static --enable-shared=no --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no --enable-layoutex=no --enable-tools=no --enable-tests=no --enable-samples=no --enable-dyload=no
gnumake


export CROSS_BUILD_DIR=`pwd`/../android
export ANDROID_NDK=/Users/LayaBox/lvfulong/lib/android-ndk-r10e
export ANDROID_TOOLCHAIN=$(pwd)/toolchain
export PATH=$ANDROID_TOOLCHAIN/bin:$PATH


cd ..
mkdir armv7a
cd armv7a


$ANDROID_NDK/build/tools/make-standalone-toolchain.sh \
    --platform=android-14 \
    --install-dir=$ANDROID_TOOLCHAIN \
    --toolchain=arm-linux-androideabi-4.9 \
    --llvm-version=3.6
	
../icu/source/configure --prefix=$(pwd)/prebuilt \
    --host=arm-linux-androideabi \
    --enable-static \
    --enable-shared=no \
    --enable-extras=no \
    --enable-strict=no \
    --enable-icuio=no \
    --enable-layout=no \
    --enable-layoutex=no \
    --enable-tools=no \
    --enable-tests=no \
    --enable-samples=no \
    --enable-dyload=no \
    -with-cross-build=$CROSS_BUILD_DIR \
    CFLAGS='-Os -march=armv7-a -mfloat-abi=softfp -mfpu=neon' \
    CXXFLAGS='--std=c++11 -march=armv7-a -mfloat-abi=softfp -mfpu=neon' \
    LDFLAGS='-march=armv7-a -Wl,--fix-cortex-a8' \
    CC=arm-linux-androideabi-clang \
    CXX=arm-linux-androideabi-clang++ \
    AR=arm-linux-androideabi-ar \
    RINLIB=arm-linux-androideabi-ranlib \
    --with-data-packaging=static
	
	
	gnumake install
