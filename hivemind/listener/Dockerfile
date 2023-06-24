ARG TAG=alpha
FROM smartgic/ovos-base:${TAG}

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI HiveMind listener"
LABEL org.opencontainers.image.description="Start listening for HiveMind connections"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false
ARG USER=ovos

COPY --chown=${USER}:${USER} files/requirements.txt /tmp/requirements.txt

RUN if [ "${ALPHA}" == "true" ]; then \
  pip3 install -r /tmp/requirements.txt --pre; \
  else \
  pip3 install -r /tmp/requirements.txt; \
  fi \
  && mkdir -p ${HOME}/.config/hivemind ${HOME}/.local/share/hivemind \
  && rm -rf ${HOME}/.cache /tmp/requirements.txt

ENTRYPOINT ["hivemind-core", "listen"]
