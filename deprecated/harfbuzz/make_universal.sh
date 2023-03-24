cd Contrib

lipo -create install-ios/armv7/lib/libharfbuzz-icu.a install-ios/arm64/lib/libharfbuzz-icu.a install-ios/x86_64/lib/libharfbuzz-icu.a install-ios/i386/lib/libharfbuzz-icu.a -output install-ios/libharfbuzz-icu.a
lipo -create install-ios/armv7/lib/libharfbuzz.a install-ios/arm64/lib/libharfbuzz.a install-ios/x86_64/lib/libharfbuzz.a install-ios/i386/lib/libharfbuzz.a -output install-ios/libharfbuzz.a
lipo -create install-ios/armv7/lib/libharfbuzz-subset.a install-ios/arm64/lib/libharfbuzz-subset.a install-ios/x86_64/lib/libharfbuzz-subset.a install-ios/i386/lib/libharfbuzz-subset.a -output install-ios/libharfbuzz-subset.a
