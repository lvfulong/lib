mkdir -p build-host && cd build-host
ICU_PATH="$(pwd)/../icu"

export CXXFLAGS="-stdlib=libc++ -std=c++11 -DNDEBUG"
export LDFLAGS="-stdlib=libc++  -lstdc++"

sh $ICU_PATH/source/configure --enable-static --disable-shared
