ARG TAG=alpha
FROM smartgic/ovos-base:${TAG}

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI CLI image"
LABEL org.opencontainers.image.description="Command line for Open Voice OS"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false
ARG USER=ovos

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends vim nano python3-dev build-essential \
    && if [ "${ALPHA}" == "true" ]; then \
    pip3 install ovos-config PyYAML==6.0 ovos-skills-manager ovos-plugin-manager git+https://github.com/OpenVoiceOS/ovos-cli-client.git neon-mana-utils --pre; \
    else \
    pip3 install ovos-skills-manager ovos-plugin-manager ovos-cli-client neon-mana-utils; \
    fi \
    && mkdir -p /home/"${USER}"/.local/state/mycroft /home/"${USER}"/stdout  /var/log/mycroft \
    && chown "${USER}":"${USER}" -R /home/"${USER}" /var/log/mycroft \
    && apt-get --purge remove python3-dev build-essential -y \
    && apt-get --purge autoremove -y \
    && apt-get clean \
    && rm -rf "${HOME}"/.cache

USER $USER

ENV EDITOR=vim
ENV TERM=linux

ENTRYPOINT ["sleep", "infinity"]

WORKDIR /home/"${USER}"
