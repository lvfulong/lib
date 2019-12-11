
ICU_ROOT=$(pwd)

rm -rf Contrib

mkdir Contrib
cd Contrib

tar xvzf ../icu4c-65_1-src.tgz

../configure_AndroidHost.sh
mkdir -p build-host && cd build-host && gnumake

cd $ICU_ROOT
cd Contrib
../buildAndroidArm.sh
mkdir -p build-x86_64 && cd build-x86_64 && gnumake

#cd $ICU_ROOT
#cd Contrib
#../configure_arm64.sh
#mkdir -p build-arm64 && cd build-arm64 && gnumake


#cd $ICU_ROOT
#cd Contrib
#../configure_armv7.sh
#mkdir -p build-armv7 && cd build-armv7 && gnumake


#cd $ICU_ROOT
#cd Contrib
#../configure_i386.sh
#mkdir -p build-i386 && cd build-i386 && gnumake

