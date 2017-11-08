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

# default values
OIO_SDS_BRANCHNAME=${OIO_SDS_BRANCHNAME:-3.3.1}

set -x
# copy source directory before remplacing values
rm -rf $DIRECTORY/source.work/
cp -r $DIRECTORY/source $DIRECTORY/source.work
grep -r OIO_SDS_BRANCHNAME $DIRECTORY/source.work || true
find $DIRECTORY/source.work -type f -name \*.rst -exec \
    sed -i \
        -e "s/{{OIO_SDS_BRANCHNAME}}/$OIO_SDS_BRANCHNAME/g" \
        \{\} \;

sphinx-build -E -W -d $DOCTREES -b html \
    $TAG_OPT $DIRECTORY/source.work $BUILD_DIR

rm -rf $DIRECTORY/source.work/
set +x

if [ "$TARGET" != "" ] ; then
    mkdir -p result-docs/$TARGET
    rsync -a $BUILD_DIR/ result-docs/$TARGET/
    rm -f result-docs/$TARGET/.buildinfo
fi
