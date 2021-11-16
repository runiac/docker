# syntax = docker/dockerfile:experimental

ARG http_proxy
ARG https_proxy

FROM runiac/deploy:latest-alpine-aws

ARG AZURE_CLI_VERSION=2.30.0
ARG GCLOUD_CLI_VERSION=339.0.0
ARG TARGETPLATFORM

# install azure cli
RUN \
    apk update && \
    apk add --no-cache curl tar openssl sudo bash jq python3 py-pip && \
    apk add --virtual=build gcc libffi-dev musl-dev openssl-dev make python3-dev && \
    python3 -m pip --no-cache-dir install azure-cli==${AZURE_CLI_VERSION} && \
    apk del --purge build

# install google cloud sdk
RUN case ${TARGETPLATFORM} in \
         "linux/amd64")  GCLOUD_ARCH=linux-x86_64  ;; \
         "linux/arm64")  GCLOUD_ARCH=darwin-arm  ;; \
         "linux/arm/v7") GCLOUD_ARCH=armhf  ;; \
         "linux/arm/v6") GCLOUD_ARCH=armel  ;; \
         "linux/386")    GCLOUD_ARCH=i386   ;; \
    esac && \
    cd /opt && \
    curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_CLI_VERSION}-${GCLOUD_ARCH}.tar.gz > gcloud.tar.gz && \
    tar xfz gcloud.tar.gz && \
    ./google-cloud-sdk/install.sh

ENV PATH="/opt/google-cloud-sdk/bin:${PATH}"

