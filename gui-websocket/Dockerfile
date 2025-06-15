ARG TAG=0.1.0
ARG REGISTRY=docker.io/smartgic
FROM "${REGISTRY}/ovos-base:${TAG}"

HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=60s \
    CMD curl --header "Connection: Upgrade" --header "Upgrade: Websocket" http://127.0.0.1:18181/core || kill 1

ARG BUILD_DATE=unknown
ARG VERSION=unknown
ARG TAG
ARG REGISTRY

LABEL org.opencontainers.image.title="Open Voice OS OCI GUI websocket image"
LABEL org.opencontainers.image.description="Websocket process to handle messages for the OpenVoiceOS GUI"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.authors="Open Voice OS Community"
LABEL org.opencontainers.image.base.name="${REGISTRY}/ovos-base:${TAG}"

ARG USER=ovos

COPY files/requirements.txt /tmp/requirements.txt

USER root

SHELL ["/bin/bash", "-c"]

RUN pip3 install -r /tmp/requirements.txt -c https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/refs/heads/main/constraints-${OVOS_CHANNEL}.txt \
  && mkdir -p "/home/${USER}/.cache/ovos_gui_file_server" /etc/xdg \
  && chown "${USER}:${USER}" -R "/home/${USER}" \
  && rm -rf /tmp/* /var/tmp/*

USER "$USER"

ENTRYPOINT ["ovos-gui-service"]

WORKDIR "/home/${USER}"
