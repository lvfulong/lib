root_dir=`pwd`
ios_fat=${root_dir}/build/ios-fat
mkdir -p "${ios_fat}"


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
BUILD_LIB_TYPE=""
ISSUE_CLEAN=false

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
		#-DPLATFORM_NAME="${platform}"
		#-DCMAKE_BUILD_TYPE=${build_type} 
		cmake . -G "Visual Studio 17 2022" \
			-A${arch} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			../../../${lib_name}/${lib_source_dir}
	
		cmake --build . --config ${build_type} --target install
	fi
	
	if [[ "$3" == "iphoneos" ]] || [[ "$3" == "iphonesimulator" ]]; then
		cmake \
			-G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE="${build_type}" \
			-DIOS_ARCH="${arch}" \
			-DPLATFORM_NAME="${platform}" \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
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
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi
	

	if [[ "$3" == "linux" ]]; then
		cmake \
			-G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE="${build_type}" \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			../../../${lib_name}/${lib_source_dir}
		
		cmake --build . --config ${build_type} --target install
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
	
	if [[ "$3" == "iphoneos" ]] || [[ "$3" == "iphonesimulator" ]]; then
		cmake \
			-G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE="${build_type}" \
			-DIOS_ARCH="${arch}" \
			-DPLATFORM_NAME="${platform}" \
			#-DCMAKE_INSTALL_PREFIX=${build_dir} \
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
			#-DCMAKE_INSTALL_PREFIX=${build_dir} \
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

		cmake --build . --config ${build_type} --target install
	fi

	if [[ "$3" == "linux" ]]; then
		cmake \
			-G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE="${build_type}" \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DPNG_STATIC=ON \
			-DPNG_SHARED=OFF \
			-DPNG_EXECUTABLES=OFF \
			-DPNG_TESTS=OFF \
			../../../${lib_name}/${lib_source_dir}
		
		cmake --build . --config ${build_type} --target install
	fi
	
	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}


function build_jpeg {
	local build_type=$1
    local arch=$2
    local platform=$3

	local lib_name=jpeg
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=jpeg-9e
	rm -rf ${lib_source_dir}
	tar xvzf jpegsrc.v9e.tar.gz

	#cd ..
	#cd ${build_dir}
	cd ${lib_source_dir}

	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "windows" ]]; then	

		make
		make install
	fi
	
	if [[ "$3" == "iphoneos" ]] || [[ "$3" == "iphonesimulator" ]]; then
		XCODE_TOOLCHAIN=$(xcode-select --print-path)/Toolchains/XcodeDefault.xctoolchain
		IOS_PLATFORM=$3

		IOS_SDK=$(xcrun -sdk ${IOS_PLATFORM} -show-sdk-path)

		#export PATH := ${CURDIR}/build/macOS/x86_64/bin:${PATH}

		export PREFIX=${build_dir_root}

		export CXX="${XCODE_TOOLCHAIN}/usr/bin/clang++"
		export CC="${XCODE_TOOLCHAIN}/usr/bin/clang"
		export CFLAGS="-arch ${arch} -isysroot ${IOS_SDK} -miphoneos-version-min=8.0 -O3 -DNDEBUG -I${PREFIX}/include"
		export CPPFLAGS="-arch ${arch} -isysroot ${IOS_SDK} -miphoneos-version-min=8.0 -O3 -DNDEBUG -I${PREFIX}/include"
		export CXXFLAGS="-arch ${arch} -isysroot ${IOS_SDK} -miphoneos-version-min=8.0 -O3 -DNDEBUG -I${PREFIX}/include"
		export LDFLAGS="-arch ${arch} -isysroot ${IOS_SDK} -miphoneos-version-min=8.0 -O3 -DNDEBUG -L${PREFIX}/lib -L${IOS_SDK}/usr/lib"
		HOST=arm-apple-darwin


		#local TOOLSET=
		#local BUILD=
		#if [[ "$2" == "arm64" ]]; then
		#	TOOLSET=arm-apple-darwin
		#	BUILD=x86_64-apple-darwwin14
		#fi	

		#if [[ "$2" == "x86_64" ]]; then
		#	TOOLSET=x86_64-apple-darwin
		#	BUILD=x86_64-apple-darwwin14
		#fi	

		./configure --host=${HOST} \
			--prefix=${PREFIX} \
			--disable-shared \
			--enable-static
		
		make
		make install
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

		make
		make install
	fi
	
	if [[ "$3" == "linux" ]]; then
		./configure --prefix=${build_dir_root} \
			--disable-shared \
			--enable-static
		
		make
		make install
	fi

	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}

function build_jpeg_turbo {
	local build_type=$1
    local arch=$2
    local platform=$3

	local lib_name=libjpeg-turbo
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=libjpeg-turbo-2.1.5.1
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
			-DENABLE_STATIC=ON \
			-DENABLE_SHARED=OFF \
			../../../${lib_name}/${lib_source_dir}
	
		cmake --build . --config ${build_type} --target install
	fi
	
	if [[ "$3" == "iphoneos" ]] || [[ "$3" == "iphonesimulator" ]]; then

		# libjpeg-turbo-2.1.5.1\BUILDING.md
		#-DCMAKE_SYSTEM_PROCESSOR=${arch} \

		XCODE_TOOLCHAIN=$(xcode-select --print-path)/Toolchains/XcodeDefault.xctoolchain
		IOS_PLATFORM=$3

		IOS_SDK=$(xcrun -sdk ${IOS_PLATFORM} -show-sdk-path)


		IOS_PLATFORMDIR=
		IOS_SYSROOT=
		if [[ "$3" == "iphoneos" ]]; then
			IOS_PLATFORMDIR=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform
    		IOS_SYSROOT=($IOS_PLATFORMDIR/Developer/SDKs/iPhoneOS*.sdk)
		fi
		if [[ "$3" == "iphonesimulator" ]]; then
			IOS_PLATFORMDIR=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform
    		IOS_SYSROOT=($IOS_PLATFORMDIR/Developer/SDKs/iPhoneSimulator*.sdk)
		fi
    	export CFLAGS="-Wall -arch ${arch} -miphoneos-version-min=8.0 -funwind-tables"
		cmake \
			-G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE="${build_type}" \
			-DIOS_ARCH="${arch}" \
			-DPLATFORM_NAME="${platform}" \
			#-DCMAKE_INSTALL_PREFIX=${build_dir} \
			-DCMAKE_TOOLCHAIN_FILE=../../../CMake/clang/iOS.cmake \
			-DCMAKE_SYSTEM_NAME=iOS \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DENABLE_STATIC=ON \
			-DENABLE_SHARED=OFF \
			-DCMAKE_OSX_SYSROOT=${IOS_SDK} \
			-DCMAKE_SYSTEM_PROCESSOR=${arch} \
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
			#-DCMAKE_INSTALL_PREFIX=${build_dir} \
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
			-DENABLE_STATIC=ON \
			-DENABLE_SHARED=OFF \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi
	
	if [[ "$3" == "linux" ]]; then
		cmake -G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DENABLE_STATIC=ON \
			-DENABLE_SHARED=OFF \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi

	#rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}


function build_zip {
	local build_type=$1
    local arch=$2
    local platform=$3
	#depends zlib
	build_zlib ${build_type} ${arch} ${platform}
	local lib_name=zip
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=libzip-1.9.2
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	cd ..
	cd ${build_dir}
	

	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "windows" ]]; then	
	
		cmake . -G "Visual Studio 17 2022" \
			-A${arch} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DBUILD_SHARED_LIBS=OFF \
			../../../${lib_name}/${lib_source_dir}
	
		cmake --build . --config ${build_type} --target install
	fi
	
	if [[ "$3" == "iphoneos" ]] || [[ "$3" == "iphonesimulator" ]]; then
		cmake \
			-G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE="${build_type}" \
			-DIOS_ARCH="${arch}" \
			-DPLATFORM_NAME="${platform}" \
			#-DCMAKE_INSTALL_PREFIX=${build_dir} \
			-DCMAKE_TOOLCHAIN_FILE=../../../CMake/clang/iOS.cmake \
			-DCMAKE_SYSTEM_NAME=iOS \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DBUILD_SHARED_LIBS=OFF \
			-DBUILD_TOOLS=OFF \
			-DBUILD_REGRESS=OFF \
			-DBUILD_TOOLS=OFF \
			-DBUILD_EXAMPLES=OFF \
			-DBUILD_DOC=OFF \
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
			#-DCMAKE_INSTALL_PREFIX=${build_dir} \
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
			-DBUILD_SHARED_LIBS=OFF \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi

	if [[ "$3" == "linux" ]]; then
		cmake \
			-G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE="${build_type}" \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DBUILD_SHARED_LIBS=OFF \
			-DBUILD_TOOLS=OFF \
			-DBUILD_REGRESS=OFF \
			-DBUILD_TOOLS=OFF \
			-DBUILD_EXAMPLES=OFF \
			-DBUILD_DOC=OFF \
			../../../${lib_name}/${lib_source_dir}
		
		cmake --build . --config ${build_type} --target install
	fi

	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}

function build_freetype {
	local build_type=$1
    local arch=$2
    local platform=$3
	#depends zlib png
	build_zlib ${build_type} ${arch} ${platform}
	build_png ${build_type} ${arch} ${platform}
	local lib_name=freetype
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=freetype-2.13.0
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
			-DFT_REQUIRE_ZLIB=TRUE \
			-DFT_REQUIRE_BZIP2=FALSE \
			-DFT_REQUIRE_PNG=TRUE \
			-DFT_REQUIRE_HARFBUZZ=FALSE \
			-DFT_REQUIRE_BROTLI=FALSE \
			../../../${lib_name}/${lib_source_dir}
	
		cmake --build . --config ${build_type} --target install
	fi
	
	if [[ "$3" == "iphoneos" ]] || [[ "$3" == "iphonesimulator" ]]; then
		cmake \
			-G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE="${build_type}" \
			-DIOS_ARCH="${arch}" \
			-DPLATFORM_NAME="${platform}" \
			#-DCMAKE_INSTALL_PREFIX=${build_dir} \
			-DCMAKE_TOOLCHAIN_FILE=../../../CMake/clang/iOS.cmake \
			-DCMAKE_SYSTEM_NAME=iOS \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
            -DFT_REQUIRE_ZLIB=TRUE \
            -DFT_REQUIRE_BZIP2=FALSE \
            -DFT_REQUIRE_PNG=TRUE \
            -DFT_REQUIRE_HARFBUZZ=FALSE \
            -DFT_REQUIRE_BROTLI=FALSE \
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
			#-DCMAKE_INSTALL_PREFIX=${build_dir} \
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
            -DFT_REQUIRE_ZLIB=FALSE \
            -DFT_REQUIRE_BZIP2=FALSE \
            -DFT_REQUIRE_PNG=FALSE \
            -DFT_REQUIRE_HARFBUZZ=FALSE \
            -DFT_REQUIRE_BROTLI=FALSE \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi
	

	if [[ "$3" == "linux" ]]; then
		cmake  -G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
            -DFT_REQUIRE_ZLIB=FALSE \
            -DFT_REQUIRE_BZIP2=FALSE \
            -DFT_REQUIRE_PNG=FALSE \
            -DFT_REQUIRE_HARFBUZZ=FALSE \
            -DFT_REQUIRE_BROTLI=FALSE \
			../../../${lib_name}/${lib_source_dir}
		
		cmake --build . --config ${build_type} --target install
	fi

	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}

function build_mpg123 {
	local build_type=$1
    local arch=$2
    local platform=$3
	local lib_name=mpg123
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=mpg123-1.31.3
	rm -rf ${lib_source_dir}
	tar -jxvf ${lib_source_dir}.tar.bz2

	cd ..
	cd ${build_dir}
	

	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "windows" ]]; then	
		#cd ${root_dir}/${lib_name}/${lib_source_dir}
		#./windows-builds.sh x86
		cmake . -G "Visual Studio 17 2022" \
			-A${arch} \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			../../../${lib_name}/${lib_source_dir}/ports/cmake
		
		cmake --build . --config ${build_type} --target install
	fi
	
	#if [[ "$3" == "iphoneos" ]] || [[ "$3" == "iphonesimulator" ]]; then
	#fi
	
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
	fi
	

	if [[ "$3" == "linux" ]]; then
		cmake  -G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			../../../${lib_name}/${lib_source_dir}/ports/cmake
		
		cmake --build . --config ${build_type} --target install
	fi

	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}
function build_openssl {
	local build_type=$1
    local arch=$2
    local platform=$3
	#depends zlib
	build_zlib ${build_type} ${arch} ${platform}
	local lib_name=openssl
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=openssl-3.1.0
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	#cd ..
	#cd ${build_dir}
	cd ${lib_source_dir}

	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "windows" ]]; then
		#install Strawberry Perl
		#https://www.taurusxin.com/openssl_win_build/
		#注意perl在windows的git shell执行有问题
		#在windows powershell 直接执行perl Configure VC-WIN32 --prefix=E:\github\lib\build\windows-Release-win32 no-asm no-shared	
		#nmake D:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.38.33130\bin\Hostx64\x86加入PATH
		# VS2022 的开发人员提示工具 否则需要接入下列路径到环境变量
		#C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x86 加入PATH
		#C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x86 
		#C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\ucrt\x86
		#D:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.38.33130\lib\x86 加如LIB
		#D:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.38.33130\include
		#C:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\shared
		#C:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\ucrt
		#C:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\um
		cd 'D:/Program Files/Microsoft Visual Studio/2022/Community/VC/Auxiliary/Build'
		pwd
		./vcvars32.bat
		cd ${root_dir}
		cd ${lib_name}
		cd ${lib_source_dir}
		perl Configure VC-WIN32 --prefix=${build_dir_root} no-asm no-shared
		nmake 
		#nmake test
		nmake install
	fi
	
	if [[ "$3" == "iphoneos" ]] || [[ "$3" == "iphonesimulator" ]]; then
		TODO
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
			export ANDROID_SYSROOT=${CONCH_NDK_PATH}/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
			export NDK_SYSROOT=${ANDROID_SYSROOT}
            export ANDROID_NDK_ROOT=${CONCH_NDK_PATH}
			export ANDROID_NDK_SYSROOT=${ANDROID_SYSROOT}
            PATH="${CONCH_NDK_PATH}/toolchains/llvm/prebuilt/darwin-x86_64/bin:${CONCH_NDK_PATH}/toolchains/x86_64-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
			./Configure android-x86_64 -m64 -D__ANDROID_API__=21 --prefix=${build_dir_root}  no-shared no-unit-test
		fi
		/Applications/Xcode.app/Contents/Developer/usr/bin/make install_sw
	fi
	
	if [[ "$3" == "linux" ]]; then
		#./Configure --prefix=${build_dir_root} --openssldir=${build_dir_root} no-shared no-unit-test \
        #'-Wl,-rpath,$(LIBRPATH)'
		#make install_sw

		./Configure --prefix=${build_dir_root} --openssldir=${build_dir_root} no-shared no-unit-test
		make install
	fi

	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}

function build_websocket {
	local build_type=$1
    local arch=$2
    local platform=$3
	#depends zlib
	build_zlib ${build_type} ${arch} ${platform}
	build_openssl ${build_type} ${arch} ${platform}
	local lib_name=websocket
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=libwebsockets-2.3.0
	rm -rf ${lib_source_dir}
	unzip ${lib_source_dir}.zip

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
			-DLWS_WITH_SSL=1 \
			-DLWS_WITHOUT_SERVER=0 \
			-DLWS_WITH_SHARED=0 \
			-DLWS_WITHOUT_TEST_SERVER=1 \
			-DLWS_WITHOUT_TEST_SERVER_EXTPOLL=1 \
			-DLWS_WITHOUT_TEST_PING=1 \
			-DLWS_WITHOUT_TEST_ECHO=1 \ 
			-DLWS_WITHOUT_TEST_CLIENT=1 \
 			-DLWS_WITHOUT_TEST_FRAGGLE=1 \
			-DLWS_IPV6=1 \
			../../../${lib_name}/${lib_source_dir}
	
		cmake --build . --config ${build_type} --target install
	fi
	
	if [[ "$3" == "iphoneos" ]] || [[ "$3" == "iphonesimulator" ]]; then
		cmake \
			-G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE="${build_type}" \
			-DIOS_ARCH="${arch}" \
			-DPLATFORM_NAME="${platform}" \
			#-DCMAKE_INSTALL_PREFIX=${build_dir} \
			-DCMAKE_TOOLCHAIN_FILE=../../../CMake/clang/iOS.cmake \
			-DCMAKE_SYSTEM_NAME=iOS \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DLWS_WITH_SSL=1 \
			-DLWS_WITHOUT_SERVER=0 \
			-DLWS_WITH_SHARED=0 \
			-DLWS_WITHOUT_TEST_SERVER=1 \
			-DLWS_WITHOUT_TEST_SERVER_EXTPOLL=1 \
			-DLWS_WITHOUT_TEST_PING=1 \
			-DLWS_WITHOUT_TEST_ECHO=1 \ 
			-DLWS_WITHOUT_TEST_CLIENT=1 \
 			-DLWS_WITHOUT_TEST_FRAGGLE=1 \
			-DLWS_IPV6=1 \
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
			#-DCMAKE_INSTALL_PREFIX=${build_dir} \
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
            -DCMAKE_FIND_ROOT_PATH=${build_dir_root} \
			-DLWS_WITH_SSL=1 \
			-DLWS_WITHOUT_SERVER=0 \
			-DLWS_WITH_SHARED=0 \
			-DLWS_WITHOUT_TEST_SERVER=1 \
			-DLWS_WITHOUT_TEST_SERVER_EXTPOLL=1 \
			-DLWS_WITHOUT_TEST_PING=1 \
			-DLWS_WITHOUT_TEST_ECHO=1 \
			-DLWS_WITHOUT_TEST_CLIENT=1 \
 			-DLWS_WITHOUT_TEST_FRAGGLE=1 \
			-DLWS_IPV6=1 \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi
	if [[ "$3" == "linux" ]]; then
		cmake -G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
            -DCMAKE_FIND_ROOT_PATH=${build_dir_root} \
			-DLWS_WITH_ZLIB=1 \
			-DLWS_WITH_SSL=1 \
			-DLWS_WITHOUT_SERVER=0 \
			-DLWS_WITH_SHARED=0 \
			-DLWS_WITHOUT_TEST_SERVER=1 \
			-DLWS_WITHOUT_TEST_SERVER_EXTPOLL=1 \
			-DLWS_WITHOUT_TEST_PING=1 \
			-DLWS_WITHOUT_TEST_ECHO=1 \
			-DLWS_WITHOUT_TEST_CLIENT=1 \
 			-DLWS_WITHOUT_TEST_FRAGGLE=1 \
			-DLWS_IPV6=1 \
			-DLWS_ZLIB_LIBRARIES="${build_dir_root}/lib" \
			-DLWS_ZLIB_INCLUDE_DIRS="${build_dir_root}/include" \
			-DLWS_OPENSSL_LIBRARIES="${build_dir_root}/lib64" \
			-DLWS_OPENSSL_INCLUDE_DIRS="${build_dir_root}/include" \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi
	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}
function build_curl {
	local build_type=$1
    local arch=$2
    local platform=$3
	#depends zlib
	build_zlib ${build_type} ${arch} ${platform}
	build_openssl ${build_type} ${arch} ${platform}
	local lib_name=curl
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=curl-7.56.0
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	#cd ..
	#cd ${build_dir}
	

	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "windows" ]]; then	
		cd ..
		cd ${build_dir}
		cmake . -G "Visual Studio 17 2022" \
			-A${arch} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
		  	-DCURL_ZLIB=ON \
		   	-DCMAKE_USE_OPENSSL=ON \
		   	-DENABLE_IPV6=ON \
		   	-DCURL_STATICLIB=ON \
		   	-DBUILD_CURL_EXE=OFF \
		    -DBUILD_TESTING=OFF \
			-DZLIB_LIBRARIES="${build_dir_root}/lib" \
			-DZLIB_INCLUDE_DIRS="${build_dir_root}/include" \
	        -DOPENSSL_LIBRARIES="${build_dir_root}/lib64" \
			-DOPENSSL_INCLUDE_DIR="${build_dir_root}/include" \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi
	if [[ "$3" == "linux" ]]; then
		#cmake -G "Unix Makefiles" \
		#	-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
		#	-DCMAKE_PREFIX_PATH=${build_dir_root} \
		#  	-DCURL_ZLIB=ON \
		#   	-DCMAKE_USE_OPENSSL=ON \
		#   	-DENABLE_IPV6=ON \
		#   	-DCURL_STATICLIB=ON \
		#   	-DBUILD_CURL_EXE=OFF \
		#    -DBUILD_TESTING=OFF \
		#	-DZLIB_LIBRARIES="${build_dir_root}/lib" \
		#	-DZLIB_INCLUDE_DIRS="${build_dir_root}/include" \
		#	-DOPENSSL_LIBRARIES="${build_dir_root}/lib64" \
		#	-DOPENSSL_INCLUDE_DIR="${build_dir_root}/include" \
		#	../../../${lib_name}/${lib_source_dir}

		#cmake --build . --config ${build_type} --target install
		export PKG_CONFIG_PATH="${build_dir_root}/lib64/pkgconfig:${PKG_CONFIG_PATH}"
		cd ${lib_source_dir}
		#./configure --prefix=${build_dir_root} --target=x86_64 --with-ssl=${build_dir_root} --with-zlib=${build_dir_root} --disable-shared
		./configure --prefix=${build_dir_root} --target=x86_64 --with-ssl --with-zlib=${build_dir_root} --disable-shared
		make
		make install
	fi
	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}
function build_openal {
	local build_type=$1
    local arch=$2
    local platform=$3

	local lib_name=openal
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=openal-soft-1.21.1
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	cd ..
	cd ${build_dir}
	

	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	#if [[ "$3" == "windows" ]]; then	
	#fi
	
	if [[ "$3" == "iphoneos" ]] || [[ "$3" == "iphonesimulator" ]]; then
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
	fi
	if [[ "$3" == "linux" ]]; then
		cmake -G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
            -DCMAKE_FIND_ROOT_PATH=${build_dir_root} \
			-DLIBTYPE=STATIC \
			-DALSOFT_BACKEND_OPENSL=1 \
			-DALSOFT_BACKEND_WAVE=1 \
			-DCMAKE_BUILD_TYPE=Release \
			-DALSOFT_AMBDEC_PRESETS=0 \
			-DALSOFT_EMBED_HRTF_DATA=0 \
			-DALSOFT_ENABLE_SSE2_CODEGEN=0 \
			-DALSOFT_EXAMPLES=0 \
			-DALSOFT_HRTF_DEFS=0
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi
	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}
function archive_ios {

	local build_type=$1
	local platform0=$2
	local arch0=$3
	local platform1=$4
	local arch1=$5
	
	local build_dir0="${root_dir}/build/${platform0}-${build_type}-${arch0}"
	local build_dir1="${root_dir}/build/${platform1}-${build_type}-${arch1}"
	lipo -create  "${build_dir0}/lib/libz.a"  "${build_dir1}/lib/libz.a"  -output "${root_dir}/build/ios-fat/libz.a"
	lipo -create  "${build_dir0}/lib/libpng16.a"  "${build_dir1}/lib/libpng16.a"  -output "${root_dir}/build/ios-fat/libpng.a"
	lipo -create  "${build_dir0}/lib/libjpeg.a"  "${build_dir1}/lib/libjpeg.a"  -output "${root_dir}/build/ios-fat/libjpeg.a"
    lipo -create  "${build_dir0}/lib/libturbojpeg.a"  "${build_dir1}/lib/libturbojpeg.a"  -output "${root_dir}/build/ios-fat/libturbojpeg.a"
    lipo -create  "${build_dir0}/lib/libfreetype.a"  "${build_dir1}/lib/libfreetype.a"  -output "${root_dir}/build/ios-fat/libfreetype.a"
}

function clean {
    echo "Cleaning build directories..."
    rm -Rf ${root_dir}/build
}

pushd "$(dirname "$0")" > /dev/null

while getopts ":hct:" opt; do
    case ${opt} in
        h)
            print_help
            exit 1
            ;;
        \?)
            echo "Invalid option: -${OPTARG}" >&2
            echo ""
            print_help
            exit 1
            ;;
        :)
            echo "Option -${OPTARG} requires an argument." >&2
            echo ""
            print_help
            exit 1
            ;;
		c)	
			ISSUE_CLEAN=true
            ;;
		t)	
			BUILD_LIB_TYPE=${OPTARG}
		 	echo "option t: -${OPTARG}" >&2
            ;;
    esac
done
# 命令行未提供参数
if [[ "$#" == "0" ]]; then
    print_help
    exit 1
fi

if [[ "${ISSUE_CLEAN}" == "true" ]]; then
    clean
fi
    case ${BUILD_LIB_TYPE} in
        websocket)
           	build_websocket  release "x86_64" linux
            exit 1
            ;;
		curl)
           	build_curl  release "x86_64" linux
			#build_curl Release "win32" windows
            exit 1
            ;;
		zlib)
           	build_zlib  release "x86_64" linux
			#build_zlib  Release "win32" windows
            exit 1
            ;;
		mpg123)
			build_mpg123  release "x86_64" linux
           	#build_mpg123  Release "win32" windows
            exit 1
            ;;
		zip)
           	build_zip  release "x86_64" linux
			#build_zip Release "win32" windows
            exit 1
            ;;
		png)
           	build_png  release "x86_64" linux
            exit 1
            ;;
		jpeg_turbo)
           	build_jpeg_turbo  release "x86_64" linux
            exit 1
            ;;
		openssl)
			build_openssl  release "x86_64" linux
           	#build_openssl  Release "win32" windows
            exit 1
            ;;
		openal)
			openal  release "x86_64" linux
           	#openal  Release "win32" windows
            exit 1
            ;;
    esac

#check_android_environment

#build_png Release "win32" windows
#build_png Release "win64" windows
#build_png release "x86_64" linux

#build_png release arm64 iphoneos
#build_png release x86_64 iphonesimulator
#archive_ios release iphoneos arm64 iphonesimulator x86_64

#build_jpeg_turbo Release "win32" windows
#build_jpeg_turbo Release "win64" windows

#build_jpeg_turbo release arm64 iphoneos
#build_jpeg_turbo release x86_64 iphonesimulator
#archive_ios release iphoneos arm64 iphonesimulator x86_64

#build_jpeg_turbo release "aarch64" android
#build_jpeg_turbo release "arm7" android
#build_jpeg_turbo release "x86_64" android
#build_jpeg_turbo release "x86" android
#build_jpeg_turbo release "x86_64" linux

#build_zip Release "win32" windows
#build_zip Release "win64" windows

#build_zip release arm64 iphoneos
#build_zip release x86_64 iphonesimulator
#archive_ios release iphoneos arm64 iphonesimulator x86_64

#build_zip release "aarch64" android
#build_zip release "arm7" android
#build_zip release "x86_64" android
#build_zip release "x86" android
#build_zip release "x86_64" linux

#build_freetype Release "win32" windows
#build_freetype Release "win64" windows

#build_freetype release arm64 iphoneos
#build_freetype release x86_64 iphonesimulator
#archive_ios release iphoneos arm64 iphonesimulator x86_64

#build_freetype release "aarch64" android
#build_freetype release "arm7" android
#build_freetype release "x86_64" android
#build_freetype release "x86" android
#build_freetype release "x86_64" linux


#build_mpg123 release "x86_64" linux

#build_jpeg release "x86_64" linux
#build_jpeg release arm64 iphoneos
#build_jpeg release x86_64 iphonesimulator
#archive_ios release iphoneos arm64 iphonesimulator x86_64

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
#build_zlib release "x86_64" linux

#build_websocket release "x86_64" android
#build_websocket  release "x86_64" linux

#build_curl Release "win32" windows

#build_openssl release "x86_64" linux



