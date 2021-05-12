#!/bin/bash

export NDK=/Users/LayaBox/lvfulong/lib/android-ndk-r20b
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64


current_dir=`pwd`
top_dir=$current_dir
#PATH="${current_dir}/..:${PATH}"
rm -rf Contrib
mkdir Contrib
cd Contrib

tar xvzf ../ffmpeg-4.2.4.tar.xz
mv ffmpeg-4.2.4 FFmpeg && touch FFmpeg
cd FFmpeg

function build_android
{

./configure \
--prefix=$PREFIX \
--enable-neon  \
--enable-hwaccels  \
--enable-gpl   \
--disable-postproc \
--disable-debug \
--enable-small \
--enable-jni \
--enable-mediacodec \
--enable-decoder=h264_mediacodec \
--enable-static \
--disable-shared \
--disable-doc \
--enable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-avdevice \
--disable-doc \
--disable-symver \
--cross-prefix=$CROSS_PREFIX \
--target-os=android \
--arch=$ARCH \
--cpu=$CPU \
--cc=$CC \
--cxx=$CXX \
--enable-cross-compile \
--sysroot=$SYSROOT \
--extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS" \
--extra-ldflags="$ADDI_LDFLAGS"

make clean
make -j16
make install

echo "============================ build android arm64-v8a success =========================="

}



#armv7
export TARGET=armv7a-linux-androideabi
ARCH=arm
CPU=armv7-a
API=21
CC=$TOOLCHAIN/bin/$TARGET$API-clang
CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
SYSROOT=$TOOLCHAIN/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
PREFIX=$(pwd)/android/$CPU
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "

build_android

#x86
export TARGET=i686-linux-android
ARCH=x86
CPU=x86
API=21
CC=$TOOLCHAIN/bin/$TARGET$API-clang
CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
SYSROOT=$TOOLCHAIN/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/$TARGET-
PREFIX=$(pwd)/android/$CPU
OPTIMIZE_CFLAGS="-march=$CPU"

#build_android

#arm64-v8a
export TARGET=aarch64-linux-android
ARCH=arm64
CPU=armv8-a
API=21
CC=$TOOLCHAIN/bin/$TARGET$API-clang
CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
SYSROOT=$TOOLCHAIN/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/$TARGET-
PREFIX=$(pwd)/android/$CPU
OPTIMIZE_CFLAGS="-march=$CPU"

#build_android