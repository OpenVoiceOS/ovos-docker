ARG TAG=dev
FROM smartgic/ovos-base:${TAG}

LABEL org.opencontainers.image.title="Open Voice OS OCI GUI websocket image"
LABEL org.opencontainers.image.description="Websocket process to handle messages for the OpenVoiceOS GUI"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-04-20T00:00:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false
ARG USER=ovos

RUN if [ "${ALPHA}" == "true" ]; then \
    pip install ovos-plugin-manager[offline] ovos-gui.git --pre; \
    else \
    pip install ovos-plugin-manager[offline] ovos-gui; \
    fi \
    && rm -rf ${HOME}/.cache

ENTRYPOINT ovos-gui-service
