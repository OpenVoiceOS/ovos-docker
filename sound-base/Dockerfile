ARG TAG=0.1.0
ARG REGISTRY=docker.io/smartgic
FROM "${REGISTRY}/ovos-base:${TAG}"

ARG BUILD_DATE=unknown
ARG VERSION=unknown
ARG TAG
ARG REGISTRY

LABEL org.opencontainers.image.title="Open Voice OS OCI sound base image"
LABEL org.opencontainers.image.description="Sound base layer for audio related images"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.authors="Open Voice OS Community"
LABEL org.opencontainers.image.base.name="${REGISTRY}/ovos-base:${TAG}"

ARG USER=ovos

COPY files/client.conf /etc/pulse/client.conf

USER root

SHELL ["/bin/bash", "-c"]

RUN apt-get update \
    && apt-get install -o Dpkg::Options::="--force-confold" -y --no-install-recommends  --no-install-suggests \
    gpg alsa-utils libasound2-plugins flac libportaudio2 \
    pulseaudio-utils pipewire pipewire-alsa mpg123 music123 \
    sox swig libsox-fmt-all procps libasound2-dev \
    build-essential python3-dev \
    && pip3 install pyalsaaudio \
    && apt-get --purge remove -y libasound2-dev build-essential python3-dev \
    && apt-get --purge autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* \
    /var/log/{apt,dpkg.log} /tmp/* /var/tmp/* \
    && mkdir -p "/home/${USER}/.config/mycroft/apps" "/home/${USER}/.config/pulse" \
    && chown "${USER}:${USER}" -R "/home/${USER}" \
    && usermod -a -G audio "$USER"

USER "$USER"
