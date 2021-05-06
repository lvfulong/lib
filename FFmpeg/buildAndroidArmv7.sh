
current_dir=`pwd`
top_dir=$current_dir
#PATH="${current_dir}/..:${PATH}"
export API=14
mkdir Contrib
cd Contrib

export ANDROID_NDK=/Users/layabox_mac/Public/lib/android-ndk-r10e
PATH="${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
rm -rf android-armv7
mkdir android-armv7
cd android-armv7

PREFIX="${top_dir}/contrib/install-android/armv7"
SDKROOT="${ANDROID_NDK}/platforms/android-14/arch-arm"

tar xvzf ../../FFmpeg-n3.0.zip
mv FFmpeg-n3.0 FFmpeg && touch FFmpeg
cd FFmpeg

HOST="arm-linux-androideabi"
ANDROID_SYSROOT="${ANDROID_NDK}"/toolchains/llvm/prebuilt/"${TOOLCHAIN}"/sysroot
HOST_PKG_CONFIG_PATH=$(command -v pkg-config)
if [ -z "${HOST_PKG_CONFIG_PATH}" ]; then
  echo -e "\n(*) pkg-config command not found\n"
  exit 1
fi

  TARGET_CPU="armv7-a"
  TARGET_ARCH="armv7-a"
  ASM_OPTIONS=" --disable-neon --enable-asm --enable-inline-asm"
  # ALWAYS BUILD SHARED LIBRARIES
BUILD_LIBRARY_OPTIONS="--disable-static --enable-shared"

# OPTIMIZE FOR SPEED INSTEAD OF SIZE
#if [[ -z ${FFMPEG_KIT_OPTIMIZED_FOR_SPEED} ]]; then
#  SIZE_OPTIONS="--enable-small"
#else
  SIZE_OPTIONS=""
#fi


# SET DEBUG OPTIONS
#if [[ -z ${FFMPEG_KIT_DEBUG} ]]; then

  # SET LTO FLAGS
#  if [[ -z ${NO_LINK_TIME_OPTIMIZATION} ]]; then
#    DEBUG_OPTIONS="--disable-debug --enable-lto"
#  else
    DEBUG_OPTIONS="--disable-debug --disable-lto"
 # fi
#else
#  DEBUG_OPTIONS="--enable-debug --disable-stripping"
#fi

  export AR=${HOST}-ar
  export CC="armv7a-linux-androideabi${API}-clang"
  export CXX="armv7a-linux-androideabi${API}-clang++"

  export LD=${HOST}-ld
  export RANLIB=${HOST}-ranlib
  export STRIP=${HOST}-strip
  export NM=${HOST}-nm
  
./configure \
  --cross-prefix="${HOST}-" \
  --sysroot="${ANDROID_SYSROOT}" \
  --prefix="${PREFIX}" \
  --pkg-config="${HOST_PKG_CONFIG_PATH}" \
  --enable-version3 \
  --arch="${TARGET_ARCH}" \
  --cpu="${TARGET_CPU}" \
  --cc="${CC}" \
  --cxx="${CXX}" \
  --ranlib="${RANLIB}" \
  --strip="${STRIP}" \
  --nm="${NM}" \
  --extra-libs="$(pkg-config --libs --static cpu-features)" \
  --target-os=android \
  ${ASM_OPTIONS} \
  --enable-cross-compile \
  --enable-pic \
  --enable-jni \
  --enable-optimizations \
  --enable-swscale \
  ${BUILD_LIBRARY_OPTIONS} \
  --enable-v4l2-m2m \
  --disable-outdev=fbdev \
  --disable-indev=fbdev \
  ${SIZE_OPTIONS} \
  --disable-openssl \
  --disable-xmm-clobber-test \
  ${DEBUG_OPTIONS} \
  --disable-neon-clobber-test \
  --disable-programs \
  --disable-postproc \
  --disable-doc \
  --disable-htmlpages \
  --disable-manpages \
  --disable-podpages \
  --disable-txtpages \
  --disable-sndio \
  --disable-schannel \
  --disable-securetransport \
  --disable-xlib \
  --disable-cuda \
  --disable-cuvid \
  --disable-nvenc \
  --disable-vaapi \
  --disable-vdpau \
  --disable-videotoolbox \
  --disable-audiotoolbox \
  --disable-appkit \
  --disable-alsa \
  --disable-cuda \
  --disable-cuvid \
  --disable-nvenc \
  --disable-vaapi \
  --disable-vdpau 

/Applications/Xcode.app/Contents/Developer/usr/bin/make install
cd ../..

##############################################################################################
