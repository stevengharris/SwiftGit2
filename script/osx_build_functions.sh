#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
source "${SCRIPT_DIR}/xcode_functions.sh"

function setup_build_environment ()
{
    # augment path to help it find cmake installed in /usr/local/bin,
    # e.g. via brew. Xcode's Run Script phase doesn't seem to honor
    # ~/.MacOSX/environment.plist
    PATH="/usr/local/bin:/opt/boxen/homebrew/bin:$PATH"
    
    pushd "$SCRIPT_DIR/.." > /dev/null
    ROOT_PATH="$PWD"
    popd > /dev/null

    CLANG="/usr/bin/xcrun clang"
    CC="${CLANG}"
    CPP="${CLANG} -E"

    MACOSX_DEPLOYMENT_TARGET="10.15"

    XCODE_MAJOR_VERSION=$(xcode_major_version)

    ARCHS="x86_64"
    
}

function build_all_archs ()
{
    setup_build_environment
    
    local setup=$1
    local build_arch=$2
    local finish_build=$3

    # run the prepare function
    eval $setup

    echo "Building for ${ARCHS}"

    for ARCH in ${ARCHS}
    do
        PLATFORM="macos"
        SDKVERSION=$(osx_sdk_version)

        if [ "${ARCH}" == "arm64" ]
        then
            HOST="aarch64-apple-darwin"
        else
            HOST="${ARCH}-apple-darwin"
        fi

        SDKNAME="${PLATFORM}${SDKVERSION}"
        SDKROOT="$(osx_sdk_path ${SDKNAME})"
        echo "SDKROOT=${SDKROOT}"
    
        echo "Building ${LIBRARY_NAME} for ${SDKNAME} ${ARCH}"
        echo "Please stand by..."

        # run the per arch build command
        eval $build_arch
    done

    # finish the build (usually lipo)
    eval $finish_build
}

