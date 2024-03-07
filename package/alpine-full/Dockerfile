# syntax = docker/dockerfile:experimental

ARG http_proxy
ARG https_proxy

ARG AZURE_CLI_VERSION=2.58.0

FROM docker.repo1.uhc.com/azure-cli:${AZURE_CLI_VERSION} AS azurecli

# Remove jp installed on the azure-cli base image since it has critical vulnerabilities
RUN rm -rf /usr/local/bin/jp || true

FROM runiac/deploy:latest-alpine-aws

ARG GCLOUD_CLI_VERSION=467.0.0
ARG TARGETPLATFORM

# install azure cli
COPY --from=azurecli /usr/local/bin/ /usr/local/bin/
COPY --from=azurecli /usr/local/lib/ /usr/local/lib/

RUN apk update && \
    apk add --no-cache tar openssl sudo bash && \
    apk add --virtual=build libffi-dev

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