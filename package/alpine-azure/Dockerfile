# syntax = docker/dockerfile:experimental

ARG http_proxy
ARG https_proxy

FROM runiac/core:latest-alpine

ARG AZURE_CLI_VERSION=2.13.0

# install azure cli
RUN \
    apk update && \
    apk add --no-cache curl tar openssl sudo bash jq python3 py-pip && \
    apk add --virtual=build gcc libffi-dev musl-dev openssl-dev make python3-dev && \
    python3 -m pip --no-cache-dir install azure-cli==${AZURE_CLI_VERSION} && \
    apk del --purge build
