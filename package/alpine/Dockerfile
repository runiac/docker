# syntax = docker/dockerfile:experimental

FROM --platform=$TARGETPLATFORM golang:1.16-alpine as builder1

ARG RUNIAC_REF="refs/heads/main"
ARG TARGETPLATFORM

# Common tools
RUN apk add curl \
    && apk add ca-certificates \
    && rm -rf /var/cache/apk/*

# Grab from github release
RUN curl -Lo core.zip "https://github.com/Optum/runiac/archive/${RUNIAC_REF}.zip" && \
    unzip core.zip && \
    rm -f core.zip && \
    cd runiac-main/cmd/runiac/ && \
    go install

# default to the build platforms image, and not the target platform image
# since this is a temp image stage, we should avoid qemu for the binary download
# and only pull the alpine image once
FROM alpine

ARG TERRAFORM_VERSION=0.15.1

RUN apk update

# Common tools, git+openssh for terraform
RUN apk add bash \
    && apk add jq \
    && apk add curl \
    && apk add wget \
    && apk add git \
    && apk add openssh \
    && apk add ca-certificates \
    && rm -rf /var/cache/apk/*

# Use BuildKit to help translate architecture names
ARG TARGETPLATFORM
# translating Docker's TARGETPLATFORM into tini download names
RUN case ${TARGETPLATFORM} in \
         "linux/amd64")  export RUNIAC_ARCH=amd64  ;; \
         "linux/arm64")  export RUNIAC_ARCH=arm64  ;; \
         "linux/arm/v7") export RUNIAC_ARCH=armhf  ;; \
         "linux/arm/v6") export RUNIAC_ARCH=armel  ;; \
         "linux/386")    export RUNIAC_ARCH=i386   ;; \
    esac \
    && wget -O tf.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${RUNIAC_ARCH}.zip" && \
    unzip tf.zip && \
    rm -f tf.zip && \
    mv terraform /usr/local/bin

COPY --from=builder1 /go/bin/runiac /usr/local/bin/runiac 

RUN mkdir -p $HOME/.terraform.d/plugins/linux_amd64
RUN mkdir -p $HOME/.terraform.d/plugin-cache

ENTRYPOINT [ "runiac" ]