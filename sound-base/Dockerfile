ARG TAG=0.1.0
FROM "smartgic/ovos-base:${TAG}"

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI sound base image"
LABEL org.opencontainers.image.description="Sound base layer for audio related images"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG USER=ovos

COPY files/client.conf /etc/pulse/client.conf

USER root

RUN apk update \
    && apk add --no-cache shadow alsa-utils alsa-lib flac libportaudiocxx pulseaudio-utils pipewire pipewire-alsa mpg123 sox swig procps-ng \
    && bash -c "mkdir -p /home/"${USER}"/.config/{mycroft/apps,pulse}" \
    && chown "${USER}:${USER}" -R "/home/${USER}" \
    && usermod -a -G audio "$USER" \
    && apk del shadow

USER "$USER"

ENV IS_OVOS_CONTAINER "true"
