# syntax=docker/dockerfile:1.27@sha256:bde3983e9c939224420ddaf6b784cc30e09b035a4dea01f581230c50809f372e
ARG TAG=0.1.0
ARG REGISTRY=docker.io/smartgic
ARG SOUND_BASE_IMAGE=${REGISTRY}/ovos-sound-base:${TAG}
FROM ${SOUND_BASE_IMAGE}
ARG TAG
ARG REGISTRY
ARG GIT_SHA=unknown
ARG OVOS_RELEASES_REF=main
ENV OVOS_RELEASES_REF=${OVOS_RELEASES_REF}


HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=60s \
    CMD ovos-hc -s PHAL || exit 1

ARG BUILD_DATE=unknown
ARG VERSION=unknown
ARG SOUND_BASE_IMAGE

LABEL org.opencontainers.image.title="Open Voice OS OCI PHAL image"
LABEL org.opencontainers.image.description="PHAL is our Platform/Hardware Abstraction Layer, it completely replaces the concept of hardcoded enclosure from mycroft-core"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.authors="Open Voice OS Community"
LABEL org.opencontainers.image.base.name="${REGISTRY}/ovos-sound-base:${TAG}"
LABEL org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.ref.name="${REGISTRY}/ovos-phal:${TAG}"
LABEL org.opencontainers.image.revision="${GIT_SHA}"
LABEL io.openvoiceos.constraints.ref="${OVOS_RELEASES_REF}"

ARG USER=ovos

COPY files/requirements.txt /tmp/requirements.txt
COPY --chmod=0755 files/entrypoint.sh /usr/local/bin/entrypoint.sh

USER root

SHELL ["/bin/bash", "-c"]

ADD --chmod=0644 https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/${OVOS_RELEASES_REF}/constraints-${OVOS_CHANNEL}.txt /tmp/constraints.txt

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/root/.cache/uv,sharing=locked \
    apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests libasound2-dev procps ddcutil build-essential python3-dev network-manager \
 && uv pip install -r /tmp/requirements.txt -c /tmp/constraints.txt \
 && chown "${USER}:${USER}" -R "/home/${USER}" \
 && apt-get --purge remove -y libasound2-dev build-essential python3-dev \
 && apt-get --purge autoremove -y \
 && rm -rf /var/log/{apt,dpkg.log} /tmp/* /var/tmp/*

USER "$USER"

ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]

WORKDIR "/home/${USER}"
