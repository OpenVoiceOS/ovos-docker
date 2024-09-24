ARG TAG=0.1.0
FROM "smartgic/ovos-sound-base:${TAG}"

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI ggwave plugin image"
LABEL org.opencontainers.image.description="Tiny data-over-sound library to install skills, configure wireless, etc..."
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false
ARG USER=ovos

USER root

RUN apk update \
  && apk add --no-cache --virtual build-dependencies portaudio-dev build-base python3-dev \
  && pip3 install --no-cache-dir -f 'https://whl.smartgic.io/' ggwave \
  && if [ "${ALPHA}" == "true" ]; then \
  pip3 install --no-cache-dir ovos-audio-transformer-plugin-ggwave padacioso --pre; \
  else \
  pip3 install --no-cache-dir ovos-audio-transformer-plugin-ggwave padacioso; \
  fi \
  && apk del build-dependencies \
  && rm -rf "${HOME}/.cache"

USER "$USER"

ENTRYPOINT ovos-ggwave-listener

WORKDIR "/home/${USER}"
