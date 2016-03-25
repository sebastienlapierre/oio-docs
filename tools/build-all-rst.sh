#!/bin/bash -e

mkdir -p result-docs

for guide in admin-guide cli-reference project-guide; do
    tools/build-rst.sh doc/$guide --build build \
        --target "draft/$guide"
done

tools/build-install-guides-rst.sh
