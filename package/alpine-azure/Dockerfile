# syntax = docker/dockerfile:experimental

ARG http_proxy
ARG https_proxy

ARG AZURE_CLI_VERSION=2.58.0

FROM docker.repo1.uhc.com/azure-cli:${AZURE_CLI_VERSION} AS azurecli

# Remove jp installed on the azure-cli base image since it has critical vulnerabilities
RUN rm -rf /usr/local/bin/jp || true

FROM runiac/deploy:latest-alpine
COPY --from=azurecli /usr/local/bin/ /usr/local/bin/
COPY --from=azurecli /usr/local/lib/ /usr/local/lib/

RUN apk update && \
    apk add --no-cache tar openssl sudo bash && \
    apk add --virtual=build libffi-dev