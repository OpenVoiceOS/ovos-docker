# syntax=docker/dockerfile:1.7
ARG TAG=0.1.0
ARG REGISTRY=docker.io/smartgic
ARG SKILL_BASE_IMAGE=${REGISTRY}/ovos-skill-base:${TAG}
FROM ${SKILL_BASE_IMAGE}
ARG TAG
ARG REGISTRY
ARG GIT_SHA=unknown


ARG BUILD_DATE=unknown
ARG VERSION=unknown
ARG SKILL_BASE_IMAGE
ARG USER=ovos

LABEL org.opencontainers.image.title="Open Voice OS OCI Wolfie skill image"
LABEL org.opencontainers.image.description="Wolfram Alpha integration for mathematical calculations and factual queries"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.authors="Open Voice OS Community"
LABEL org.opencontainers.image.base.name="${REGISTRY}/ovos-skill-base:${TAG}"
LABEL org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.ref.name="${REGISTRY}/ovos-skill-wolfie:${TAG}"
LABEL org.opencontainers.image.revision="${GIT_SHA}"

USER root

RUN --mount=type=cache,target=/var/cache/apk \
    apk update \
 && apk add --virtual .build-deps gcc g++

USER "$USER"

RUN --mount=type=cache,target=/home/ovos/.cache/uv,uid=1000,gid=1000 \
    uv pip install ovos-skill-wolfie -c https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/refs/heads/main/constraints-${OVOS_CHANNEL}.txt

USER root

RUN --mount=type=cache,target=/var/cache/apk \
    apk del .build-deps

USER "$USER"

CMD ["ovos-skill-launcher", "ovos-skill-wolfie.openvoiceos"]
