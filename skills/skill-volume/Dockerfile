ARG TAG=dev
FROM smartgic/ovos-skill-base:${TAG}

LABEL org.opencontainers.image.title="Open Voice OS OCI volume skill image"
LABEL org.opencontainers.image.description="Control the volume of your system"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-04-20T00:00:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="Open Voice OS"

RUN pip3 install git+https://github.com/OpenVoiceOS/skill-ovos-volume.git \
    && rm -rf ${HOME}/.cache

ENTRYPOINT ["ovos-skill-launcher", "skill-ovos-volume.openvoiceos"]