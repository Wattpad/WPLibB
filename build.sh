#!/bin/sh

# Setup before build starts

PROJECT_DIR=`pwd`
BUILD_ROOT_DIR="build"
IOS_TOOLCHAIN="$PROJECT_DIR/iOS.cmake"
IOS_DEPLOYMENT_TARGET="7.0"

# Process arguments
CONFIG=""
TARGET=""

function usage() {
    echo "Usage"
    echo ""
    echo "  build.sh config target"
    echo "  build.sh --help"
    echo ""
    echo "Supported configs"
    echo ""
    printf "  debug release release-symbols release-minified"
    echo ""
    usage_ios
}

function usage_ios() {
    echo "Supported targets for ios"
    echo ""
    printf "  os\n  sim\n  dist\n"
    echo ""
}

SUPPORTED_CONFIGS="debug|release|release-symbols|release-minified"
SUPPORTED_IOS_ARCHS="os|sim"

if [[ $1 =~ $SUPPORTED_CONFIGS ]]; then
    case "$1" in
        debug)
            CONFIG="Debug"
            ;;
        release)
            CONFIG="Release"
            ;;
        release-symbols)
            CONFIG="RelWithDebInfo"
            ;;
        release-minified)
            CONFIG="MinSizeRel"
            ;;
    esac
elif [[ $1 == "--help" ]]; then
    usage
    exit 0
else
    echo "Unsupported config '$1'"
    echo ""
    usage
    exit 1
fi

if [[ $2 =~ $SUPPORTED_IOS_ARCHS || $2 == "dist" ]]; then
    TARGET="$2"
else
    echo "Unsupported target '$2'"
    echo ""
    usage_ios
    exit 0
fi

# Create build directory (removing if it already exists)
BUILD_PLATFORM_DIR="$BUILD_ROOT_DIR/$CONFIG"
rm -rf "$BUILD_PLATFORM_DIR"
mkdir -p "$BUILD_PLATFORM_DIR"
cd "$BUILD_PLATFORM_DIR"

echo '----------------------------------------'
echo '            Starting build              '
echo '----------------------------------------'

echo "Building"

function ios_build() {
    echo "Running CMake"
    if [[ -z "$1" || -z "$2" ]]; then
        echo "ios_build requires a platform parameter and a dirname parameter"
        exit 1
    fi
    local current_dir=`pwd`
    mkdir -p "$2"
    cd "$2"
    cmake \
        "$PROJECT_DIR" \
        -DCMAKE_TOOLCHAIN_FILE="$IOS_TOOLCHAIN" \
        -DCMAKE_BUILD_TYPE="$CONFIG" \
        -DIOS_PLATFORM="$1" \
        -DIOS_DEPLOYMENT_TARGET="$IOS_DEPLOYMENT_TARGET" \
        || return 1

    echo "Building"
    make && cd "$current_dir"
}
case "$TARGET" in
    dist)
        ios_build "OS" "os" || { cd "$PROJECT_DIR" ; echo "lipo FAIL" ; exit 1; }
        ios_build "SIMULATOR" "sim" || { cd "$PROJECT_DIR" ; echo "lipo FAIL" ; exit 1; }
        mkdir -p "$TARGET"
        lipo -create -output "${TARGET}/libWPLibB.a" "os/libWPLibB.a" \
            "sim/libWPLibB.a" || { cd "$PROJECT_DIR" ; echo "lipo FAIL" ; exit 1; }
        DIST_DIR="$PROJECT_DIR/dist/ios"
        DIST_INC_DIR="$DIST_DIR/include/WPLibB"
        rm -rf "$DIST_DIR"
        # Also makes DIST_DIR
        mkdir -p "$DIST_INC_DIR"
        cp "${TARGET}/libWPLibB.a" "$DIST_DIR/"
        cp "$PROJECT_DIR/include/WPLibB/"*.h "$DIST_INC_DIR/"
        ;;
    os)
        ios_build "OS" "$TARGET"
        ;;
    sim)
        ios_build "SIMULATOR" "$TARGET"
        ;;
esac

# Go back to the original directory
cd "$PROJECT_DIR"
