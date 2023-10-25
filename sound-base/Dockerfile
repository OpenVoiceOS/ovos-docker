ARG TAG=alpha
FROM smartgic/ovos-base:${TAG}

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI sound base image"
LABEL org.opencontainers.image.description="Sound base layer for audio related images"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG USER=ovos

COPY files/client.conf /etc/pulse/client.conf

USER root

SHELL ["/bin/bash", "-c"]

RUN apt-get update \
    && apt-get install -o Dpkg::Options::="--force-confold" -y --no-install-recommends gpg alsa-utils libasound2-plugins flac libportaudio2 pulseaudio-utils pipewire pipewire-alsa mpg123 music123 sox swig libsox-fmt-all \
    && apt-get --purge autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt /var/log/{apt,dpkg.log} \
    && mkdir -p /home/${USER}/.config/pulse \
    && chown ${USER}:${USER} -R /home/${USER} \
    && usermod -a -G audio $USER

USER $USER

ENV IS_OVOS_CONTAINER "true"
