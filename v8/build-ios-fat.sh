#!/bin/bash

./build-ios.sh arm64 device
./build-ios.sh x64 simulator

rm -rf iosFat
mkdir iosFat
lipo -create ./out/ios_arm64/obj/libv8_monolith.a ./out/ios_x64/obj/libv8_monolith.a -output ./iosFat/libv8_monolith.a

