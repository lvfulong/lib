root_dir=`pwd`
ios_fat=${root_dir}/build/ios-fat
mkdir -p "${ios_fat}"


#export ANDROID_HOME=E:/github/lib2/android-ndk-r25c-windows/android-ndk-r25c
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


WIN_OHOS_SDK_PATH="F:/Ohayoo-native/huawei/ide6.0.1/DevEcoStudio/sdk/default/openharmony"
WIN_OHOS_NDK_CMAKE_PATH="${WIN_OHOS_SDK_PATH}/native/build-tools/cmake/bin"
WIN_OHOS_NDK_CMAKE_TOOLCHAIN_PATH="${WIN_OHOS_SDK_PATH}/native/build/cmake/ohos.toolchain.cmake"
#OHOS_NDK_CMAKE_PATH="/Users/joychina/Desktop/lvfulong/ohos-sdk/packages/ohos-sdk/darwin/native/build-tools/cmake/bin"
#OHOS_NDK_CMAKE_TOOLCHAIN_PATH="/Users/joychina/Desktop/lvfulong/ohos-sdk/packages/ohos-sdk/darwin/native/build/cmake/ohos.toolchain.cmake"

OHOS_SDK_LINUX_PATH="/home/ubuntu/lfl/command-line-tools/sdk/default/openharmony"
LINUX_OHOS_NDK_CMAKE_PATH="${OHOS_SDK_LINUX_PATH}/native/build-tools/cmake/bin"
LINUX_OHOS_NDK_CMAKE_TOOLCHAIN_PATH="${OHOS_SDK_LINUX_PATH}/native/build/cmake/ohos.toolchain.cmake"


# 自动检测操作系统
OS_TYPE=$(uname -s)

if [[ "$OS_TYPE" == "Linux" ]]; then
    OHOS_SDK_PATH=${OHOS_SDK_LINUX_PATH}
    OHOS_NDK_CMAKE_PATH=${LINUX_OHOS_NDK_CMAKE_PATH}
    OHOS_NDK_CMAKE_TOOLCHAIN_PATH=${LINUX_OHOS_NDK_CMAKE_TOOLCHAIN_PATH}
elif [[ "$OS_TYPE" == *"MINGW"* ]] || [[ "$OS_TYPE" == *"MSYS"* ]]; then
    OHOS_SDK_PATH=${WIN_OHOS_SDK_PATH}
    OHOS_NDK_CMAKE_PATH=${WIN_OHOS_NDK_CMAKE_PATH}
    OHOS_NDK_CMAKE_TOOLCHAIN_PATH=${WIN_OHOS_NDK_CMAKE_TOOLCHAIN_PATH}
else
    # 默认使用 Windows 配置（或根据实际情况调整）
    OHOS_SDK_PATH=${WIN_OHOS_SDK_PATH}
    OHOS_NDK_CMAKE_PATH=${WIN_OHOS_NDK_CMAKE_PATH}
    OHOS_NDK_CMAKE_TOOLCHAIN_PATH=${WIN_OHOS_NDK_CMAKE_TOOLCHAIN_PATH}
fi



BUILD_LIB_TYPE=""
ISSUE_CLEAN=false

IOS_MIN_TARGET="11.0"

IOS_MIN_TARGET_SIMULATOR="11.0"

#archive_ios_lib release crypto
#archive_ios_lib release ssl
function archive_ios_lib {

	local build_type=$1
	local lib_name=$2
	
	local build_dir0="${root_dir}/build/iphoneos-${build_type}-arm64"
	local build_dir1="${root_dir}/build/iphonesimulator-${build_type}-arm64"

	lipo -create  "${build_dir0}/lib/lib${lib_name}.a"  "${build_dir1}/lib/lib${lib_name}.a"  -output "${root_dir}/build/ios-fat/lib${lib_name}.a"
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
	local lib_source_dir=zlib-1.3.1
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	cd ..
	cd ${build_dir}
	if [[ "$3" == "windows" ]]; then
		#-DPLATFORM_NAME="${platform}"
		#-DCMAKE_BUILD_TYPE=${build_type} 
		cmake . -G "Visual Studio 17 2022" \
			-A ${arch} \
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
		if [[ "$2" == "arm64-v8a" ]]; then
			android_abi=arm64-v8a
		fi
	
		if [[ "$2" == "armeabi-v7a" ]]; then
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
			-DCMAKE_C_FLAGS=-fPIC \
			-DCMAKE_CXX_FLAGS=-fPIC \
			-DCMAKE_BUILD_TYPE="${build_type}" \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			../../../${lib_name}/${lib_source_dir}
		
		cmake --build . --config ${build_type} --target install
	fi

	if [[ "$3" == "ohos" ]]; then
		local ohos_abi=
		if [[ "$2" == "arm64-v8a" ]]; then
			ohos_abi=arm64-v8a
		fi	
		if [[ "$2" == "x86_64" ]]; then
			ohos_abi=x86_64
		fi

		${OHOS_NDK_CMAKE_PATH}/cmake  -G "Ninja" \
		-DCMAKE_BUILD_TYPE=${build_type} \
		-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
		-DCMAKE_PREFIX_PATH=${build_dir_root} \
		-DENABLE_STATIC=ON \
		-DENABLE_SHARED=OFF \
		-DOHOS_STL=c++_shared \
		-DOHOS_ARCH=${ohos_abi} \
		-DCMAKE_TOOLCHAIN_FILE=${OHOS_NDK_CMAKE_TOOLCHAIN_PATH} \
		../../../${lib_name}/${lib_source_dir}

		#make
		#make install
		${OHOS_NDK_CMAKE_PATH}/cmake --build . --config ${build_type} --target install
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
	
		cmake . -G "Visual Studio 17 2022" \
			-A ${arch} \
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
			-DCMAKE_C_FLAGS=-fPIC \
			-DCMAKE_CXX_FLAGS=-fPIC \
			../../../${lib_name}/${lib_source_dir}
		
		cmake --build . --config ${build_type} --target install
	fi
	
	 if [[ "$3" == "ohos" ]]; then
        local ohos_abi=
        local ohos_toolchain_name=
        if [[ "$2" == "arm64-v8a" ]]; then
            ohos_abi=arm64-v8a
            ohos_toolchain_name=aarch64-linux-ohos
        fi  
        if [[ "$2" == "x86_64" ]]; then
            ohos_abi=x86_64
            ohos_toolchain_name=x86_64-linux-ohos
        fi

        local ohos_sysroot_include="${OHOS_SDK_PATH}/native/sysroot/usr/include"
        local ohos_arch_include="${ohos_sysroot_include}/${ohos_toolchain_name}"

        ${OHOS_NDK_CMAKE_PATH}/cmake  -G "Ninja" \
        -DCMAKE_BUILD_TYPE=${build_type} \
        -DCMAKE_INSTALL_PREFIX=${build_dir_root} \
        -DCMAKE_PREFIX_PATH=${build_dir_root} \
      	-DPNG_STATIC=ON \
		-DPNG_SHARED=OFF \
		-DPNG_EXECUTABLES=OFF \
		-DPNG_TESTS=OFF \
        -DOHOS_ARCH=${ohos_abi} \
        -DOHOS_STL=c++_shared \
        -DCMAKE_TOOLCHAIN_FILE=${OHOS_NDK_CMAKE_TOOLCHAIN_PATH} \
        -DCMAKE_C_FLAGS="-Wno-unused-command-line-argument -Wno-error=unused-command-line-argument -D__MUSL__ -isystem ${ohos_arch_include}" \
        -DCMAKE_CXX_FLAGS="-Wno-unused-command-line-argument -Wno-error=unused-command-line-argument -isystem ${ohos_arch_include}" \
        ../../../${lib_name}/${lib_source_dir}

        #make
        #make install
        ${OHOS_NDK_CMAKE_PATH}/cmake --build . --config ${build_type} --target install
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
		cmake . -G "Visual Studio 17 2022" \
			-A ${arch} \
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
			-DCMAKE_C_FLAGS=-fPIC \
			-DCMAKE_CXX_FLAGS=-fPIC \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi

	if [[ "$3" == "ohos" ]]; then
		${OHOS_NDK_CMAKE_PATH}/cmake  -G "Ninja" \
		-DCMAKE_BUILD_TYPE=${build_type} \
		-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
		-DCMAKE_PREFIX_PATH=${build_dir_root} \
		-DENABLE_STATIC=ON \
		-DENABLE_SHARED=OFF \
		-DOHOS_STL=c++_shared \
		-DCMAKE_TOOLCHAIN_FILE=${OHOS_NDK_CMAKE_TOOLCHAIN_PATH} \
		../../../${lib_name}/${lib_source_dir}

		#make
		#make install
		${OHOS_NDK_CMAKE_PATH}/cmake --build . --config ${build_type} --target install
	fi

	#rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}

function build_jxl {
	local build_type=$1
  local arch=$2
  local platform=$3
	#depends zlib
	#build_zlib ${build_type} ${arch} ${platform}
	#build_openssl ${build_type} ${arch} ${platform}
  local lib_name=libjxl
  local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
  local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=libjxl-0.11.0
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	cd ..
	cd ${build_dir}

	# if [[ "$3" == "windows" ]]; then

	# fi

  if [[ "$3" == "iphoneos" ]] || [[ "$3" == "iphonesimulator" ]]; then
    cmake \
      -G "Unix Makefiles" \
      -DCMAKE_INSTALL_PREFIX=${build_dir_root} \
      -DCMAKE_PREFIX_PATH=${build_dir_root} \
      -DCMAKE_BUILD_TYPE="${build_type}" \
      -DCMAKE_TOOLCHAIN_FILE=../../../CMake/clang/iOS.cmake \
      -DCMAKE_SYSTEM_NAME=iOS \
      -DCMAKE_SYSTEM_PROCESSOR=${arch} \
      -DCMAKE_C_COMPILER=/usr/bin/clang \
      -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
	  -DJPEGXL_STATIC=ON \
      -DBUILD_TESTING=OFF \
	  -DBUILD_SHARED_LIBS=OFF \
      -DJPEGXL_ENABLE_SJPEG=OFF \
      -DIOS_ARCH="${arch}" \
      -DPLATFORM_NAME="${platform}" \
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
			-DCMAKE_ANDROID_ARCH_ABI=${android_abi} \
			-DCMAKE_ANDROID_NDK=${CONCH_NDK_PATH} \
			-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
			-DCMAKE_SYSTEM_NAME=Android \
			-DCMAKE_SYSTEM_VERSION=19 \
			-DCMAKE_CXX_FLAGS="-fno-rtti -fexceptions -Wno-multichar" \
			-DANDROID_ABI=${android_abi} \
      -DANDROID_NDK=${CONCH_NDK_PATH} \
			-DANDROID_STL=c++_shared \
			-DANDROID_PLATFORM=${CONCH_ANDROID_MINI_SDK_VERSION} \
			-DANDROID_ARM_NEON=TRUE \
			-DANDROID_TOOLCHAIN=clang \
			-DJPEGXL_STATIC=ON \
			-DBUILD_TESTING=OFF \
			-DJPEGXL_ENABLE_SJPEG=OFF \
			../../../${lib_name}/${lib_source_dir}

    echo ${build_type}
		cmake --build . --config ${build_type} --target install
	fi


	if [[ "$3" == "linux" ]]; then
		cmake -G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DJPEGXL_STATIC=ON \
			-DBUILD_TESTING=OFF \
    		-DJPEGXL_ENABLE_SJPEG=OFF \
    		-DJPEGXL_ENABLE_TESTS=OFF \
			-DCMAKE_C_FLAGS=-fPIC \
			-DCMAKE_CXX_FLAGS=-fPIC \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi


	if [[ "$3" == "ohos" ]]; then
    ${OHOS_NDK_CMAKE_PATH}/cmake  -G "Ninja" \
    -DCMAKE_BUILD_TYPE=${build_type} \
    -DCMAKE_INSTALL_PREFIX=${build_dir_root} \
    -DCMAKE_PREFIX_PATH=${build_dir_root} \
    -DCMAKE_TOOLCHAIN_FILE=${OHOS_NDK_CMAKE_TOOLCHAIN_PATH} \
    -DCMAKE_MAKE_PROGRAM=${OHOS_NDK_CMAKE_PATH}/ninja \
    -DJPEGXL_STATIC=ON \
    -DOHOS_STL=c++_shared \
    -DBUILD_TESTING=OFF \
    -DJPEGXL_ENABLE_SJPEG=OFF \
    -DJPEGXL_ENABLE_TESTS=OFF \
    ../../../${lib_name}/${lib_source_dir}

    #make
    #make install
    ${OHOS_NDK_CMAKE_PATH}/cmake --build . --config ${build_type} --target install
  fi

	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
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
			-A ${arch} \
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
			-DCMAKE_C_FLAGS=-fPIC \
			-DCMAKE_CXX_FLAGS=-fPIC \
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
	if [[ "$3" == "ohos" ]]; then
        local ohos_abi=
        if [[ "$2" == "arm64-v8a" ]]; then
            ohos_abi=arm64-v8a
        fi  
        if [[ "$2" == "x86_64" ]]; then
            ohos_abi=x86_64
        fi

        ${OHOS_NDK_CMAKE_PATH}/cmake  -G "Ninja" \
        -DCMAKE_BUILD_TYPE=${build_type} \
        -DCMAKE_INSTALL_PREFIX=${build_dir_root} \
        -DCMAKE_PREFIX_PATH=${build_dir_root} \
        -DOHOS_STL=c++_shared \
        -DOHOS_ARCH=${ohos_abi} \
        -DCMAKE_TOOLCHAIN_FILE=${OHOS_NDK_CMAKE_TOOLCHAIN_PATH} \
		-DBUILD_SHARED_LIBS=OFF \
		-DBUILD_TOOLS=OFF \
		-DBUILD_REGRESS=OFF \
		-DBUILD_TOOLS=OFF \
		-DBUILD_EXAMPLES=OFF \
		-DBUILD_DOC=OFF \
        ../../../${lib_name}/${lib_source_dir}

        #make
        #make install
        ${OHOS_NDK_CMAKE_PATH}/cmake --build . --config ${build_type} --target install
    fi
	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}

function build_freetype {
	local build_type=$1
    local arch=$2
    local platform=$3
	#depends zlib png
	#build_zlib ${build_type} ${arch} ${platform}
	#build_png ${build_type} ${arch} ${platform}
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
	
		cmake . -G "Visual Studio 17 2022" \
			-A ${arch} \
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
		    -DCMAKE_C_FLAGS=-fPIC \
			-DCMAKE_CXX_FLAGS=-fPIC \
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
function build_glslang {
	local build_type=$1
    local arch=$2
    local platform=$3
	#depends zlib png
	#build_zlib ${build_type} ${arch} ${platform}
	#build_png ${build_type} ${arch} ${platform}
	local lib_name=glslang
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=glslang-16.1.0
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	cd ${lib_source_dir} 
	python ./update_glslang_sources.py
	#python3 ./update_glslang_sources.py
	cd ..

	cd ..
	cd ${build_dir}
	

	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "windows" ]]; then	
	
		cmake . -G "Visual Studio 17 2022" \
			-A ${arch} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			../../../${lib_name}/${lib_source_dir}
	
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
		#-DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=../android-${build_type}/Conch why not work?
		cmake -G "Unix Makefiles" \
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
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi
	

	if [[ "$3" == "linux" ]]; then
		cmake  -G "Unix Makefiles" \
		    -DCMAKE_C_FLAGS=-fPIC \
			-DCMAKE_CXX_FLAGS=-fPIC \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			../../../${lib_name}/${lib_source_dir}
		
		cmake --build . --config ${build_type} --target install
	fi

	if [[ "$3" == "ohos" ]]; then
		${OHOS_NDK_CMAKE_PATH}/cmake  -G "Ninja" \
    	-DCMAKE_BUILD_TYPE=${build_type} \
    	-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
        -DCMAKE_PREFIX_PATH=${build_dir_root} \
        -DCMAKE_TOOLCHAIN_FILE=${OHOS_NDK_CMAKE_TOOLCHAIN_PATH} \
        -DCMAKE_MAKE_PROGRAM=${OHOS_NDK_CMAKE_PATH}/ninja \
        -DOHOS_STL=c++_shared \
        ../../../${lib_name}/${lib_source_dir}

    #make
    #make install
    ${OHOS_NDK_CMAKE_PATH}/cmake --build . --config ${build_type} --target install
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
			-A ${arch} \
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
          cmake -G "Unix Makefiles" \
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
            ../../../${lib_name}/${lib_source_dir}/ports/cmake

        cmake --build . --config ${build_type} --target install
	fi
	

	if [[ "$3" == "linux" ]]; then
		cmake  -G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			../../../${lib_name}/${lib_source_dir}/ports/cmake
		
		cmake --build . --config ${build_type} --target install
	fi

	if [[ "$3" == "ohos" ]]; then
	 	local ohos_abi=
        if [[ "$2" == "arm64-v8a" ]]; then
            ohos_abi=arm64-v8a
        fi  
        if [[ "$2" == "x86_64" ]]; then
            ohos_abi=x86_64
        fi
		${OHOS_NDK_CMAKE_PATH}/cmake  -G "Ninja" \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DOHOS_STL=c++_shared \
			-DOHOS_ARCH=${ohos_abi} \
			-DCMAKE_TOOLCHAIN_FILE=${OHOS_NDK_CMAKE_TOOLCHAIN_PATH} \
			-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
			-DBUILD_LIBOUT123=OFF \
			../../../${lib_name}/${lib_source_dir}/ports/cmake
		
		${OHOS_NDK_CMAKE_PATH}/cmake --build . --config ${build_type} --target install
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
	local lib_source_dir=openssl-3.5.0
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
		#perl Configure VC-WIN64A --prefix=E:\github\lib\build\windows-Release-x64 no-asm no-shared	
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
		local IOS_PLATFORM=
		#https://github.com/leenjewel/openssl_for_ios_and_android/blob/master/tools/build-ios-openssl.sh
		if [[ "$2" == "arm64" ]]; then
			IOS_PLATFORM=arm64
			IOS_PLATFORM=$3
			IOS_SDK=$(xcrun -sdk ${IOS_PLATFORM} -show-sdk-path)
			export PREFIX=${build_dir_root}


			export CC="xcrun -sdk iphoneos clang -arch arm64"
        	export CXX="xcrun -sdk iphoneos clang++ -arch arm64"
       	 	export CFLAGS="-arch arm64 -target aarch64-ios-darwin -march=armv8 -mcpu=generic -Wno-unused-function -fstrict-aliasing -Oz -Wno-ignored-optimization-argument -isysroot ${IOS_SDK} -fembed-bitcode -miphoneos-version-min=${IOS_MIN_TARGET} -I${PREFIX}/usr/include"
        	export LDFLAGS="-arch arm64 -target aarch64-ios-darwin -march=armv8 -isysroot ${IOS_SDK} -fembed-bitcode -L${PREFIX}/usr/lib "
        	export CXXFLAGS="-std=c++14 -arch arm64 -target aarch64-ios-darwin -march=armv8 -mcpu=generic -fstrict-aliasing -fembed-bitcode -miphoneos-version-min=${IOS_MIN_TARGET} -I${PREFIX}/usr/include"
        

			./Configure iphoneos-cross no-shared --prefix="${build_dir_root}"
        	sed -ie "s!-fno-common!-fno-common -fembed-bitcode !" "Makefile"
			/Applications/Xcode.app/Contents/Developer/usr/bin/make install_sw
		fi

		if [[ "$2" == "x86_64" ]]; then
			IOS_PLATFORM=x86_64
			IOS_PLATFORM=$3
			IOS_SDK=$(xcrun -sdk ${IOS_PLATFORM} -show-sdk-path)
			export PREFIX=${build_dir_root}


			export CC="xcrun -sdk iphonesimulator clang -arch x86_64"
        	export CXX="xcrun -sdk iphonesimulator clang++ -arch x86_64"
        	export CFLAGS="-arch x86_64 -target x86_64-ios-darwin -march=x86-64 -msse4.2 -mpopcnt -m64 -mtune=x86-64 -Wno-unused-function -fstrict-aliasing -O2 -Wno-ignored-optimization-argument -isysroot ${IOS_SDK} -mios-simulator-version-min=${IOS_MIN_TARGET_SIMULATOR} -I${PREFIX}/usr/include"
        	export LDFLAGS="-arch x86_64 -target x86_64-ios-darwin -march=x86-64 -isysroot ${IOS_SDK} -L${PREFIX}/usr/lib "
        	export CXXFLAGS="-std=c++14 -arch x86_64 -target x86_64-ios-darwin -march=x86-64 -msse4.2 -mpopcnt -m64 -mtune=x86-64 -fstrict-aliasing -mios-simulator-version-min=${IOS_MIN_TARGET_SIMULATOR} -I${PREFIX}/usr/include"

			./Configure darwin64-x86_64-cc no-shared --prefix="${build_dir_root}"
        	/Applications/Xcode.app/Contents/Developer/usr/bin/make install_sw
		fi
	fi
	
	if [[ "$3" == "android" ]]; then
		local android_abi=
		if [[ "$2" == "aarch64" ]]; then
			android_abi=arm64-v8a
			export ANDROID_SYSROOT=${CONCH_NDK_PATH}/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
			export NDK_SYSROOT=${ANDROID_SYSROOT}
            export ANDROID_NDK_ROOT=${CONCH_NDK_PATH}
			export ANDROID_NDK_SYSROOT=${ANDROID_SYSROOT}
            PATH="${CONCH_NDK_PATH}/toolchains/llvm/prebuilt/darwin-x86_64/bin:${CONCH_NDK_PATH}/toolchains/x86_64-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
			./Configure android-arm64 -D__ANDROID_API__=21 --prefix=${build_dir_root}  no-shared no-unit-test
				/Applications/Xcode.app/Contents/Developer/usr/bin/make install_sw
		fi
	
		if [[ "$2" == "arm7" ]]; then
			android_abi=armeabi-v7a
			export ANDROID_SYSROOT=${CONCH_NDK_PATH}/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
			export NDK_SYSROOT=${ANDROID_SYSROOT}
            export ANDROID_NDK_ROOT=${CONCH_NDK_PATH}
			export ANDROID_NDK_SYSROOT=${ANDROID_SYSROOT}
            PATH="${CONCH_NDK_PATH}/toolchains/llvm/prebuilt/darwin-x86_64/bin:${CONCH_NDK_PATH}/toolchains/x86_64-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
			./Configure android-arm -D__ANDROID_API__=21 --prefix=${build_dir_root}   no-asm no-shared no-unit-test
			/Applications/Xcode.app/Contents/Developer/usr/bin/make install_sw
		fi
	
		if [[ "$2" == "x86" ]]; then
			android_abi=x86
			export ANDROID_SYSROOT=${CONCH_NDK_PATH}/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
			export NDK_SYSROOT=${ANDROID_SYSROOT}
            export ANDROID_NDK_ROOT=${CONCH_NDK_PATH}
			export ANDROID_NDK_SYSROOT=${ANDROID_SYSROOT}
            PATH="${CONCH_NDK_PATH}/toolchains/llvm/prebuilt/darwin-x86_64/bin:${CONCH_NDK_PATH}/toolchains/x86-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
			#./Configure android-x86 -D__ANDROID_API__=21 --prefix=${build_dir_root}  no-shared no-unit-test -latomic
			./Configure android-x86 -D__ANDROID_API__=21 --prefix=${build_dir_root}  no-shared no-unit-test 
			/Applications/Xcode.app/Contents/Developer/usr/bin/make install_sw
		fi
	
		if [[ "$2" == "x86_64" ]]; then
			android_abi=x86_64
			export ANDROID_SYSROOT=${CONCH_NDK_PATH}/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
			export NDK_SYSROOT=${ANDROID_SYSROOT}
            export ANDROID_NDK_ROOT=${CONCH_NDK_PATH}
			export ANDROID_NDK_SYSROOT=${ANDROID_SYSROOT}
            PATH="${CONCH_NDK_PATH}/toolchains/llvm/prebuilt/darwin-x86_64/bin:${CONCH_NDK_PATH}/toolchains/x86_64-4.9/prebuilt/darwin-x86_64/bin:${PATH}"
			./Configure android-x86_64 -m64 -D__ANDROID_API__=21 --prefix=${build_dir_root}  no-shared no-unit-test
			/Applications/Xcode.app/Contents/Developer/usr/bin/make install_sw
		fi
		
	fi
	
	if [[ "$3" == "ohos" ]]; then
		local ohos_abi=
		local ohos_platform=
        if [[ "$2" == "arm64-v8a" ]]; then
            ohos_abi=aarch64-linux-ohos
			ohos_platform=linux-aarch64
        fi  
        if [[ "$2" == "x86_64" ]]; then
            ohos_abi=x86_64-linux-ohos
			ohos_platform=linux-x86_64
        fi
		export OHOS_SDK=${OHOS_SDK_LINUX_PATH}
		export AS=${OHOS_SDK}/native/llvm/bin/llvm-as
		export CC="${OHOS_SDK}/native/llvm/bin/clang --target=${ohos_abi}"
		export CXX="${OHOS_SDK}/native/llvm/bin/clang++ --target=${ohos_abi}"
		export LD=${OHOS_SDK}/native/llvm/bin/ld.lld
		export STRIP=${OHOS_SDK}/native/llvm/bin/llvm-strip
		export RANLIB=${OHOS_SDK}/native/llvm/bin/llvm-ranlib
		export OBJDUMP=${OHOS_SDK}/native/llvm/bin/llvm-objdump
		export OBJCOPY=${OHOS_SDK}/native/llvm/bin/llvm-objcopy
		export NM=${OHOS_SDK}/native/llvm/bin/llvm-nm
		export AR=${OHOS_SDK}/native/llvm/bin/llvm-ar
		export CFLAGS="-fPIC -D__MUSL__=1"
		export CXXFLAGS="-fPIC -D__MUSL__=1"

		./Configure ${ohos_platform} --prefix=${build_dir_root}


		make
		make install
	fi

	#Option	Description
	#--prefix=/opt/openssl	The top of the installation directory tree. The OpenSSL libraries will be created in this directory (/opt/openssl)
	#--openssldir=/usr/local/ssl	Directory for OpenSSL configuration files, and also the default certificate and key store
	#https://developers.lseg.com/en/article-catalog/article/how-to-build-openssl-and-curl-libraries-on-linux

	if [[ "$3" == "linux" ]]; then
		#./Configure --prefix=${build_dir_root} --openssldir=${build_dir_root} no-shared no-unit-test \
        #'-Wl,-rpath,$(LIBRPATH)'
		#make install_sw

		./Configure --prefix=${build_dir_root} --openssldir=${build_dir_root}  no-shared no-unit-test

		#./Configure --prefix=/opt/openssl --openssldir=/usr/local/ssl  no-shared no-unit-test
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
	#build_zlib ${build_type} ${arch} ${platform}
	#build_openssl ${build_type} ${arch} ${platform}
	local lib_name=websocket
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=libwebsockets-4.3.5
	rm -rf ${lib_source_dir}
	tar xvzf  ${lib_source_dir}.tar.gz

	cd ..
	cd ${build_dir}
	

	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "windows" ]]; then	
	
		cmake -G "Visual Studio 17 2022" \
			-A ${arch} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DLWS_WITH_SSL=1 \
			-DLWS_WITH_ZLIB=1 \
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
			-DCMAKE_TOOLCHAIN_FILE=../../../CMake/clang/iOS.cmake \
			-DCMAKE_SYSTEM_NAME=iOS \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DLWS_WITH_SSL=1 \
			-DLWS_WITH_ZLIB=1 \
			-DLWS_WITHOUT_SERVER=0 \
			-DLWS_WITH_SHARED=0 \
			-DLWS_WITHOUT_TEST_SERVER=1 \
			-DLWS_WITHOUT_TEST_SERVER_EXTPOLL=1 \
			-DLWS_WITHOUT_TEST_PING=1 \
			-DLWS_WITHOUT_TEST_ECHO=1 \
			-DLWS_WITHOUT_TEST_CLIENT=1 \
 			-DLWS_WITHOUT_TEST_FRAGGLE=1 \
			-DLWS_DETECTED_PLAT_IOS=1 \
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
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi
	if [[ "$3" == "linux" ]]; then
		cmake -G "Unix Makefiles" \
			-DLWS_HAVE_EVP_MD_CTX_free=1 \
			-DLWS_HAVE_HMAC_CTX_new=1 \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
            -DCMAKE_FIND_ROOT_PATH=${build_dir_root} \
			-DLWS_WITH_ZLIB=1 \
			-DLWS_WITH_SSL=1 \
			-DLWS_WITHOUT_SERVER=0 \
			-DLWS_WITH_SHARED=0 \
			-DLWS_WITH_STATIC=1 \
			-DLWS_STATIC_PIC=1 \
			-DLWS_WITHOUT_TEST_SERVER=1 \
			-DLWS_WITHOUT_TEST_SERVER_EXTPOLL=1 \
			-DLWS_WITHOUT_TEST_PING=1 \
			-DLWS_WITHOUT_TEST_ECHO=1 \
			-DLWS_WITHOUT_TEST_CLIENT=1 \
 			-DLWS_WITHOUT_TEST_FRAGGLE=1 \
			-DLWS_IPV6=1 \
			-DLWS_ZLIB_LIBRARIES="${build_dir_root}/lib/libz.a" \
			-DLWS_ZLIB_INCLUDE_DIRS="${build_dir_root}/include" \
			-DLWS_OPENSSL_LIBRARIES="${build_dir_root}/lib64/libssl.a;${build_dir_root}/lib64/libcrypto.a" \
			-DLWS_OPENSSL_INCLUDE_DIRS="${build_dir_root}/include" \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi

	if [[ "$3" == "ohos" ]]; then
		local ohos_abi=
		local ohos_lib_dir=
        if [[ "$2" == "arm64-v8a" ]]; then
            ohos_abi=arm64-v8a
			ohos_lib_dir=lib
        fi  
        if [[ "$2" == "x86_64" ]]; then
            ohos_abi=x86_64
			ohos_lib_dir=lib64
        fi
		${LINUX_OHOS_NDK_CMAKE_PATH}/cmake  -G "Ninja" \
		-DCMAKE_BUILD_TYPE=${build_type} \
		-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
		-DCMAKE_PREFIX_PATH=${build_dir_root} \
		-DOHOS_STL=c++_shared \
		-DOHOS_ARCH=${ohos_abi} \
		-DCMAKE_TOOLCHAIN_FILE=${LINUX_OHOS_NDK_CMAKE_TOOLCHAIN_PATH} \
    	-DCMAKE_MAKE_PROGRAM=${LINUX_OHOS_NDK_CMAKE_PATH}/ninja \
		-DCMAKE_C_FLAGS="-Qunused-arguments -Wno-implicit-int-conversion" \
		-DCMAKE_CXX_FLAGS="-Qunused-arguments -Wno-implicit-int-conversion" \
			-DLWS_HAVE_EVP_MD_CTX_free=1 \
			-DLWS_HAVE_HMAC_CTX_new=1 \
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
		-DLWS_ZLIB_LIBRARIES="${build_dir_root}/lib/libz.a" \
		-DLWS_ZLIB_INCLUDE_DIRS="${build_dir_root}/include" \
		-DLWS_OPENSSL_LIBRARIES="${build_dir_root}/${ohos_lib_dir}/libssl.a;${build_dir_root}/${ohos_lib_dir}/libcrypto.a" \
		-DLWS_OPENSSL_INCLUDE_DIRS="${build_dir_root}/include" \
		../../../${lib_name}/${lib_source_dir}


		${LINUX_OHOS_NDK_CMAKE_PATH}/cmake --build . --config ${build_type} --target install


	fi

	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}
function build_curl {
	local build_type=$1
    local arch=$2
    local platform=$3
	#depends zlib
	#build_zlib ${build_type} ${arch} ${platform}
	#build_openssl ${build_type} ${arch} ${platform}
	local lib_name=curl
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=curl-8.4.0
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
			-A ${arch} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
		  	-DCURL_ZLIB=ON \
		   	-DUSE_OPENSSL=ON \
		   	-DENABLE_IPV6=ON \
			-DBUILD_SHARED_LIBS=OFF \
		   	-DBUILD_STATIC_LIBS=ON \
		   	-DBUILD_CURL_EXE=OFF \
		    -DBUILD_TESTING=OFF \
			-DZLIB_LIBRARIES="${build_dir_root}/lib" \
			-DZLIB_INCLUDE_DIRS="${build_dir_root}/include" \
	        -DOPENSSL_LIBRARIES="${build_dir_root}/lib64" \
			-DOPENSSL_INCLUDE_DIR="${build_dir_root}/include" \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi
     if [[ "$3" == "iphoneos" ]] || [[ "$3" == "iphonesimulator" ]]; then
	    cd ..
		cd ${build_dir}
        cmake \
            -G "Unix Makefiles" \
            -DCMAKE_BUILD_TYPE="${build_type}" \
            -DIOS_ARCH="${arch}" \
            -DPLATFORM_NAME="${platform}" \
            -DCMAKE_TOOLCHAIN_FILE=../../../CMake/clang/iOS.cmake \
            -DCMAKE_SYSTEM_NAME=iOS \
            -DCMAKE_INSTALL_PREFIX=${build_dir_root} \
            -DCMAKE_PREFIX_PATH=${build_dir_root} \
            -DCURL_ZLIB=ON \
            -DUSE_OPENSSL=ON \
            -DENABLE_IPV6=ON \
            -DBUILD_SHARED_LIBS=OFF \
            -DBUILD_STATIC_LIBS=ON \
            -DBUILD_CURL_EXE=OFF \
            -DBUILD_TESTING=OFF \
            -DZLIB_LIBRARIES="${build_dir_root}/lib" \
            -DZLIB_INCLUDE_DIRS="${build_dir_root}/include" \
            -DOPENSSL_LIBRARIES="${build_dir_root}/lib" \
            -DOPENSSL_INCLUDE_DIR="${build_dir_root}/include" \
            -DCMAKE_C_FLAGS="-Wno-implicit-function-declaration" \
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

		cd ..
		cd ${build_dir}
	
		cmake -G "Unix Makefiles" \
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
		  	-DCURL_ZLIB=ON \
		   	-DUSE_OPENSSL=ON \
		   	-DENABLE_IPV6=ON \
			-DBUILD_SHARED_LIBS=OFF \
		   	-DBUILD_STATIC_LIBS=ON \
		   	-DBUILD_CURL_EXE=OFF \
		    -DBUILD_TESTING=OFF \
			-DZLIB_LIBRARIES="${build_dir_root}/lib" \
			-DZLIB_INCLUDE_DIRS="${build_dir_root}/include" \
	        -DOPENSSL_LIBRARIES="${build_dir_root}/lib" \
			-DOPENSSL_INCLUDE_DIR="${build_dir_root}/include" \
			-DCMAKE_C_FLAGS="-Wno-implicit-function-declaration" \
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
		#export PKG_CONFIG_PATH="${build_dir_root}/lib64/pkgconfig:${PKG_CONFIG_PATH}"
		cd ${lib_source_dir}
		#./configure --prefix=${build_dir_root} --target=x86_64 --with-ssl=${build_dir_root} --with-zlib=${build_dir_root} --disable-shared
		#https://curl.se/docs/install.html
		#CPPFLAGS="-I${build_dir_root}/include" LDFLAGS="-L${build_dir_root}/lib64" ./configure --prefix=${build_dir_root} --target=x86_64 --with-zlib=${build_dir_root} --disable-shared
		export CPPFLAGS="-I${build_dir_root}/include"
		export LDFLAGS="-L${build_dir_root}/lib64" 
		./configure --prefix=${build_dir_root} --target=x86_64 --with-zlib=${build_dir_root} --with-openssl=${build_dir_root} --disable-shared
		make
		make install
	fi

	if [[ "$3" == "ohos" ]]; then
		cd ..
		cd ${build_dir}
		${LINUX_OHOS_NDK_CMAKE_PATH}/cmake  -G "Ninja" \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DOHOS_STL=c++_shared \
			-DOHOS_ARCH=arm64-v8a \
			-DCMAKE_TOOLCHAIN_FILE=${LINUX_OHOS_NDK_CMAKE_TOOLCHAIN_PATH} \
			-DCMAKE_FIND_ROOT_PATH=${build_dir_root} \
			-DCURL_ZLIB=ON \
		   	-DUSE_OPENSSL=ON \
		   	-DENABLE_IPV6=ON \
			-DBUILD_SHARED_LIBS=OFF \
		   	-DBUILD_STATIC_LIBS=ON \
		   	-DBUILD_CURL_EXE=OFF \
		    -DBUILD_TESTING=OFF \
			-DZLIB_LIBRARIES="${build_dir_root}/lib" \
			-DZLIB_INCLUDE_DIRS="${build_dir_root}/include" \
	        -DOPENSSL_LIBRARIES="${build_dir_root}/lib" \
			-DOPENSSL_INCLUDE_DIR="${build_dir_root}/include" \
			../../../${lib_name}/${lib_source_dir}
		
		${LINUX_OHOS_NDK_CMAKE_PATH}/cmake --build . --config ${build_type} --target install
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
	
	#静态库链接不上
	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "windows" ]]; then
	cmake . -G "Visual Studio 17 2022" \
			-A${arch} \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
            -DCMAKE_FIND_ROOT_PATH=${build_dir_root} \
			-DLIBTYPE=SHARED \
			-DALSOFT_EXAMPLES=0 \
			../../../${lib_name}/${lib_source_dir}

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

			cmake -G "Unix Makefiles" \
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
			-DLIBTYPE=STATIC \
			-DALSOFT_BACKEND_OPENSL=1 \
			-DALSOFT_BACKEND_WAVE=1 \
			-DALSOFT_INSTALL_AMBDEC_PRESETS=0 \
			-DALSOFT_EMBED_HRTF_DATA=0 \
			-DALSOFT_ENABLE_SSE2_CODEGEN=0 \
			-DALSOFT_EXAMPLES=0 \
			-DALSOFT_INSTALL_HRTF_DATA=0 \
			-DCMAKE_C_FLAGS=-fPIC \
			-DCMAKE_CXX_FLAGS=-fPIC \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi
	if [[ "$3" == "linux" ]]; then
		cmake . -G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
            -DCMAKE_FIND_ROOT_PATH=${build_dir_root} \
			-DLIBTYPE=STATIC \
			-DALSOFT_BACKEND_OPENSL=1 \
			-DALSOFT_BACKEND_WAVE=1 \
			-DALSOFT_INSTALL_AMBDEC_PRESETS=0 \
			-DALSOFT_EMBED_HRTF_DATA=0 \
			-DALSOFT_ENABLE_SSE2_CODEGEN=0 \
			-DALSOFT_EXAMPLES=0 \
			-DALSOFT_INSTALL_HRTF_DATA=0 \
			-DCMAKE_C_FLAGS=-fPIC \
			-DCMAKE_CXX_FLAGS=-fPIC \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi

	if [[ "$3" == "ohos" ]]; then
        local ohos_abi=
        if [[ "$2" == "arm64-v8a" ]]; then
            ohos_abi=arm64-v8a
        fi  
        if [[ "$2" == "x86_64" ]]; then
            ohos_abi=x86_64
        fi

        ${OHOS_NDK_CMAKE_PATH}/cmake  -G "Ninja" \
        -DCMAKE_BUILD_TYPE=${build_type} \
        -DCMAKE_INSTALL_PREFIX=${build_dir_root} \
        -DCMAKE_PREFIX_PATH=${build_dir_root} \
        -DLIBTYPE=STATIC \
		-DALSOFT_BACKEND_WAVE=1 \
		-DALSOFT_INSTALL_AMBDEC_PRESETS=0 \
		-DALSOFT_EMBED_HRTF_DATA=0 \
		-DALSOFT_EXAMPLES=0 \
		-DALSOFT_INSTALL_HRTF_DATA=0 \
        -DOHOS_STL=c++_shared \
        -DOHOS_ARCH=${ohos_abi} \
        -DCMAKE_TOOLCHAIN_FILE=${OHOS_NDK_CMAKE_TOOLCHAIN_PATH} \
        ../../../${lib_name}/${lib_source_dir}

        #make
        #make install
        ${OHOS_NDK_CMAKE_PATH}/cmake --build . --config ${build_type} --target install
    fi
	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}
function build_vorbis {
	local build_type=$1
    local arch=$2
    local platform=$3

	local lib_name=ogg
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=libvorbis-1.3.7
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	#cd ..
	#cd ${build_dir}
	

	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "linux" ]]; then
		cd ${lib_source_dir}

		./configure --prefix=${build_dir_root} --datarootdir="${build_dir_root}/share" --includedir="${build_dir_root}/include" --libdir="${build_dir_root}/lib" --target=x86_64 --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic
		make
		make install
	fi
    if [[ "$3" == "android" ]]; then
        local android_abi=
        cd ${lib_source_dir}
        if [[ "$2" == "aarch64" ]]; then
            android_abi=arm64-v8a


            # 设置 Android NDK 工具链路径
            export ANDROID_NDK_HOME=${CONCH_NDK_PATH}
            #export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH
			export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/windows-x86_64/bin:$PATH

            # 设置编译器
            export CC=aarch64-linux-android21-clang
            export CXX=aarch64-linux-android21-clang++
            export AR=llvm-ar
            export RANLIB=llvm-ranlib
            export STRIP=llvm-strip
            export LD=ld.lld

            # 设置编译标志
            export CFLAGS="-fPIC -D__ANDROID_API__=21"
            export CXXFLAGS="-fPIC -D__ANDROID_API__=21"
            export LDFLAGS="-fPIC"
        

            # 配置编译选项
            ./configure --prefix=${build_dir_root} --datarootdir="${build_dir_root}/share" --includedir="${build_dir_root}/include" --libdir="${build_dir_root}/lib" \
            --target=aarch64 --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic \
                   --host=aarch64-linux-android

            make clean
            make
            make install

        fi
    
        if [[ "$2" == "arm7" ]]; then
            android_abi=armeabi-v7a


            # 设置 Android NDK 工具链路径
            export ANDROID_NDK_HOME=${CONCH_NDK_PATH}
            export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH

            # 设置编译器
            export CC=armv7a-linux-androideabi21-clang
            export CXX=armv7a-linux-androideabi21-clang++
            export AR=llvm-ar
            export RANLIB=llvm-ranlib
            export STRIP=llvm-strip
            export LD=ld.lld

            # 设置编译标志
            export CFLAGS="-fPIC -D__ANDROID_API__=21"
            export CXXFLAGS="-fPIC -D__ANDROID_API__=21"
            export LDFLAGS="-fPIC"
        

            # 配置编译选项
            ./configure --prefix=${build_dir_root} --datarootdir="${build_dir_root}/share" --includedir="${build_dir_root}/include" --libdir="${build_dir_root}/lib" \
            --target=armv7a --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic \
                   --host=armv7a-linux-android

            make clean
            make
            make install

        fi
    
        if [[ "$2" == "x86" ]]; then
            android_abi=x86


            # 设置 Android NDK 工具链路径
            export ANDROID_NDK_HOME=${CONCH_NDK_PATH}
            #export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH
			export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/windows-x86_64/bin:$PATH

            # 设置编译器
            #export CC=i686-linux-android21-clang
            #export CXX=i686-linux-android21-clang++
            #export AR=llvm-ar
            #export RANLIB=llvm-ranlib
            #export STRIP=llvm-strip
            #export LD=ld.lld

            # 设置编译标志
            #export CFLAGS="-fPIC -D__ANDROID_API__=21"
            #export CXXFLAGS="-fPIC -D__ANDROID_API__=21"
            #export LDFLAGS="-fPIC"
        

            # 配置编译选项
            #./configure --prefix=${build_dir_root} \
            #--with-ogg=${build_dir_root} \
            #--datarootdir=${build_dir_root}/share \
            #--includedir=${build_dir_root}/include \
            #--libdir=${build_dir_root}/lib \
             #--target=i686 \
            # --program-prefix="" \
            # --enable-static \
            # --disable-shared \
            # --disable-dependency-tracking \
            # --with-pic \
            # --disable-oggtest \
            # --host=i686-linux-android

            #make clean
            #make
            #make install
            
    

        cd ..
        cd ${build_dir}
    
        cmake -G "Unix Makefiles" \
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
            ../../../${lib_name}/${lib_source_dir}

        cmake --build . --config ${build_type} --target install
    

        fi
    
        if [[ "$2" == "x86_64" ]]; then
            android_abi=x86_64


            # 设置 Android NDK 工具链路径
            export ANDROID_NDK_HOME=${CONCH_NDK_PATH}
            export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH

            # 设置编译器
            export CC=x86_64-linux-android21-clang
            export CXX=x86_64-linux-android21-clang++
            export AR=llvm-ar
            export RANLIB=llvm-ranlib
            export STRIP=llvm-strip
            export LD=ld.lld

            # 设置编译标志
            export CFLAGS="-fPIC -D__ANDROID_API__=21"
            export CXXFLAGS="-fPIC -D__ANDROID_API__=21"
            export LDFLAGS="-fPIC"
        

            # 配置编译选项
            ./configure --prefix=${build_dir_root} --datarootdir="${build_dir_root}/share" --includedir="${build_dir_root}/include" --libdir="${build_dir_root}/lib" \
            --target=x86_64 --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic \
                   --host=x86_64-linux-android

            make clean
            make
            make install
        fi
    fi

	if [[ "$3" == "ohos" ]]; then
	   cd ${lib_source_dir}
	 
	   local ohos_target=
	   local ohos_host=
        if [[ "$2" == "arm64-v8a" ]]; then
            ohos_target=aarch64-linux-ohos
			ohos_host=aarch64-linux-musl
        fi  
        if [[ "$2" == "x86_64" ]]; then
            ohos_target=x86_64-linux-ohos
			ohos_host=x86_64-linux-musl
        fi
		export OHOS_SDK=${OHOS_SDK_PATH}
		export AS=${OHOS_SDK}/native/llvm/bin/llvm-as
		export CC="${OHOS_SDK}/native/llvm/bin/clang --target=${ohos_target}"
		export CXX="${OHOS_SDK}/native/llvm/bin/clang++ --target=${ohos_target}"
		export LD=${OHOS_SDK}/native/llvm/bin/ld.lld
		export STRIP=${OHOS_SDK}/native/llvm/bin/llvm-strip
		export RANLIB=${OHOS_SDK}/native/llvm/bin/llvm-ranlib
		export OBJDUMP=${OHOS_SDK}/native/llvm/bin/llvm-objdump
		export OBJCOPY=${OHOS_SDK}/native/llvm/bin/llvm-objcopy
		export NM=${OHOS_SDK}/native/llvm/bin/llvm-nm
		export AR=${OHOS_SDK}/native/llvm/bin/llvm-ar
		export CFLAGS="-fPIC -D__MUSL__=1"
		export CXXFLAGS="-fPIC -D__MUSL__=1"

		./configure --prefix=${build_dir_root}  --host=${ohos_host}


		make clean
		make
		make install

	fi
	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}
function build_ogg {
	local build_type=$1
    local arch=$2
    local platform=$3

	local lib_name=ogg
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=libogg-1.3.2
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	#cd ..
	#cd ${build_dir}
	

	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "linux" ]]; then
		cd ${lib_source_dir}

		./configure --prefix=${build_dir_root} --target=x86_64 --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic
		make
		make install
	fi
     if [[ "$3" == "android" ]]; then
        local android_abi=
        cd ${lib_source_dir}
        if [[ "$2" == "aarch64" ]]; then
            android_abi=arm64-v8a


            # 设置 Android NDK 工具链路径
            export ANDROID_NDK_HOME=${CONCH_NDK_PATH}
            export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH

            # 设置编译器
            export CC=aarch64-linux-android21-clang
            export CXX=aarch64-linux-android21-clang++
            export AR=llvm-ar
            export RANLIB=llvm-ranlib
            export STRIP=llvm-strip
            export LD=ld.lld

            # 设置编译标志
            export CFLAGS="-fPIC -D__ANDROID_API__=21"
            export CXXFLAGS="-fPIC -D__ANDROID_API__=21"
            export LDFLAGS="-fPIC"
        

            # 配置编译选项
            ./configure --prefix=${build_dir_root} --target=aarch64 --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic \
                   --host=aarch64-linux-android

            make clean
            make
            make install

        fi
    
        if [[ "$2" == "arm7" ]]; then
            android_abi=armeabi-v7a


            # 设置 Android NDK 工具链路径
            export ANDROID_NDK_HOME=${CONCH_NDK_PATH}
            export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH

            # 设置编译器
            export CC=armv7a-linux-androideabi21-clang
            export CXX=armv7a-linux-androideabi21-clang++
            export AR=llvm-ar
            export RANLIB=llvm-ranlib
            export STRIP=llvm-strip
            export LD=ld.lld

            # 设置编译标志
            export CFLAGS="-fPIC -D__ANDROID_API__=21"
            export CXXFLAGS="-fPIC -D__ANDROID_API__=21"
            export LDFLAGS="-fPIC"
        

            # 配置编译选项
            ./configure --prefix=${build_dir_root} --target=armv7a --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic \
                   --host=armv7a-linux-android

            make clean
            make
            make install

        fi
    
        if [[ "$2" == "x86" ]]; then
            android_abi=x86


            # 设置 Android NDK 工具链路径
            export ANDROID_NDK_HOME=${CONCH_NDK_PATH}
            export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH
			#export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/windows-x86_64/bin:$PATH

            # 设置编译器
            export CC=i686-linux-android21-clang
            export CXX=i686-linux-android21-clang++
            export AR=llvm-ar
            export RANLIB=llvm-ranlib
            export STRIP=llvm-strip
            export LD=ld.lld

            # 设置编译标志
            export CFLAGS="-fPIC -D__ANDROID_API__=21"
            export CXXFLAGS="-fPIC -D__ANDROID_API__=21"
            export LDFLAGS="-fPIC"
        

            # 配置编译选项
            ./configure --prefix=${build_dir_root} --target=i686 --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic \
                   --host=i686-linux-android

            make clean
            make
            make install

        fi
    
        if [[ "$2" == "x86_64" ]]; then
            android_abi=x86_64


            # 设置 Android NDK 工具链路径
            export ANDROID_NDK_HOME=${CONCH_NDK_PATH}
            export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH

            # 设置编译器
            export CC=x86_64-linux-android21-clang
            export CXX=x86_64-linux-android21-clang++
            export AR=llvm-ar
            export RANLIB=llvm-ranlib
            export STRIP=llvm-strip
            export LD=ld.lld

            # 设置编译标志
            export CFLAGS="-fPIC -D__ANDROID_API__=21"
            export CXXFLAGS="-fPIC -D__ANDROID_API__=21"
            export LDFLAGS="-fPIC"
        

            # 配置编译选项
            ./configure --prefix=${build_dir_root} --target=x86_64 --program-prefix="" --enable-static --disable-shared --disable-dependency-tracking --with-pic \
                   --host=x86_64-linux-android

            make clean
            make
            make install
        fi
    fi


	if [[ "$3" == "ohos" ]]; then
	   cd ${lib_source_dir}
	 
	   local ohos_target=
	   local ohos_host=
        if [[ "$2" == "arm64-v8a" ]]; then
            ohos_target=aarch64-linux-ohos
			ohos_host=aarch64-linux-musl
        fi  
        if [[ "$2" == "x86_64" ]]; then
            ohos_target=x86_64-linux-ohos
			ohos_host=x86_64-linux-musl
        fi
		export OHOS_SDK=${OHOS_SDK_PATH}
		export AS=${OHOS_SDK}/native/llvm/bin/llvm-as
		export CC="${OHOS_SDK}/native/llvm/bin/clang --target=${ohos_target}"
		export CXX="${OHOS_SDK}/native/llvm/bin/clang++ --target=${ohos_target}"
		export LD=${OHOS_SDK}/native/llvm/bin/ld.lld
		export STRIP=${OHOS_SDK}/native/llvm/bin/llvm-strip
		export RANLIB=${OHOS_SDK}/native/llvm/bin/llvm-ranlib
		export OBJDUMP=${OHOS_SDK}/native/llvm/bin/llvm-objdump
		export OBJCOPY=${OHOS_SDK}/native/llvm/bin/llvm-objcopy
		export NM=${OHOS_SDK}/native/llvm/bin/llvm-nm
		export AR=${OHOS_SDK}/native/llvm/bin/llvm-ar
		export CFLAGS="-fPIC -D__MUSL__=1"
		export CXXFLAGS="-fPIC -D__MUSL__=1"

		./configure --prefix=${build_dir_root}  --host=${ohos_host}


		make clean
		make
		make install

	fi
	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}
function build_sdl {
	local build_type=$1
    local arch=$2
    local platform=$3

	local lib_name=sdl
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=SDL2-2.28.5
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	cd ..
	cd ${build_dir}
	
	#静态库链接不上
	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "windows" ]]; then
	cmake . -G "Visual Studio 17 2022" \
			-A ${arch} \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
            -DCMAKE_FIND_ROOT_PATH=${build_dir_root} \
			-DSDL_SHARED=OFF \
			-DSDL_STATIC=ON \
			../../../${lib_name}/${lib_source_dir}

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
		cmake . -G "Unix Makefiles" \
			-DSDL_STATIC_PIC=ON \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
            -DCMAKE_FIND_ROOT_PATH=${build_dir_root} \
			-DSDL_SHARED=OFF \
			-DSDL_STATIC=ON \
			-DSDL_X11=ON \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi
	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}
function build_benchmark {
	local build_type=$1
    local arch=$2
    local platform=$3

	local lib_name=benchmark
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=benchmark-1.8.3
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	cd ..
	cd ${build_dir}
	
	#静态库链接不上
	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "windows" ]]; then
	cmake . -G "Visual Studio 17 2022" \
			-A ${arch} \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
            -DCMAKE_FIND_ROOT_PATH=${build_dir_root} \
			-DBENCHMARK_ENABLE_TESTING=OFF \
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
			-DCMAKE_TOOLCHAIN_FILE=../../../CMake/clang/iOS.cmake \
			-DCMAKE_SYSTEM_NAME=iOS \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DHAVE_STEADY_CLOCK=0 \
			-DBENCHMARK_ENABLE_TESTING=OFF \
			../../../${lib_name}/${lib_source_dir}
		
		cmake --build . --config ${build_type} --target install
	fi
	if [[ "$3" == "ohos" ]]; then
		${OHOS_NDK_CMAKE_PATH}/cmake  -G "Ninja" \
		-DCMAKE_BUILD_TYPE=${build_type} \
		-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
		-DCMAKE_PREFIX_PATH=${build_dir_root} \
		-DOHOS_STL=c++_shared \
		-DCMAKE_TOOLCHAIN_FILE=${OHOS_NDK_CMAKE_TOOLCHAIN_PATH} \
    	-DCMAKE_MAKE_PROGRAM=${OHOS_NDK_CMAKE_PATH}/ninja \
		-DBENCHMARK_ENABLE_TESTING=OFF \
		../../../${lib_name}/${lib_source_dir}


		${OHOS_NDK_CMAKE_PATH}/cmake --build . --config ${build_type} --target install


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

		cmake -G "Unix Makefiles" \
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
			-DBENCHMARK_ENABLE_TESTING=OFF \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi
	if [[ "$3" == "linux" ]]; then
		cmake . -G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
            -DCMAKE_FIND_ROOT_PATH=${build_dir_root} \
			-DBENCHMARK_ENABLE_TESTING=OFF \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi
	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}
function build_spdlog {
	local build_type=$1
    local arch=$2
    local platform=$3

	local lib_name=spdlog
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=spdlog-1.12.0
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	cd ..
	cd ${build_dir}
	
	#静态库链接不上
	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "windows" ]]; then
	    cmake . -G "Visual Studio 17 2022" \
			-A ${arch} \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install	
	fi
	
	if [[ "$3" == "linux" ]]; then
		cmake . -G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi
	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}

function build_boost_regex {
	local build_type=$1
    local arch=$2
    local platform=$3

	local lib_name=boost
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}-regex"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=boost-1.84.0
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	cd ..
	
	
	#静态库链接不上
	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	#if [[ "$3" == "windows" ]]; then
		#commad below excute in windows console
		#cd E:\github\lib\boost\boost-1.84.0\boost-1.84.0\tools\build
		#.\bootstrap.bat
		# .\b2 install --prefix=E:/github/lib/build/windows-Release-x64
		#cd ${root_dir}/${lib_name}/${lib_source_dir}
		#E:/github/lib/build/windows-Release-x64加入PATH
		#b2 --build-dir=E:/github/lib/build/windows-Release-x64 toolset=msvc --with-regex --build-type=complete install
	#fi
	if [[ "$3" == "linux" ]]; then
	 	PATH="${build_dir_root}:${PATH}"
		cd ${root_dir}/${lib_name}/${lib_source_dir}/tools/build
		echo "bootstrap..."
		sudo  ./bootstrap.sh --with-libraries=regex --with-toolset=gcc
		echo "b2..."
		sudo ./b2 --build-dir="${build_dir_root}" toolset=gcc --with-regex --build-type=complete install
		echo "b2 install..."
		sudo  ./b2 install --prefix="${build_dir_root}"
		echo "over..."
	fi
	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}

function build_aki {
	local build_type=$1
    local arch=$2
    local platform=$3

	local lib_name=aki
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	#cd ohos-specific/aki

	#cd ..
	cd ${build_dir}
	


	if [[ "$3" == "ohos" ]]; then
		${OHOS_NDK_CMAKE_PATH}/cmake  -G "Ninja" \
		-DCMAKE_BUILD_TYPE=${build_type} \
		-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
		-DCMAKE_PREFIX_PATH=${build_dir_root} \
		-DOHOS_STL=c++_shared \
		-DCMAKE_TOOLCHAIN_FILE=${OHOS_NDK_CMAKE_TOOLCHAIN_PATH} \
		../../../ohos-specific/aki

		#make
		#make install
		${OHOS_NDK_CMAKE_PATH}/cmake --build . --config ${build_type} 
	fi

	#rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}
function build_tracy {
	local build_type=$1
    local arch=$2
    local platform=$3

	local lib_name=tracy
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=tracy-0.11.1
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	cd ..
	cd ${build_dir}
	
	#静态库链接不上
	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "windows" ]]; then
	cmake . -G "Visual Studio 17 2022" \
			-A ${arch} \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
            -DCMAKE_FIND_ROOT_PATH=${build_dir_root} \
			-DBUILD_SHARED_LIBS=OFF \
			-DTRACY_PORT=5958 \
			-DTRACY_ENABLE=ON \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install	
	fi
	
	if [[ "$3" == "iphoneos" ]] || [[ "$3" == "iphonesimulator" ]]; then

	cmake \
			-G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE="${build_type}" \
			-DIOS_ARCH="${arch}" \
			-DPLATFORM_NAME="${platform}" \
			-DCMAKE_TOOLCHAIN_FILE=../../../CMake/clang/iOS.cmake \
			-DCMAKE_SYSTEM_NAME=iOS \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DBUILD_SHARED_LIBS=OFF \
			-DTRACY_PORT=5958 \
			-DTRACY_ENABLE=ON \
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

		cmake -G "Unix Makefiles" \
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
			-DBUILD_SHARED_LIBS=OFF \
			-DTRACY_PORT=5958 \
			-DTRACY_ENABLE=ON \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi

	if [[ "$3" == "ohos" ]]; then
		${OHOS_NDK_CMAKE_PATH}/cmake  -G "Ninja" \
		-DCMAKE_BUILD_TYPE=${build_type} \
		-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
		-DCMAKE_PREFIX_PATH=${build_dir_root} \
		-DOHOS_STL=c++_shared \
		-DCMAKE_TOOLCHAIN_FILE=${OHOS_NDK_CMAKE_TOOLCHAIN_PATH} \
		-DBUILD_SHARED_LIBS=OFF \
		-DTRACY_PORT=5958 \
			-DTRACY_ENABLE=ON \
		../../../${lib_name}/${lib_source_dir}

		#make
		#make install
		${OHOS_NDK_CMAKE_PATH}/cmake --build . --config ${build_type} 
	fi

	if [[ "$3" == "linux" ]]; then
		cmake . -G "Unix Makefiles" \
			-DCMAKE_BUILD_TYPE=${build_type} \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
            -DCMAKE_FIND_ROOT_PATH=${build_dir_root} \
			-DBUILD_SHARED_LIBS=OFF \
			-DCMAKE_C_FLAGS=-fPIC \
			-DCMAKE_CXX_FLAGS=-fPIC \
			-DTRACY_PORT=5958 \
			-DTRACY_ENABLE=ON \
			../../../${lib_name}/${lib_source_dir}

		cmake --build . --config ${build_type} --target install
	fi
	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}
function build_sqlite {

	local build_type=$1
    local arch=$2
    local platform=$3

	local lib_name=sqlite
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=sqlite-src-3490100
	rm -rf ${lib_source_dir}
	unzip sqlite-src-3490100.zip

	#cd ..
	#cd ${build_dir}
	cd ${lib_source_dir}


	if [[ "$3" == "linux" ]]; then
		./configure --prefix=${build_dir_root}


		make
		make install
	fi

	if [[ "$3" == "ohos" ]]; then
	   local ohos_target=
        if [[ "$2" == "arm64-v8a" ]]; then
            ohos_target=aarch64-linux-ohos
        fi  
        if [[ "$2" == "x86_64" ]]; then
            ohos_target=x86_64-linux-ohos
        fi
		export OHOS_SDK=${OHOS_SDK_LINUX_PATH}
		export AS=${OHOS_SDK}/native/llvm/bin/llvm-as
		export CC="${OHOS_SDK}/native/llvm/bin/clang --target=${ohos_target}"
		export CXX="${OHOS_SDK}/native/llvm/bin/clang++ --target=${ohos_target}"
		export LD=${OHOS_SDK}/native/llvm/bin/ld.lld
		export STRIP=${OHOS_SDK}/native/llvm/bin/llvm-strip
		export RANLIB=${OHOS_SDK}/native/llvm/bin/llvm-ranlib
		export OBJDUMP=${OHOS_SDK}/native/llvm/bin/llvm-objdump
		export OBJCOPY=${OHOS_SDK}/native/llvm/bin/llvm-objcopy
		export NM=${OHOS_SDK}/native/llvm/bin/llvm-nm
		export AR=${OHOS_SDK}/native/llvm/bin/llvm-ar
		export CFLAGS="-fPIC -D__MUSL__=1"
		export CXXFLAGS="-fPIC -D__MUSL__=1"

		./configure --prefix=${build_dir_root}


		make
		make install
	fi
	

	if [[ "$3" == "android" ]]; then
		local android_abi=
		if [[ "$2" == "aarch64" ]]; then
			android_abi=arm64-v8a


			# 设置 Android NDK 工具链路径
            export ANDROID_NDK_HOME=${CONCH_NDK_PATH}
            export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH

            # 设置编译器
            export CC=aarch64-linux-android21-clang
            export CXX=aarch64-linux-android21-clang++
            export AR=llvm-ar
            export RANLIB=llvm-ranlib
            export STRIP=llvm-strip
            export LD=ld.lld

            # 设置编译标志
            export CFLAGS="-fPIC -D__ANDROID_API__=21"
            export CXXFLAGS="-fPIC -D__ANDROID_API__=21"
            export LDFLAGS="-fPIC"
        

        	# 配置编译选项
        	./configure --prefix=${build_dir_root} \
           		--host=aarch64-linux-android

        	make clean
        	make
			make install

		fi
	
		if [[ "$2" == "arm7" ]]; then
			android_abi=armeabi-v7a


			# 设置 Android NDK 工具链路径
            export ANDROID_NDK_HOME=${CONCH_NDK_PATH}
            export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH

            # 设置编译器
            export CC=armv7a-linux-androideabi21-clang
            export CXX=armv7a-linux-androideabi21-clang++
            export AR=llvm-ar
            export RANLIB=llvm-ranlib
            export STRIP=llvm-strip
            export LD=ld.lld

            # 设置编译标志
            export CFLAGS="-fPIC -D__ANDROID_API__=21"
            export CXXFLAGS="-fPIC -D__ANDROID_API__=21"
            export LDFLAGS="-fPIC"
        

        	# 配置编译选项
        	./configure --prefix=${build_dir_root} \
           		--host=armv7a-linux-android

        	make clean
        	make
			make install

		fi
	
		if [[ "$2" == "x86" ]]; then
			android_abi=x86


			# 设置 Android NDK 工具链路径
            export ANDROID_NDK_HOME=${CONCH_NDK_PATH}
            export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH

            # 设置编译器
            export CC=i686-linux-android21-clang
            export CXX=i686-linux-android21-clang++	
            export AR=llvm-ar
            export RANLIB=llvm-ranlib
            export STRIP=llvm-strip
            export LD=ld.lld

            # 设置编译标志
            export CFLAGS="-fPIC -D__ANDROID_API__=21"
            export CXXFLAGS="-fPIC -D__ANDROID_API__=21"
            export LDFLAGS="-fPIC"
        

        	# 配置编译选项
        	./configure --prefix=${build_dir_root} \
           		--host=i686-linux-android

        	make clean
        	make
			make install

		fi
	
		if [[ "$2" == "x86_64" ]]; then
			android_abi=x86_64


			# 设置 Android NDK 工具链路径
            export ANDROID_NDK_HOME=${CONCH_NDK_PATH}
            export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH

            # 设置编译器
            export CC=x86_64-linux-android21-clang
            export CXX=x86_64-linux-android21-clang++
            export AR=llvm-ar
            export RANLIB=llvm-ranlib
            export STRIP=llvm-strip
            export LD=ld.lld

            # 设置编译标志
            export CFLAGS="-fPIC -D__ANDROID_API__=21"
            export CXXFLAGS="-fPIC -D__ANDROID_API__=21"
            export LDFLAGS="-fPIC"
        

        	# 配置编译选项
        	./configure --prefix=${build_dir_root} \
           		--host=x86_64-linux-android

        	make clean
        	make
			make install
		fi


	fi

	#rm -rf ${root_dir}/${lib_name}
	cd ${root_dir}

}
function build_mbedtls {
	local build_type=$1
    local arch=$2
    local platform=$3

	local lib_name=mbedtls
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=mbedtls-mbedtls-3.6.3
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	cd ..
	cd ${build_dir}
	

	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "windows" ]]; then	
	
		cmake . -G "Visual Studio 17 2022" \
			-A ${arch} \
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
			-DCMAKE_TOOLCHAIN_FILE=../../../CMake/clang/iOS.cmake \
			-DCMAKE_SYSTEM_NAME=iOS \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DBUILD_SHARED_LIBS=OFF \
			../../../${lib_name}/${lib_source_dir}
		
		cmake --build . --config ${build_type} --target install
	fi
	
	if [[ "$3" == "ohos" ]]; then
		${OHOS_NDK_CMAKE_PATH}/cmake  -G "Ninja" \
		-DCMAKE_BUILD_TYPE=${build_type} \
		-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
		-DCMAKE_PREFIX_PATH=${build_dir_root} \
		-DOHOS_STL=c++_shared \
		-DOHOS_ARCH=${ohos_abi} \
		-DCMAKE_TOOLCHAIN_FILE=${OHOS_NDK_CMAKE_TOOLCHAIN_PATH} \
    	-DCMAKE_MAKE_PROGRAM=${OHOS_NDK_CMAKE_PATH}/ninja \
		-DCMAKE_C_FLAGS=-Qunused-arguments \
		-DCMAKE_CXX_FLAGS=-Qunused-arguments \
		../../../${lib_name}/${lib_source_dir}


		${OHOS_NDK_CMAKE_PATH}/cmake --build . --config ${build_type} --target install


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
			-DCMAKE_C_FLAGS=-fPIC \
			-DCMAKE_CXX_FLAGS=-fPIC \
			-DCMAKE_BUILD_TYPE="${build_type}" \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DBUILD_SHARED_LIBS=OFF \
			../../../${lib_name}/${lib_source_dir}
		
		cmake --build . --config ${build_type} --target install
	fi

	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}

function build_googletest {
	local build_type=$1
    local arch=$2
    local platform=$3

	local lib_name=googletest
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=googletest-1.17.0
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	cd ..
	cd ${build_dir}
	

	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "windows" ]]; then	
	
		cmake . -G "Visual Studio 17 2022" \
			-A ${arch} \
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
			-DCMAKE_TOOLCHAIN_FILE=../../../CMake/clang/iOS.cmake \
			-DCMAKE_SYSTEM_NAME=iOS \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DBUILD_SHARED_LIBS=OFF \
			../../../${lib_name}/${lib_source_dir}
		
		cmake --build . --config ${build_type} --target install
	fi
	
	if [[ "$3" == "ohos" ]]; then
		${OHOS_NDK_CMAKE_PATH}/cmake  -G "Ninja" \
		-DCMAKE_BUILD_TYPE=${build_type} \
		-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
		-DCMAKE_PREFIX_PATH=${build_dir_root} \
		-DOHOS_STL=c++_shared \
		-DCMAKE_TOOLCHAIN_FILE=${OHOS_NDK_CMAKE_TOOLCHAIN_PATH} \
    	-DCMAKE_MAKE_PROGRAM=${OHOS_NDK_CMAKE_PATH}/ninja \
		-DCMAKE_C_FLAGS=-Qunused-arguments \
		-DCMAKE_CXX_FLAGS=-Qunused-arguments \
		../../../${lib_name}/${lib_source_dir}


		${OHOS_NDK_CMAKE_PATH}/cmake --build . --config ${build_type} --target install


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
			-DCMAKE_C_FLAGS=-fPIC \
			-DCMAKE_CXX_FLAGS=-fPIC \
			-DCMAKE_BUILD_TYPE="${build_type}" \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DBUILD_SHARED_LIBS=OFF \
			../../../${lib_name}/${lib_source_dir}
		
		cmake --build . --config ${build_type} --target install
	fi

	rm -rf ${root_dir}/${lib_name}/${lib_source_dir}
	cd ${root_dir}
}

function build_libwebp {
	local build_type=$1
    local arch=$2
    local platform=$3

	local lib_name=libwebp
	local build_dir_root="${root_dir}/build/${platform}-${build_type}-${arch}"
    local build_dir="${build_dir_root}/${lib_name}"
	mkdir -p "${build_dir}"
	cd ${lib_name}
	local lib_source_dir=libwebp-1.6.0
	rm -rf ${lib_source_dir}
	tar xvzf ${lib_source_dir}.tar.gz

	cd ..
	cd ${build_dir}
	

	#-DPLATFORM_NAME="${platform}"
	#-DCMAKE_BUILD_TYPE=${build_type} 
	if [[ "$3" == "windows" ]]; then	
	
		cmake . -G "Visual Studio 17 2022" \
			-A ${arch} \
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
			-DCMAKE_TOOLCHAIN_FILE=../../../CMake/clang/iOS.cmake \
			-DCMAKE_SYSTEM_NAME=iOS \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DBUILD_SHARED_LIBS=OFF \
			../../../${lib_name}/${lib_source_dir}
		
		cmake --build . --config ${build_type} --target install
	fi
	
	if [[ "$3" == "ohos" ]]; then
		local ohos_abi=
        if [[ "$2" == "arm64-v8a" ]]; then
            ohos_abi=arm64-v8a
        fi  
        if [[ "$2" == "x86_64" ]]; then
            ohos_abi=x86_64
        fi
		${OHOS_NDK_CMAKE_PATH}/cmake  -G "Ninja" \
		-DCMAKE_BUILD_TYPE=${build_type} \
		-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
		-DCMAKE_PREFIX_PATH=${build_dir_root} \
		-DOHOS_STL=c++_shared \
		-DOHOS_ARCH=${ohos_abi} \
		-DCMAKE_TOOLCHAIN_FILE=${OHOS_NDK_CMAKE_TOOLCHAIN_PATH} \
    	-DCMAKE_MAKE_PROGRAM=${OHOS_NDK_CMAKE_PATH}/ninja \
		-DCMAKE_C_FLAGS=-Qunused-arguments \
		-DCMAKE_CXX_FLAGS=-Qunused-arguments \
		../../../${lib_name}/${lib_source_dir}


		${OHOS_NDK_CMAKE_PATH}/cmake --build . --config ${build_type} --target install


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
			-DCMAKE_C_FLAGS=-fPIC \
			-DCMAKE_CXX_FLAGS=-fPIC \
			-DCMAKE_BUILD_TYPE="${build_type}" \
			-DCMAKE_INSTALL_PREFIX=${build_dir_root} \
			-DCMAKE_PREFIX_PATH=${build_dir_root} \
			-DBUILD_SHARED_LIBS=OFF \
			-DWEBP_BUILD_CWEBP=OFF  \
			-DWEBP_BUILD_DWEBP=OFF \
			-DWEBP_BUILD_IMG2WEBP=OFF \
			-DWEBP_BUILD_WEBPINFO=OFF \
			-DWEBP_BUILD_WEBPMUX=OFF \
			-DWEBP_BUILD_EXTRAS=OFF \
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
	lipo -create  "${build_dir0}/lib/libbenchmark_main.a"  "${build_dir1}/lib/libbenchmark_main.a"  -output "${root_dir}/build/ios-fat/libbenchmark_main.a"
	lipo -create  "${build_dir0}/lib/libbenchmark.a"  "${build_dir1}/lib/libbenchmark.a"  -output "${root_dir}/build/ios-fat/libbenchmark.a"
	lipo -create  "${build_dir0}/lib/libTracyClient.a"  "${build_dir1}/lib/libTracyClient.a"  -output "${root_dir}/build/ios-fat/libTracyClient.a"
	lipo -create  "${build_dir0}/lib/libcrypto.a"  "${build_dir1}/lib/libcrypto.a"  -output "${root_dir}/build/ios-fat/libcrypto.a"
	lipo -create  "${build_dir0}/lib/libssl.a"  "${build_dir1}/lib/libssl.a"  -output "${root_dir}/build/ios-fat/libssl.a"
	lipo -create  "${build_dir0}/lib/libcurl.a"  "${build_dir1}/lib/libcurl.a"  -output "${root_dir}/build/ios-fat/libcurl.a"
	lipo -create  "${build_dir0}/lib/libsharpyuv.a"  "${build_dir1}/lib/libsharpyuv.a"  -output "${root_dir}/build/ios-fat/libsharpyuv.a"
	lipo -create  "${build_dir0}/lib/libwebp.a"  "${build_dir1}/lib/libwebp.a"  -output "${root_dir}/build/ios-fat/libwebp.a"
	lipo -create  "${build_dir0}/lib/libwebpdecoder.a"  "${build_dir1}/lib/libwebpdecoder.a"  -output "${root_dir}/build/ios-fat/libwebpdecoder.a"
	lipo -create  "${build_dir0}/lib/libwebpmux.a"  "${build_dir1}/lib/libwebpmux.a"  -output "${root_dir}/build/ios-fat/libwebpmux.a"
}
function clean {
    echo "Cleaning build directories..."
    rm -Rf ${root_dir}/build
}


#check_android_environment


#zlib ohos
#build_zlib release arm64-v8a ohos
#build_zlib release x86_64 ohos

#zlib ios
#build_zlib release arm64 iphoneos
#build_zlib release arm64 iphonesimulator
#archive_ios_lib release zlib

#build_png Release "win32" windows
#build_png Release "win64" windows
#build_png release "x86_64" linux


#build_glslang Release "win64" windows

#build_glslang release "aarch64" android
#build_glslang release "arm7" android
#build_glslang release "x86_64" android
#build_glslang release "x86" android

#build_glslang release arm64-v8a ohos
#build_glslang release x86_64 ohos


#build_zip release arm64-v8a ohos
#build_zip release x86_64 ohos


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

#
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

#build_tracy Release "x64" windows
#build_tracy Debug "x64" windows

#build_tracy release arm64 iphoneos
#build_tracy release x86_64 iphonesimulator
#archive_ios release iphoneos arm64 iphonesimulator x86_64


#build_tracy release "aarch64" android
#build_tracy release "arm7" android
#build_tracy release "x86_64" android
#build_tracy release "x86" android
#build_tracy release "x86_64" linux

#build_tracy release "arm64" ohos


#build_freetype release arm64 iphoneos
#build_freetype release x86_64 iphonesimulator
#archive_ios release iphoneos arm64 iphonesimulator x86_64

#build_swappy release "arm7" android
#build_swappy release "x86_64" android
#build_swappy release "x86" android
#build_swappy release "aarch64" android


#build_freetype release "arm7" android
#build_freetype release "x86_64" android
#build_freetype release "x86" android
#build_freetype release "aarch64" android


#build_freetype release "x86_64" linux


#build_mpg123 release "x86_64" linux


#build_mpg123 release arm64-v8a ohos
#build_mpg123 release x86_64 ohos
	
#build_jpeg release "x86_64" linux
#build_jpeg release arm64 iphoneos
#build_jpeg release x86_64 iphonesimulator
#archive_ios release iphoneos arm64 iphonesimulator x86_64

#build_png release "aarch64" android
#build_png release "arm7" android
#build_png release "x86_64" android
#build_png release "x86" android

#build_png release arm64-v8a ohos
#build_png release x86_64 ohos


#build_zlib Release "x64" windows
#build_zlib release arm64 iphoneos
#build_zlib release x86_64 iphonesimulator
#build_zlib release "aarch64" android
#build_zlib release "arm7" android
#build_zlib release "x86_64" android
#build_zlib release "x86" android
#build_zlib release "x86_64" linux

#build_jxl release "arm64" ohos
#build_sqlite release "x86_64" linux
#build_sqlite release "arm64" ohos



#build_sqlite release "aarch64" android
#build_sqlite release "arm7" android
#build_sqlite release "x86_64" android
#build_sqlite release "x86" android

#build_sqlite release arm64-v8a ohos
#build_sqlite release x86_64 ohos

#build_jxl release "x86_64" android
#build_jxl release arm64 iphoneos
#build_jxl release x86_64 iphonesimulator
#archive_ios release iphoneos arm64 iphonesimulator x86_64
#build_jxl release arm64 ohos

#build_websocket release "x86_64" android
#build_websocket  release "x86_64" linux

#build_openssl release arm64-v8a ohos
#build_websocket release arm64-v8a ohos

#build_openssl release x86_64 ohos
#build_websocket release x86_64 ohos



#build_openssl release arm64 iphoneos
#build_openssl release x86_64 iphonesimulator
#build_websocket release arm64 iphoneos
#build_websocket release x86_64 iphonesimulator

#build_openssl release arm7 android
#build_websocket release arm7 android

#build_openssl release aarch64 android
#build_websocket release aarch64 android

#build_openssl release x86_64 android
#build_websocket release x86_64 android

#build_openssl release x86 android
#build_websocket release x86 android

#build_ogg  release aarch64 android
#build_ogg  release arm7 android
#build_ogg  release x86 android
#build_ogg  release x86_64 android


#build_ogg release arm64-v8a ohos
#build_ogg release x86_64 ohos

#build_vorbis  release aarch64 android
#build_vorbis  release arm7 android
#build_vorbis  release x86 android
#build_vorbis  release x86_64 android


#build_vorbis release arm64-v8a ohos
#build_vorbis release x86_64 ohos


#archive_ios_lib release crypto
#archive_ios_lib release ssl
#archive_ios_lib release websockets


#build_googletest Release "x64" windows
#build_googletest Debug "x64" windows
#build_googletest release arm64 ohos

#build_googletest release "x86_64" linux


#build_googletest release "aarch64" android
#build_googletest release "arm7" android
#build_googletest release "x86_64" android
#build_googletest release "x86" android


#build_googletest release arm64 iphoneos
#build_googletest release x86_64 iphonesimulator
#archive_ios_lib release gtest
#archive_ios_lib release gtest_main
#archive_ios_lib release gmock
#archive_ios_lib release gmock_main




#build_mbedtls Release "x64" windows

#build_mbedtls Debug "x64" windows


#build_mbedtls release "x86_64" linux


build_mbedtls release arm64-v8a ohos
build_mbedtls release x86_64 ohos

#build_mbedtls release "aarch64" android
#build_mbedtls release "arm7" android
#build_mbedtls release "x86_64" android
#build_mbedtls release "x86" android



#build_mbedtls release arm64 iphoneos
#build_mbedtls release x86_64 iphonesimulator
#archive_ios_lib release mbedcrypto
#archive_ios_lib release mbedtls

#build_curl Release "x64" windows

#build_zlib release "x86_64" android
#build_openssl release "x86_64" android
#build_curl release "x86_64" android


#build_zlib release "x86" android
#build_openssl release "x86" android
#build_curl release "x86" android

#build_zlib release "arm7" android
#build_openssl release "arm7" android
#build_curl release "arm7" android


#build_zlib release "aarch64" android
#build_openssl release "aarch64" android
#build_curl release "aarch64" android

#build_openssl release "x86_64" linux
#build_websocket release "x86_64" linux

#build_benchmark release arm64 ohos
#build_mpg123 release "arm7" android

#build_zlib release arm64 iphoneos
#build_openssl release arm64 iphoneos
#build_curl release arm64 iphoneos

#build_zlib release x86_64 iphonesimulator
#build_openssl release x86_64 iphonesimulator
#build_curl release x86_64 iphonesimulator

#archive_ios_lib release crypto
#archive_ios_lib release ssl
#archive_ios_lib release z
#archive_ios_lib release curl

#build_benchmark release "aarch64" android
#build_benchmark release "arm7" android
#build_benchmark release "x86" android
#build_benchmark release "x86_64" android


#build_googletest release "aarch64" android
#build_googletest release "arm7" android
#build_googletest release "x86" android
#build_googletest release "x86_64" android


#build_openal release "aarch64" android
#build_openal release "arm7" android
#build_openal release "x86" android
#build_openal release "x86_64" android

#build_openal release arm64-v8a ohos
#build_openal release x86_64 ohos


#build_libwebp Release "x64" windows

#build_libwebp release arm64-v8a ohos
#build_libwebp release x86_64 ohos


#build_libwebp release "aarch64" android
#build_libwebp release "arm7" android
#build_libwebp release "x86" android
#build_libwebp release "x86_64" android


#build_libwebp release arm64 iphoneos
#build_libwebp release x86_64 iphonesimulator
#archive_ios release iphoneos arm64 iphonesimulator x86_64

#build_libwebp release "x86_64" linux
