# syntax=docker/dockerfile:1.21
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

LABEL org.opencontainers.image.title="Open Voice OS OCI parrot skill image"
LABEL org.opencontainers.image.description="Repeat back what the user says for testing speech recognition"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.authors="Open Voice OS Community"
LABEL org.opencontainers.image.base.name="${REGISTRY}/ovos-skill-base:${TAG}"
LABEL org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.ref.name="${REGISTRY}/ovos-skill-parrot:${TAG}"
LABEL org.opencontainers.image.revision="${GIT_SHA}"

RUN --mount=type=cache,target=/home/ovos/.cache/uv,uid=1000,gid=1000,sharing=locked \
    uv pip install ovos-skill-parrot -c https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/refs/heads/main/constraints-${OVOS_CHANNEL}.txt

CMD ["ovos-skill-launcher", "skill-ovos-parrot.openvoiceos"]
