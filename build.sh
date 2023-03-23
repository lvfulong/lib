root_dir=`pwd`



export ANDROID_HOME=/Users/joychina/Desktop/lvfulong/android-ndk-r21e

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

function build_zlib {
	local build_type=$1
    local arch=$2
    local platform=$3
	local lib_name=zlib
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=zlib-1.2.13
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	cd ..
	cd ${build_dir}
	if [[ "$3" == "windows" ]]; then
		local generator="Visual Studio 14 2015"
		if [[ "$2" == "win64" ]]; then
			generator="Visual Studio 14 2015 Win64"
		fi
		#-DPLATFORM_NAME="${platform}"
		#-DCMAKE_BUILD_TYPE=${build_type} 
		cmake -G "${generator}" \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			../../../${lib_name}/${lib_source_dir}
	
		cmake --build . --config ${build_type} --target install
	fi
	
	if [[ "$3" == "iphoneos" ] || [ "$3" == "iphonesimulator" ]]; then
		cmake \
			-G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE="${build_type}" \
			-DIOS_ARCH="${arch}" \
			-DPLATFORM_NAME="${platform}" \
			-DCMAKE_INSTALL_PREFIX=${build_dir} \
			-DCMAKE_TOOLCHAIN_FILE=../../../CMake/clang/iOS.cmake \
			-DCMAKE_SYSTEM_NAME=iOS \
			../../../${lib_name}/${lib_source_dir}
		
		cmake --build . --config ${build_type} --target install
	fi
	
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
			-DCMAKE_INSTALL_PREFIX=${build_dir} \
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
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --target ${build_type} install
	fi
	
	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}

function build_png {
	local build_type=$1
    local arch=$2
    local platform=$3
	#depends zlib
	build_zlib ${build_type} ${arch} ${platform}
	local lib_name=png
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=libpng-1.6.39
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	cd ..
	cd ${build_dir}
	

	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "windows" ]]; then	
	
		local generator="Visual Studio 14 2015"
		if [[ "$2" == "win64" ]]; then
			generator="Visual Studio 14 2015 Win64"
		fi
		cmake -G "${generator}" \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DPNG_STATIC=ON \
			-DPNG_SHARED=OFF \
			-DPNG_EXECUTABLES=OFF \
			-DPNG_TESTS=OFF \
			../../../${lib_name}/${lib_source_dir}
	
		cmake --build . --config ${build_type} --target install
	fi
	
	if [[ "$3" == "iphoneos" ] || [ "$3" == "iphonesimulator" ]]; then
		cmake \
			-G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE="${build_type}" \
			-DIOS_ARCH="${arch}" \
			-DPLATFORM_NAME="${platform}" \
			-DCMAKE_INSTALL_PREFIX=${build_dir} \
			-DCMAKE_TOOLCHAIN_FILE=../../../CMake/clang/iOS.cmake \
			-DCMAKE_SYSTEM_NAME=iOS \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DPNG_STATIC=ON \
			-DPNG_SHARED=OFF \
			-DPNG_EXECUTABLES=OFF \
			-DPNG_TESTS=OFF \
			../../../${lib_name}/${lib_source_dir}
		
		cmake --build . --config ${build_type} --target install
	fi
	
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
			-DCMAKE_INSTALL_PREFIX=${build_dir} \
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
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DPNG_STATIC=ON \
			-DPNG_SHARED=OFF \
			-DPNG_EXECUTABLES=OFF \
			-DPNG_TESTS=OFF \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --target ${build_type} install
	fi
	
	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}



#check_android_environment

build_png Release "win32" windows
build_png Release "win64" windows
#build_png release arm64 iphoneos
#build_png release x86_64 iphonesimulator
#build_png release "aarch64" android
#build_png release "arm7" android
#build_png release "x86_64" android
#build_png release "x86" android

#build_zlib Release "win32" windows
#build_zlib Release "win64" windows
#build_zlib release arm64 iphoneos
#build_zlib release x86_64 iphonesimulator
#build_zlib release "aarch64" android
#build_zlib release "arm7" android
#build_zlib release "x86_64" android
#build_zlib release "x86" android



