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

ENV DEBIAN_FRONTEND=noninteractive

USER root

SHELL ["/bin/bash", "-c"]

RUN apt-get update \
  && apt-get install -o Dpkg::Options::="--force-confold" -y --no-install-recommends portaudio19-dev build-essential python3-dev \
  && pip3 install -f 'https://whl.smartgic.io/' ggwave \
  && if [ "${ALPHA}" == "true" ]; then \
  pip3 install --no-cache-dir ovos-audio-transformer-plugin-ggwave --pre; \
  else \
  pip3 install --no-cache-dir ovos-audio-transformer-plugin-ggwave; \
  fi \
  && apt-get --purge remove -y portaudio19-dev  build-essential python3-dev \
  && apt-get --purge autoremove -y \
  && apt-get clean \
  && rm -rf "${HOME}/.cache" /var/lib/apt /var/log/{apt,dpkg.log}

USER "$USER"

ENTRYPOINT ovos-ggwave-listener

WORKDIR "/home/${USER}"
