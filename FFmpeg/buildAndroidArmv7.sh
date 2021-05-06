
current_dir=`pwd`
top_dir=$current_dir
#PATH="${current_dir}/..:${PATH}"
mkdir Contrib
cd Contrib

##############################################################################################
rm -rf android-armv7
mkdir android-armv7
cd android-armv7

PREFIX="${top_dir}/contrib/install-android/armv7"
SDKROOT="${ANDROID_NDK}/platforms/android-14/arch-arm"

tar xvzf ../../FFmpeg-n3.0.zip
mv FFmpeg-n3.0 FFmpeg && touch FFmpeg
cd FFmpeg

# 修改为自己NDK包根目录
export NDK_HOME=/Users/LayaBox/lvfulong/lib/android-ndk-r10e
#根据自己的需求修改编译平台版本
export PLATFORM_VERSION=android-14
#定义编译方法
function build
{
    #echo 输出命令
    echo "start build ffmpeg for $ARCH"
    #调用configure命令开始编译，并传入对应的参数
    ./configure --target-os=linux \
    --prefix=$PREFIX --arch=$ARCH \
    --disable-doc \
    --disable-static \
    --disable-yasm \
    --disable-asm \
    --disable-symver \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-ffserver \
    --cross-prefix=$CROSS_COMPILE \
    --enable-cross-compile \
    --enable-shared \
    --enable-gpl \
    --sysroot=$SYSROOT \
    --enable-small \
    --extra-cflags="-Os -fpic $ADDI_CFLAGS" \
    --extra-ldflags="$ADDI_LDFLAGS" \
    $ADDITIONAL_CONFIGURE_FLAG
    make clean
    make
    make install
    echo "build ffmpeg for $ARCH finished"
}

#编译 arm-v7a
PLATFORM_VERSION=android-21
ARCH=arm
CPU=armeabi-v7a #CPU架构
PREFIX=$(pwd)/android_all/$CPU  #输出路径：当前目录/android_all/CPU架构/
TOOLCHAIN=$NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64
CROSS_COMPILE=$TOOLCHAIN/bin/arm-linux-androideabi- #交叉编译环境路径
ADDI_CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -mthumb -mfpu=neon"
ADDI_LDFLAGS="-march=armv7-a -Wl,--fix-cortex-a8"
SYSROOT=$NDK_HOME/platforms/$PLATFORM_VERSION/arch-$ARCH/
build
