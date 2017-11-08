#!/bin/bash

# recommended by travis-ci
# @see https://docs.travis-ci.com/user/customizing-the-build/#Implementing-Complex-Build-Steps
set -ev

while getopts ":i:t:" opt; do
  case ${opt} in
    i )
      image=$OPTARG
      ;;
    t )
      threshold=$OPTARG
      ;;
    \? ) echo "Usage: cmd [-i] [-t]"
      ;;
  esac
done

DOCKER_SIZE_STRING="$(docker images $image --format {{.Size}})"
DOCKER_SIZE_NUMBER=${DOCKER_SIZE_STRING%MB}

echo $DOCKER_SIZE_STRING

if [ ${#DOCKER_SIZE_STRING} -eq ${#DOCKER_SIZE_NUMBER} ]; then
  # the size is not in MB, we're going to assume it's in something greater than MB
  echo "Size >999MB."
  exit 1
fi

DOCKER_SIZE_ROUNDED="$(echo $DOCKER_SIZE_NUMBER | awk '{print int($1+0.9)}')"

if [ $threshold -ge $DOCKER_SIZE_ROUNDED ]; then
  echo "Ok"
else
  echo "Expected maximum of ${threshold}MB, but measured image size ${DOCKER_SIZE_STRING}."
  exit 1
fi
