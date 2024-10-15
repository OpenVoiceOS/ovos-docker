ARG TAG=0.1.0
FROM "smartgic/ovos-base:${TAG}"

HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=60s \
    CMD curl --header "Connection: Upgrade" --header "Upgrade: Websocket" http://127.0.0.1:18181/core || kill 1

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI GUI websocket image"
LABEL org.opencontainers.image.description="Websocket process to handle messages for the OpenVoiceOS GUI"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false
ARG USER=ovos

USER root

COPY files/requirements.txt /tmp/requirements.txt

RUN if [ "${ALPHA}" == "true" ]; then \
    pip3 install --no-cache-dir -r /tmp/requirements.txt --pre; \
    else \
    pip3 install --no-cache-dir -r /tmp/requirements.txt; \
    fi \
    && mkdir "${HOME}/.cache/ovos_gui_file_server" /etc/xdg \
    && chown "${USER}:${USER}" -R "/home/${USER}" \
    && rm -rf "${HOME}/.cache/pip" /tmp/requirements.txt

USER "$USER"

ENTRYPOINT ovos-gui-service

WORKDIR "/home/${USER}"
