FROM alpine:edge

LABEL org.opencontainers.image.title="Open Voice OS OCI skill base image (Alpine based)"
LABEL org.opencontainers.image.description="Used as base layer for other OCI skill images"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-04-20T00:00:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG USER=ovos

RUN adduser --disabled-password $USER \
    && mkdir -p /home/${USER}/.config/mycroft /home/${USER}/.cache/mycroft /home/${USER}/.local/share/mycroft /tmp/mycroft/ipc /tmp/mycroft/cache \
    && chown ${USER}:${USER} -R /home/${USER} /tmp/mycroft \
    && apk add --no-cache git python3 py3-pip py3-wheel \
    && pip3 install adapt-parser git+https://github.com/OpenVoiceOS/OVOS-workshop.git git+https://github.com/OpenVoiceOS/ovos-core.git ovos-plugin-common-play mycroft-messagebus-client \
    && rm -rf ${HOME}/.cache

USER $USER