ARG TAG=dev
FROM smartgic/ovos-base:${TAG}

LABEL org.opencontainers.image.title="Open Voice OS OCI message bus image"
LABEL org.opencontainers.image.description="Message bus service, the nervous system of OpenVoiceOS (Python implementation)"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-04-20T00:00:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG BRANCH
ARG USER=ovos

RUN pip3 install mycroft-messagebus-client git+https://github.com/OpenVoiceOS/ovos-messagebus.git@${BRANCH} \
    && rm -rf ${HOME}/.cache

ENTRYPOINT ovos-messagebus
