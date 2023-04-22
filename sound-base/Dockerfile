ARG TAG=dev
FROM smartgic/ovos-base:${TAG}

LABEL org.opencontainers.image.title="Open Voice OS OCI sound base image"
LABEL org.opencontainers.image.description="Sound base layer for audio related images"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-04-20T00:00:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG BRANCH
ARG USER=ovos

COPY files/asoundrc /home/${USER}/.asoundrc
COPY files/client.conf /etc/pulse/client.conf

USER root

SHELL ["/bin/bash", "-c"]

RUN apt-get update \
    && apt-get install -o Dpkg::Options::="--force-confold" -y curl gpg alsa-utils libasound2-plugins flac libportaudio2 pulseaudio-utils mpg123 music123 swig \
    && apt-get --purge autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt /var/log/{apt,dpkg.log} \
    && mkdir -p /home/${USER}/.config/pulse \
    && chown ${USER}:${USER} -R /home/${USER} \
    && usermod -a -G audio $USER

USER $USER
