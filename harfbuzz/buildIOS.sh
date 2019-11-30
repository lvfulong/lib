
ICU_ROOT=$(pwd)

rm -rf Contrib

mkdir Contrib
cd Contrib

tar xvzf ../harfbuzz-2.6.4.tar
cd harfbuzz-2.6.4
 ./autogen.sh
 
cd $ICU_ROOT
./configure_x86_64.sh


#cd $ICU_ROOT
#cd Contrib
#../configure_arm64.sh
#mkdir -p build-arm64 && cd build-arm64 && gnumake


#cd $ICU_ROOT
#cd Contrib
#../configure_armv7.sh
#mkdir -p build-armv7 && cd build-armv7 && gnumake



#cd $ICU_ROOT
#echo "Combining x86 64, armv7, armv7s, and arm64 libraries."

#./make_universal.sh
