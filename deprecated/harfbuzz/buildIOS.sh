
ICU_ROOT=$(pwd)

rm -rf Contrib

mkdir Contrib
cd Contrib

tar xvzf ../harfbuzz-2.6.4.tar
cd harfbuzz-2.6.4

 ./autogen.sh
cd $ICU_ROOT
./configure_x86_64.sh

./autogen.sh
cd $ICU_ROOT
./configure_arm64.sh


./autogen.sh
cd $ICU_ROOT
./configure_armv7.sh

./autogen.sh
cd $ICU_ROOT
./configure_i386.sh


cd $ICU_ROOT
echo "Combining x86 64, armv7, i386, and arm64 libraries."

./make_universal.sh
