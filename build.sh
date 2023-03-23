root_dir=`pwd`


function build_zlib_iOS {
	local build_type=$1
    local arch=$2
    local platform=$3
    local build_dir="${root_dir}/build/ios-${build_type}-${arch}"
	mkdir -p "${build_dir}"
	cd zlib
	local zlibVersion=zlib-1.2.13
	rm -rf ${zlibVersion}
	tar xvzf ${zlibVersion}.tar.gz

	cd ..
	cd ${build_dir}
	
	cmake \
	-G "Unix Makefiles" \
    -DCMAKE_BUILD_TYPE="${build_type}" \
    -DIOS_ARCH="${arch}" \
    -DPLATFORM_NAME="${platform}" \
	-DCMAKE_INSTALL_PREFIX=${build_dir} \
	-DCMAKE_TOOLCHAIN_FILE=../../CMake/clang/iOS.cmake \
	-DCMAKE_SYSTEM_NAME=iOS \
	../../zlib/${zlibVersion}

	cmake --build . --target install
	#make
	cd ../..
}


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

#build_android release arm64 iphoneos
function build_zlib_android {

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
	
    local build_type=$1
    local arch=$2
    local platform=$3
    local build_dir="${root_dir}/build/android-${build_type}-${arch}"


	mkdir -p "${build_dir}"
	cd zlib
	local zlibVersion=zlib-1.2.13
	rm -rf ${zlibVersion}
	tar xvzf ${zlibVersion}.tar.gz

	cd ..
	cd ${build_dir}

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
		../../zlib/${zlibVersion}

		cmake --build . --target install
		
	
		cd ../..
}

function build_zlib_windows {
	local build_type=$1
    local arch=$2
    #local platform=$3
    local build_dir="${root_dir}/build/windows-${build_type}-${arch}"
	mkdir -p "${build_dir}"
	cd zlib
	local zlibVersion=zlib-1.2.13
	rm -rf ${zlibVersion}
	tar xvzf ${zlibVersion}.tar.gz

	cd ..
	cd ${build_dir}
	
	local generator="Visual Studio 14 2015"
	if [[ "$2" == "win64" ]]; then
		generator="Visual Studio 14 2015 Win64"
	fi
	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	cmake -G "${generator}" \
	-DCMAKE_INSTALL_PREFIX=${build_dir} \
	../../zlib/${zlibVersion}
	
	cmake --build . --config ${build_type} --target install
	#make
	cd ../..
}

function build_png_windows {
	local build_type=$1
    local arch=$2
    #local platform=$3
	#depends zlib
	build_zlib_windows ${build_type} ${arch}
    local build_dir="${root_dir}/build/windows-${build_type}-${arch}"
	mkdir -p "${build_dir}"
	cd png
	local libVersion=libpng-1.6.39
	rm -rf ${libVersion}
	tar xvzf ${libVersion}.tar.gz

	cd ..
	cd ${build_dir}
	
	local generator="Visual Studio 14 2015"
	if [[ "$2" == "win64" ]]; then
		generator="Visual Studio 14 2015 Win64"
	fi
	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	cmake -G "${generator}" \
	-DCMAKE_INSTALL_PREFIX=${build_dir} \
	-DCMAKE_PREFIX_PATH=${build_dir} \
	-DPNG_STATIC=ON \
	-DPNG_SHARED=OFF \
	-DPNG_EXECUTABLES=OFF \
	-DPNG_TESTS=OFF \
	../../png/${libVersion}
	
	cmake --build . --config ${build_type} --target install
	#make
	cd ../..
}
check_android_environment

build_zlib_windows Release "win32"
build_zlib_windows Release "win64"

build_zlib_android release "aarch64"
build_zlib_android release "arm7"
build_zlib_android release "x86_64"
build_zlib_android release "x86"

build_zlib_iOS release arm64 iphoneos
build_zlib_iOS release x86_64 iphonesimulator

