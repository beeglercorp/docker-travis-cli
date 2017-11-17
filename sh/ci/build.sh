#!/bin/bash


# recommended by travis-ci
# @see https://docs.travis-ci.com/user/customizing-the-build/#Implementing-Complex-Build-Steps
set -ev

# @see https://stackoverflow.com/a/246128
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_UTIL_PATH=$DIR/../../docker-util


docker build --tag $DOCKER_IMAGE_NAME --compress --force-rm --squash .
$DOCKER_UTIL_PATH/sh/test-image-size.sh -i $DOCKER_IMAGE_NAME -t $IMAGE_SIZE_THRESHOLD
