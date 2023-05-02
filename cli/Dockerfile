ARG TAG=dev
FROM smartgic/ovos-base:${TAG}

LABEL org.opencontainers.image.title="Open Voice OS OCI CLI image"
LABEL org.opencontainers.image.description="Command line for Open Voice OS"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-04-20T00:00:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false
ARG USER=ovos

USER root

RUN apt-get update \
    && apt-get install vim nano -y \
    && if [ "${ALPHA}" == "true" ]; then \
    pip3 install ovos-skills-manager ovos-plugin-manager ovos-cli-client --pre; \
    else \
    pip3 install ovos-skills-manager ovos-plugin-manager ovos-cli-client; \
    fi \
    && mkdir -p /home/${USER}/.local/state/mycroft /var/log/mycroft \
    && chown ${USER}:${USER} -R /home/${USER} /var/log/mycroft \
    && apt-get clean \
    && rm -rf ${HOME}/.cache

USER $USER

ENV EDITOR=vim

ENTRYPOINT ["sleep", "infinity"]
