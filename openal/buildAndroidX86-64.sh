
current_dir=`pwd`
top_dir=$current_dir
PATH="${current_dir}/..:${PATH}"

mkdir Contrib
cd Contrib

export ANDROID_NDK=/Users/LayaBox/lvfulong/lib/android-ndk-r20b
PATH="${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
##############################################################################################
rm -rf android-x86_64
mkdir android-x86_64
rm -rf install
mkdir install
cd android-x86_64
tar xvzf ../../openal-soft-1.21.1.tar.gz
mv openal-soft-1.21.1 openal-x86_64 && touch openal

cd openal-x86_64
cd build
cmake .. -DCMAKE_SYSTEM_NAME=Android \
-DCMAKE_SYSTEM_VERSION=21 \
-DANDROID_STL=c++_static \
-DANDROID_ABI=x86_64 \
-DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
-DANDROID_NATIVE_API_LEVEL=19 \
-DANDROID_TOOLCHAIN_NAME=llvm \
-DLIBTYPE=STATIC \
-DALSOFT_BACKEND_OPENSL=1 \
-DALSOFT_BACKEND_WAVE=1 \
-DCMAKE_BUILD_TYPE=Release \
-DALSOFT_AMBDEC_PRESETS=0 \
-DALSOFT_EMBED_HRTF_DATA=0 \
-DALSOFT_ENABLE_SSE2_CODEGEN=0 \
-DALSOFT_EXAMPLES=0 \
-DALSOFT_HRTF_DEFS=0

make


