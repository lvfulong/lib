OUTPUT_PATH=build-universal

mkdir -p "$OUTPUT_PATH"

lipo -create -output "$OUTPUT_PATH/libicutu.a" "Contrib/build-arm64/lib/libicutu.a" "Contrib/build-armv7/lib/libicutu.a"  "Contrib/build-x86_64/lib/libicutu.a"
lipo -create -output "$OUTPUT_PATH/libicudata.a" "Contrib/build-arm64/lib/libicudata.a" "Contrib/build-armv7/lib/libicudata.a" "Contrib/build-x86_64/lib/libicudata.a"
lipo -create -output "$OUTPUT_PATH/libicui18n.a" "Contrib/build-arm64/lib/libicui18n.a" "Contrib/build-armv7/lib/libicui18n.a" "Contrib/build-x86_64/lib/libicui18n.a"
lipo -create -output "$OUTPUT_PATH/libicuio.a" "Contrib/build-arm64/lib/libicuio.a" "Contrib/build-armv7/lib/libicuio.a" "Contrib/build-x86_64/lib/libicuio.a"
lipo -create -output "$OUTPUT_PATH/libicuuc.a" "Contrib/build-arm64/lib/libicuuc.a" "Contrib/build-armv7/lib/libicuuc.a" "Contrib/build-x86_64/lib/libicuuc.a"
