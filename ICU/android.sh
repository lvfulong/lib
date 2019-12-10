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
	
cd ..
mkdir x86
cd x86

$ANDROID_NDK/build/tools/make-standalone-toolchain.sh \
    --platform=android-15 \
    --install-dir=$ANDROID_TOOLCHAIN \
    --toolchain=x86-4.9 \
    --llvm-version=3.6

../source/configure --prefix=$(pwd)/prebuilt \
    --host=i686-linux-android \
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
    CFLAGS='-Os -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32' \
    CXXFLAGS='--std=c++11 -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32' \
    CC=i686-linux-android-clang \
    CXX=i686-linux-android-clang++ \
    AR=i686-linux-android-ar \
    RINLIB=i686-linux-android-ranlib \
    --with-data-packaging=static

gnumake install



cd ..
mkdir aarch64
cd aarch64

$ANDROID_NDK/build/tools/make-standalone-toolchain.sh \
    --platform=android-21 \
    --install-dir=$ANDROID_TOOLCHAIN \
    --toolchain=aarch64-linux-android-clang3.6

../source/configure --prefix=$(pwd)/prebuilt \
    --host=aarch64-linux-android \
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
    CFLAGS='-Os' \
    CXXFLAGS='--std=c++11' \
    CC=aarch64-linux-android-clang \
    CXX=aarch64-linux-android-clang++ \
    AR=aarch64-linux-android-ar \
    RINLIB=aarch64-linux-android-ranlib \
    --with-data-packaging=static

gnumake install
