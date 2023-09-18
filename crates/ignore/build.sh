# build-rust.sh

#!/bin/bash

set -e

THISDIR=$(dirname $0)
cd $THISDIR
CONFIGURATION=${1:-release}

export SWIFT_BRIDGE_OUT_DIR="$(pwd)/generated"
export MACOSX_DEPLOYMENT_TARGET=11.0
# Build the project for the desired platforms:
cargo build --target x86_64-apple-darwin --release
cargo build --target aarch64-apple-darwin --release
cargo build --target aarch64-apple-ios --release
cargo build --target aarch64-apple-ios-sim --release
mkdir -p ./target/universal-macos/$CONFIGURATION

lipo \
    ../../target/aarch64-apple-darwin/$CONFIGURATION/libignore.a \
    ../../target/x86_64-apple-darwin/$CONFIGURATION/libignore.a -create -output \
    ./target/universal-macos/$CONFIGURATION/libignore.a

swift-bridge-cli create-package \
--bridges-dir ./generated \
--out-dir Ignore \
--macos target/universal-macos/$CONFIGURATION/libignore.a \
--simulator ../../target/aarch64-apple-ios-sim/$CONFIGURATION/libignore.a \
--ios ../../target/aarch64-apple-ios/$CONFIGURATION/libignore.a \
--name Ignore

cp target/universal-macos/$CONFIGURATION/libignore.a Ignore/RustXcframework.xcframework/macos-arm64_x86_64/libignore.a
