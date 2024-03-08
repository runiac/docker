#!/bin/bash
push_containers () {
    local image_prefix="runiac/deploy:$1-"

    echo $image_prefix $TYPE

    if [[ "$TYPE" == "core" ]]; then 
      docker buildx build --build-arg RUNIAC_REF=$REF --platform linux/arm64,linux/amd64 -f "package/alpine/Dockerfile" -t "${image_prefix}alpine" --push  . || exit 1
    elif [[ "$TYPE" == "aws" ]]; then 
      docker buildx build --build-arg RUNIAC_TAG=$1 --platform linux/arm64,linux/amd64 -f "package/alpine-aws/Dockerfile" -t "${image_prefix}alpine-aws" --push  . || exit 1
    elif [[ "$TYPE" == "azure" ]]; then 
      docker buildx build --build-arg RUNIAC_TAG=$1 --platform linux/arm64,linux/amd64 -f "package/alpine-azure/Dockerfile" -t "${image_prefix}alpine-azure" --push . || exit 1
    elif [[ "$TYPE" == "gcp" ]]; then 
      docker buildx build --build-arg RUNIAC_TAG=$1 --platform linux/arm64,linux/amd64 -f "package/alpine-gcp/Dockerfile" -t "${image_prefix}alpine-gcp" --push . || exit 1
    elif [[ "$TYPE" == "full" ]]; then 
      docker buildx build --build-arg RUNIAC_TAG=$1 --platform linux/arm64,linux/amd64 -f "package/alpine-full/Dockerfile" -t "${image_prefix}alpine-full" --push . || exit 1
    fi
}

# if version not set, set to local default
if [[ "$REF" == "refs/heads/main" ]]; then
  VERSION="main"
elif  [[ "$REF" =~ refs/tags/* ]]; then  
  VERSION=$(echo ${REF#refs/tags/})
  latest="true"
else
  VERSION=$(whoami)
  REF='refs/heads/main'
fi

if [[ "$GITHUB_EVENT" == "pull_request" ]]; then
  VERSION="prerelease"
fi

push_containers $VERSION

if [[ $latest == "true" ]]
then
  push_containers "latest"
fi