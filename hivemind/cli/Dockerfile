ARG TAG=alpha
FROM smartgic/ovos-base:${TAG}

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI HiveMind CLI"
LABEL org.opencontainers.image.description="Command line to interact with HiveMind"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false
ARG USER=ovos

RUN if [ "${ALPHA}" == "true" ]; then \
  pip3 install git+https://github.com/JarbasHiveMind/HiveMind-cli.git git+https://github.com/JarbasHiveMind/HiveMind-core.git --pre; \
  else \
  pip3 install git+https://github.com/JarbasHiveMind/HiveMind-cli.git git+https://github.com/JarbasHiveMind/HiveMind-core.git; \
  fi \
  && mkdir -p ${HOME}/.config/hivemind ${HOME}/.local/share/hivemind \
  && rm -rf ${HOME}/.cache

ENV EDITOR=vim

ENTRYPOINT ["sleep", "infinity"]
