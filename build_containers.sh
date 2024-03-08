#!/bin/bash
push_containers () {
    local image_prefix="runiac/deploy:$1-"

    echo $image_prefix $TYPE

    if [[ "$TYPE" == "core" ]]; then 
      docker buildx build --build-arg RUNIAC_REF=$REF --platform linux/arm64,linux/amd64 -f "package/alpine/Dockerfile" -t "${image_prefix}alpine" $2  . || exit 1
    fi
    elif [[ "$TYPE" == "aws" ]]; then 
      docker buildx build --platform linux/arm64,linux/amd64 -f "package/alpine-aws/Dockerfile" -t "${image_prefix}alpine-aws" $2  .
    fi
    elif [[ "$TYPE" == "azure" ]]; then 
      docker buildx build --platform linux/arm64,linux/amd64 -f "package/alpine-azure/Dockerfile" -t "${image_prefix}alpine-azure" $2 .
    fi
    elif [[ "$TYPE" == "gcp" ]]; then 
      docker buildx build --platform linux/arm64,linux/amd64 -f "package/alpine-gcp/Dockerfile" -t "${image_prefix}alpine-gcp" $2 .
    fi
    elif [[ "$TYPE" == "full" ]]; then 
      docker buildx build --platform linux/arm64,linux/amd64 -f "package/alpine-full/Dockerfile" -t "${image_prefix}alpine-full" $2 .
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

if [[ "$GITHUB_EVENT" == "workflow_dispatch" ]]; then
  PUSH="--push"
else
  PUSH=""
fi

push_containers $VERSION $PUSH

if [[ $latest == "true" ]]
then
  push_containers "latest" $PUSH
fi
