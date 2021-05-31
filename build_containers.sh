#!/bin/bash

# if version not set, set to local default
if [[ "$REF" == "refs/heads/main" ]]; then
  VERSION="latest"
elif  [[ "$REF" =~ refs/tags/* ]]; then  
  VERSION=$(echo ${REF#refs/tags/})
else
  VERSION=$(whoami)
  REF='refs/heads/main'
fi

image_prefix="runiac/deploy:$VERSION-"

echo $image_prefix

docker buildx build --build-arg RUNIAC_REF=$REF --platform linux/arm64,linux/amd64 -f "package/alpine/Dockerfile" -t "${image_prefix}alpine" --push . || exit 1
docker buildx build --platform linux/arm64,linux/amd64 -f "package/alpine-aws/Dockerfile" -t "${image_prefix}alpine-aws" --push . || exit 1
docker buildx build --platform linux/arm64,linux/amd64 -f "package/alpine-azure/Dockerfile" -t "${image_prefix}alpine-azure" --push . &
docker buildx build --platform linux/arm64,linux/amd64 -f "package/alpine-full/Dockerfile" -t "${image_prefix}alpine-full" --push . &
docker buildx build --platform linux/arm64,linux/amd64 -f "package/alpine-gcp/Dockerfile" -t "${image_prefix}alpine-gcp" --push . &

wait
