mkdir android
cd android
../icu/source/runConfigureICU MacOSX --prefix=`pwd`/prebuilts CFLAGS="-Os" CXXFLAGS="--std=c++11" --enable-static --enable-shared=no --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no --enable-layoutex=no --enable-tools=no --enable-tests=no --enable-samples=no --enable-dyload=no
gnumake