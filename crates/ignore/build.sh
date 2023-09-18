# build-rust.sh

#!/bin/bash

set -e

camelToSnakeCase() {
    echo "$@" | sed -r 's/([A-Z])/_\1/g' | tr '[:upper:]' '[:lower:]' | sed -r 's/^_//'
}

THISDIR=$(dirname $0)
cd $THISDIR
CONFIGURATION=${1:-release}
LIBNAME=Ignore
RUSTLIBNAME=$(camelToSnakeCase $LIBNAME)

export SWIFT_BRIDGE_OUT_DIR="$(pwd)/generated"
export MACOSX_DEPLOYMENT_TARGET=11.0
# Build the project for the desired platforms:
cargo build --target x86_64-apple-darwin --release
cargo build --target aarch64-apple-darwin --release
cargo build --target aarch64-apple-ios --release
cargo build --target aarch64-apple-ios-sim --release
mkdir -p ../../target/universal-macos/$CONFIGURATION

lipo \
    ../../target/aarch64-apple-darwin/$CONFIGURATION/lib$RUSTLIBNAME.a \
    ../../target/x86_64-apple-darwin/$CONFIGURATION/lib$RUSTLIBNAME.a -create -output \
    ../../target/universal-macos/$CONFIGURATION/lib$LIBNAME.a

cp ../../target/aarch64-apple-ios-sim/$CONFIGURATION/lib$RUSTLIBNAME.a ../../target/aarch64-apple-ios-sim/$CONFIGURATION/lib$LIBNAME.a || true
cp ../../target/aarch64-apple-ios/$CONFIGURATION/lib$RUSTLIBNAME.a ../../target/aarch64-apple-ios/$CONFIGURATION/lib$LIBNAME.a || true

rm -rf $LIBNAME/$LIBNAME'Rust.xcframework'
swift-bridge-cli create-package \
--bridges-dir ./generated \
--out-dir $LIBNAME \
--macos ../../target/universal-macos/$CONFIGURATION/lib$LIBNAME.a \
--simulator ../../target/aarch64-apple-ios-sim/$CONFIGURATION/lib$LIBNAME.a \
--ios ../../target/aarch64-apple-ios/$CONFIGURATION/lib$LIBNAME.a \
--name $LIBNAME

cp ../../target/universal-macos/$CONFIGURATION/lib$LIBNAME.a $LIBNAME/RustXcframework.xcframework/macos-arm64_x86_64/lib$LIBNAME.a
mv $LIBNAME/RustXcframework.xcframework $LIBNAME/$LIBNAME'Rust.xcframework'
cp utils.swift $LIBNAME/Sources/$LIBNAME/
rg -l RustXcframework $LIBNAME/ | sad --commit RustXcframework $LIBNAME'Rust'
swiftformat --exclude $LIBNAME/Sources/$LIBNAME/SwiftBridgeCore.swift $LIBNAME
