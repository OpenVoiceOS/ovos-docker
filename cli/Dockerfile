ARG TAG=dev
FROM smartgic/ovos-base:${TAG}

LABEL org.opencontainers.image.title="OpenVoiceOS OCI CLI image"
LABEL org.opencontainers.image.description="Command line for OpenVoiceOS"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-03-23T21:16:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="OpenVoiceOS"

ARG BRANCH
ARG USER=ovos

USER root

RUN apt-get update \
    && apt-get install vim nano -y \
    && pip3 install ovos-skills-manager \
    && mkdir -p /var/log/mycroft \
    && chown ${USER}:${USER} -R /home/${USER}/ /var/log/mycroft \
    && rm -rf ${HOME}/.cache

USER $USER

ENTRYPOINT /bin/bash
