#!/bin/bash

# if version not set, set to local default
if [ -z "$VERSION"  ]
then
  VERSION=$(whoami)
fi

image_prefix="runiac/core:$VERSION-$cleanDir"

docker buildx build --platform linux/arm64,linux/amd64 -f "package/alpine/Dockerfile" -t "${image_prefix}alpine" --push . || exit 1
docker buildx build --platform linux/arm64,linux/amd64 -f "package/alpine-azure/Dockerfile" -t "${image_prefix}alpine-azure" --push . || exit 1
docker buildx build --platform linux/arm64,linux/amd64 -f "package/alpine-full/Dockerfile" -t "${image_prefix}alpine-full" --push . || exit 1 &
docker buildx build --platform linux/arm64,linux/amd64 -f "package/alpine-gcp/Dockerfile" -t "${image_prefix}alpine-gcp" --push . || exit 1 &

wait