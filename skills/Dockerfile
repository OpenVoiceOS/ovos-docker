ARG TAG=dev
FROM smartgic/ovos-sound-base:${TAG}

LABEL org.opencontainers.image.title="OpenVoiceOS OCI skills image"
LABEL org.opencontainers.image.description="The skills service is responsible for loading skills and intent parsers"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-03-23T21:16:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="OpenVoiceOS"

ARG BRANCH
ARG USER=ovos

ENV OVOS_DIR /home/${USER}/core

USER root

COPY --chmod=0755 files/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN apt-get update \
    && apt-get install -y swig libfann-dev \
    && git clone https://github.com/OpenVoiceOS/ovos-core.git $OVOS_DIR -b $BRANCH \
    && pip3 install ovos-skills-manager \
    && pip3 install $OVOS_DIR -r ${OVOS_DIR}/requirements/minimal.txt -r ${OVOS_DIR}/requirements/extra-skills-lgpl.txt \
    && pip3 uninstall neon-utils neon-skill-alerts -y \
    && mkdir -p /home/${USER}/.local/share/mycroft/skills \
    && chown ${USER}:${USER} -R /home/${USER}/ \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf ${HOME}/.cache $OVOS_DIR

USER $USER

ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]
