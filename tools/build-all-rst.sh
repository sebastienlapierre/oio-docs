#!/bin/bash -e

mkdir -p result-docs

for guide in user-guide cli-reference project-guide vagrant-box docker-image install-swift-s3 sandbox-guide sdk-guide; do
    tools/build-rst.sh doc/$guide --build build \
        --target "$guide"
done

tools/build-install-guides-rst.sh
