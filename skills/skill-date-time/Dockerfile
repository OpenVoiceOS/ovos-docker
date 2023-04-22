ARG TAG=dev
FROM smartgic/ovos-skill-base:${TAG}

LABEL org.opencontainers.image.title="Open Voice OS OCI date and time skill image"
LABEL org.opencontainers.image.description="Get the local time or time for major cities around the world"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-04-20T00:00:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG USER=ovos

USER root

RUN apk add --no-cache py3-numpy

USER $USER

RUN pip3 install git+https://github.com/OpenVoiceOS/skill-ovos-date-time.git \
    && rm -rf ${HOME}/.cache

ENTRYPOINT ["ovos-skill-launcher", "skill-ovos-date-time.openvoiceos"]
