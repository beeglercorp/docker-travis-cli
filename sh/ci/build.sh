#!/bin/bash


# recommended by travis-ci
# @see https://docs.travis-ci.com/user/customizing-the-build/#Implementing-Complex-Build-Steps
set -ev

# @see https://stackoverflow.com/a/246128
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_UTIL_PATH=$DIR/../../docker-util



docker build --build-arg ALPINE_VERSION=$ALPINE_VERSION --tag $DOCKER_IMAGE_NAME --compress --force-rm --squash .
$DOCKER_UTIL_PATH/sh/test-image-size.sh -i $DOCKER_IMAGE_NAME -t $IMAGE_SIZE_THRESHOLD

if [ $ALPINE_VERSION -eq "latest" ]; then
  EXPECTED_ALPINE_VERSION=3.6
else
  EXPECTED_ALPINE_VERSION=$ALPINE_VERSION
fi

# validate Alpine version
docker run --rm $DOCKER_IMAGE_NAME \
  /bin/sh -c \
  VERSION=`cat /etc/alpine-release` \                 # the full version <major>.<minor>.<patch>
  && echo `expr "$VERSION" : '\([0-9]*\.[0-9]*\)'` \  # remove .<patch>, so we're left with <major>.<minor>
  | diff - <(echo "$EXPECTED_ALPINE_VERSION")
