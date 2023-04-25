FROM alpine:edge

LABEL org.opencontainers.image.title="Open Voice OS OCI skill base image (Alpine based)"
LABEL org.opencontainers.image.description="Used as base layer for other OCI skill images"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-04-20T00:00:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG USER=ovos

COPY files/requirements.txt /tmp/requirements.txt

RUN adduser --disabled-password $USER \
    && mkdir -p /home/${USER}/.config/mycroft /home/${USER}/.cache/mycroft /home/${USER}/.local/share/mycroft /tmp/mycroft/ipc /tmp/mycroft/cache \
    && chown ${USER}:${USER} -R /home/${USER} /tmp/mycroft \
    && apk add --no-cache git python3 py3-pip py3-wheel \
    && pip3 install -r /tmp/requirements.txt \
    && rm -rf ${HOME}/.cache /tmp/requirements.txt

USER $USER
