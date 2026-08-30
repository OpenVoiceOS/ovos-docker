# syntax=docker/dockerfile:1.24
ARG TAG=0.1.0
ARG REGISTRY=docker.io/smartgic
ARG SOUND_BASE_IMAGE=${REGISTRY}/ovos-sound-base:${TAG}
FROM ${SOUND_BASE_IMAGE}
ARG TAG
ARG REGISTRY
ARG GIT_SHA=unknown
ARG OVOS_RELEASES_REF=main


ARG BUILD_DATE=unknown
ARG VERSION=unknown
ARG SOUND_BASE_IMAGE
ARG UV_PRERELEASE=allow

LABEL org.opencontainers.image.title="Open Voice OS OCI ggwave plugin image"
LABEL org.opencontainers.image.description="Tiny data-over-sound library to install skills, configure wireless, etc..."
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.authors="Open Voice OS Community"
LABEL org.opencontainers.image.base.name="${REGISTRY}/ovos-sound-base:${TAG}"
LABEL org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.ref.name="${REGISTRY}/ovos-plugin-ggwave:${TAG}"
LABEL org.opencontainers.image.revision="${GIT_SHA}"
LABEL io.openvoiceos.constraints.ref="${OVOS_RELEASES_REF}"

ARG USER=ovos

USER root

SHELL ["/bin/bash", "-c"]

ADD --chmod=0644 https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/${OVOS_RELEASES_REF}/constraints-${OVOS_CHANNEL}.txt /tmp/constraints.txt

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/root/.cache/uv,sharing=locked \
    apt-get update \
 && apt-get install -o Dpkg::Options::="--force-confold" -y --no-install-recommends --no-install-suggests portaudio19-dev build-essential python3-dev \
 && uv pip install -f 'https://whl.smartgic.io/' ggwave \
 && uv pip install --prerelease=${UV_PRERELEASE} ovos-audio-transformer-plugin-ggwave padacioso -c /tmp/constraints.txt \
 && apt-get --purge remove -y portaudio19-dev build-essential python3-dev \
 && apt-get --purge autoremove -y \
 && rm -rf /var/log/{apt,dpkg.log} /tmp/* /var/tmp/*

USER "$USER"

ENTRYPOINT ["ovos-ggwave-listener"]

WORKDIR "/home/${USER}"
