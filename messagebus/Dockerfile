# syntax=docker/dockerfile:1.7
ARG TAG=0.1.0
ARG REGISTRY=docker.io/smartgic
ARG BASE_IMAGE=${REGISTRY}/ovos-base:${TAG}
FROM ${BASE_IMAGE}
ARG TAG
ARG REGISTRY
ARG GIT_SHA=unknown


HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=60s \
    CMD curl --header "Connection: Upgrade" --header "Upgrade: Websocket" http://127.0.0.1:8181/core || kill 1

ARG BUILD_DATE=unknown
ARG VERSION=unknown
ARG BASE_IMAGE

LABEL org.opencontainers.image.title="Open Voice OS OCI message bus image"
LABEL org.opencontainers.image.description="Message bus service, the nervous system of OpenVoiceOS (Python implementation)"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.authors="Open Voice OS Community"
LABEL org.opencontainers.image.base.name="${REGISTRY}/ovos-base:${TAG}"
LABEL org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.ref.name="${REGISTRY}/ovos-messagebus:${TAG}"
LABEL org.opencontainers.image.revision="${GIT_SHA}"

ARG USER=ovos
ARG USER_UID=1000
ARG USER_GID=1000

SHELL ["/bin/bash", "-c"]

RUN --mount=type=cache,target=/home/${USER}/.cache/uv,uid=${USER_UID},gid=${USER_GID} \
    uv pip install ovos-messagebus -c https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/refs/heads/main/constraints-${OVOS_CHANNEL}.txt

ENTRYPOINT ["ovos-messagebus"]

WORKDIR "/home/${USER}"
