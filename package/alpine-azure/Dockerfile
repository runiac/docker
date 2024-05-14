# syntax = docker/dockerfile:experimental

ARG http_proxy
ARG https_proxy
ARG RUNIAC_TAG

ARG AZURE_CLI_VERSION=2.60.0
ARG KUBECTL_VERSION=0.30.0
ARG KUBELOGIN_VERSION=0.1.3

FROM mcr.microsoft.com/azure-cli:${AZURE_CLI_VERSION} AS azurecli

# Remove jp installed on the azure-cli base image since it has critical vulnerabilities
RUN rm -rf /usr/local/bin/jp || true

FROM runiac/deploy:${RUNIAC_TAG}-alpine
COPY --from=azurecli /usr/local/bin/ /usr/local/bin/
COPY --from=azurecli /usr/local/lib/ /usr/local/lib/

RUN apk update && \
    apk add --no-cache openssl sudo bash jq && \
    apk add --virtual=build libffi-dev

RUN az aks install-cli --client-version ${KUBECTL_VERSION} --kubelogin-version ${KUBELOGIN_VERSION}
