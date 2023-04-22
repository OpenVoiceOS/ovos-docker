ARG TAG=dev
FROM smartgic/ovos-sound-base:${TAG}

LABEL org.opencontainers.image.title="Open Voice OS OCI PHAL image"
LABEL org.opencontainers.image.description="PHAL is our Platform/Hardware Abstraction Layer, it completely replaces the concept of hardcoded enclosure from mycroft-core"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-04-20T00:00:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG BRANCH
ARG USER=ovos

ENV OVOS_DIR /home/${USER}/phal

USER root

SHELL ["/bin/bash", "-c"]

RUN apt-get update \
    && apt-get install -y libasound2-dev procps ddcutil build-essential python3-dev \
    && git clone https://github.com/OpenVoiceOS/ovos-phal.git $OVOS_DIR -b $BRANCH \
    && pip3 install $OVOS_DIR -r ${OVOS_DIR}/requirements/requirements.txt \
    && pip3 install ovos-PHAL-plugin-alsa ovos-PHAL-plugin-pulseaudio ovos-PHAL-plugin-system ovos-plugin-manager RPi.GPIO \
    && chown ${USER}:${USER} -R /home/${USER} \
    && apt-get --purge remove --purge -y libasound2-dev build-essential python3-dev \
    && apt-get --purge autoremove -y \
    && apt-get clean \
    && rm -rf ${HOME}/.cache $OVOS_DIR /var/lib/apt /var/log/{apt,dpkg.log}

USER $USER

ENTRYPOINT ovos_PHAL
