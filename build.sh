
local build_dir="build/ios-release-aarch64"
mkdir -p "${build_dir}"


function buildZlibiOS {
	cd zlib
	rm -rf libzip.tar.gz
	wget -c https://libzip.org/download/libzip-1.9.2.tar.gz -O libzip.tar.gz
	tar xvzf libzip.tar.gz
	cd ..
	
	cd ${build_dir}
	
	cmake \
	-G "Unix Makefiles" \
	-DCMAKE_BUILD_TYPE=release \
	-DIOS_ARCH=aarch64 \
	-DPLATFORM_NAME=iphoneos \
	-DIOS=1 \
	-DCMAKE_TOOLCHAIN_FILE=../CMake/clang/iOS.cmake \
	-DCMAKE_SYSTEM_NAME=iOS \
	../../zlib/libzip

	#cmake --build .
	make
	cd ../..
}


buildZlibiOS