#!/bin/bash


# recommended by travis-ci
# @see https://docs.travis-ci.com/user/customizing-the-build/#Implementing-Complex-Build-Steps
set -ev

IMAGE_WITH_TAG=$DOCKER_PUBLIC_IMAGE_NAME:$TAG

docker pull $IMAGE_WITH_TAG
docker run --rm $IMAGE_WITH_TAG --version
docker run --mount type=bind,source=$(pwd)/.travis.yml,target=/.travis.yml --rm $IMAGE_WITH_TAG lint /.travis.yml
