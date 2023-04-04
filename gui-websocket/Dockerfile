ARG TAG=dev
FROM smartgic/ovos-base:${TAG}

LABEL org.opencontainers.image.title="OpenVoiceOS OCI GUI websocket image"
LABEL org.opencontainers.image.description="Websocket process to handle messages for the OpenVoiceOS GUI"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-03-23T21:16:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="OpenVoiceOS"

ARG BRANCH
ARG USER=ovos

ENV OVOS_DIR /home/${USER}/gui-ws

RUN git clone https://github.com/OpenVoiceOS/ovos-gui.git $OVOS_DIR -b $BRANCH \
    && pip3 install $OVOS_DIR -r ${OVOS_DIR}/requirements.txt \
    && rm -rf ${HOME}/.cache $OVOS_DIR

ENTRYPOINT ovos-gui-service
