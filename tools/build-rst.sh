#!/bin/bash -e

DIRECTORY=$1

if [ -z "$DIRECTORY" ] ; then
    echo "usage $O DIRECTORY options"
    echo "Options:"
    echo "--tag TAG: use tag for building"
    echo "--target TARGET: copy results to result-docs/$TARGET"
    echo "--build BUILD: Name of build directory"
    exit 1
fi

TARGET=""
TAG=""
TAG_OPT=""
BUILD=""

while [[ $# > 0 ]] ; do
    option="$1"
    case $option in
        --build)
            BUILD="$2"
            shift
            ;;
        --tag)
            TAG="$2"
            TAG_OPT="-t $2"
            shift
            ;;
        --target)
            TARGET="$2"
            shift
            ;;
    esac
    shift
done

if [ -z "$BUILD" ] ; then
    if [ -z "$TAG" ] ; then
        BUILD_DIR="$DIRECTORY/build/html"
    else
        BUILD_DIR="$DIRECTORY/build-${TAG}/html"
    fi
else
    BUILD_DIR="$DIRECTORY/$BUILD/html"
fi

DOCTREES="${BUILD_DIR}.doctrees"

set -x
sphinx-build -E -W -d $DOCTREES -b html \
    $TAG_OPT $DIRECTORY/source $BUILD_DIR
set +x

if [ "$TARGET" != "" ] ; then
    mkdir -p result-docs/$TARGET
    rsync -a $BUILD_DIR/ result-docs/$TARGET/
    rm -f result-docs/$TARGET/.buildinfo
fi
