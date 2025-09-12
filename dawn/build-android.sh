#!/bin/bash




root_dir=`pwd`
#ios_fat=${root_dir}/build/ios-fat
#mkdir -p "${ios_fat}"


#export ANDROID_HOME=E:/github/lib2/android-ndk-r28c-windows/android-ndk-r28c
export ANDROID_HOME=/Applications/AndroidNDK13676358.app/Contents/NDK


#CONCH_NDK_VERSION=21.0.6113669
CONCH_NDK_PATH=${ANDROID_HOME}
CONCH_ANDROID_MINI_SDK_VERSION=android-21
function check_android_environment {
	if [[ "${ANDROID_HOME}" == "" ]]; then
		echo "Error: ANDROID_HOME not set"
		exit 1
	fi
	
	echo "Info: ANDROID_HOME : ${ANDROID_HOME}"
	
	#CONCH_NDK_PATH="${ANDROID_HOME}/ndk/${CONCH_NDK_VERSION}"
	
	#TODO
}


function build_dawn {
    local build_type=$1
    local arch=$2
    local platform=$3
	local lib_name=dawn
	local build_dir_root="${root_dir}/out/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
    mkdir ${build_dir_root}
    cd ${build_dir_root}
	if [[ "$3" == "android" ]]; then
		local android_abi=
		if [[ "$2" == "aarch64" ]]; then
			android_abi=arm64-v8a
		fi
	
		if [[ "$2" == "arm7" ]]; then
			android_abi=armeabi-v7a
		fi
	
		if [[ "$2" == "x86" ]]; then
			android_abi=x86
		fi
	
		if [[ "$2" == "x86_64" ]]; then
			android_abi=x86_64
		fi
		#-DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=../android-${build_type}/Conch why not work?
		cmake -G "Unix Makefiles" \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_TOOLCHAIN_FILE=${CONCH_NDK_PATH}/build/cmake/android.toolchain.cmake \
			-DANDROID_ABI=${android_abi} \
			-DANDROID_NDK=${CONCH_NDK_PATH} \
			-DCMAKE_ANDROID_ARCH_ABI=${android_abi} \
			-DCMAKE_ANDROID_NDK=${CONCH_NDK_PATH} \
			-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
			-DCMAKE_SYSTEM_NAME=Android \
			-DCMAKE_SYSTEM_VERSION=19 \
			-DANDROID_STL=c++_shared \
			-DANDROID_PLATFORM=${CONCH_ANDROID_MINI_SDK_VERSION} \
			-DANDROID_ARM_NEON=TRUE \
			-DANDROID_TOOLCHAIN=clang \
        -DCMAKE_BUILD_TYPE=Release \
        -DTINT_ENABLE_INSTALL=ON \
        -DTINT_BUILD_TESTS=ON \
        -DDAWN_BUILD_TESTS=OFF \
        -DDAWN_BUILD_SAMPLES=ON \
        -DDAWN_BUILD_MONOLITHIC_LIBRARY=STATIC \
        -DTINT_BUILD_SPV_READER=ON \
        -DTINT_BUILD_WGSL_READER=ON \
        -DTINT_BUILD_GLSL_WRITER=ON \
        -DTINT_BUILD_GLSL_VALIDATOR=ON \
        -DTINT_BUILD_HLSL_WRITER=ON \
        -DTINT_BUILD_MSL_WRITER=ON \
        -DTINT_BUILD_SPV_WRITER=ON \
        -DTINT_BUILD_WGSL_WRITER=ON \
        -DDAWN_BUILD_PROTOBUF=OFF \
        -DTINT_BUILD_IR_BINARY=OFF \
			${root_dir}

		cmake --build . --config ${build_type} --target install
	fi
}
build_dawn release "arm7" android
#build_dawn release "x86_64" android
#build_dawn release "x86" android
#build_dawn release "aarch64" android