ARG TAG=alpha
FROM smartgic/ovos-base:${TAG}

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI GUI websocket image"
LABEL org.opencontainers.image.description="Websocket process to handle messages for the OpenVoiceOS GUI"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false
ARG USER=ovos

RUN if [ "${ALPHA}" == "true" ]; then \
    pip install ovos-plugin-manager[offline] ovos-gui ovos-gui-plugin-shell-companion --pre; \
    else \
    pip install ovos-plugin-manager[offline] ovos-gui ovos-gui-plugin-shell-companion; \
    fi \
    && mkdir ${HOME}/.cache/ovos_gui_file_server \
    && rm -rf ${HOME}/.cache/pip

ENTRYPOINT ovos-gui-service

WORKDIR /home/${USER}
