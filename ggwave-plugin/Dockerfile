ARG TAG=0.1.0
ARG REGISTRY=docker.io/smartgic
FROM "${REGISTRY}/ovos-sound-base:${TAG}"

ARG BUILD_DATE=unknown
ARG VERSION=unknown
ARG TAG
ARG REGISTRY

LABEL org.opencontainers.image.title="Open Voice OS OCI ggwave plugin image"
LABEL org.opencontainers.image.description="Tiny data-over-sound library to install skills, configure wireless, etc..."
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.authors="Open Voice OS Community"
LABEL org.opencontainers.image.base.name="${REGISTRY}/ovos-sound-base:${TAG}"

ARG USER=ovos

USER root

SHELL ["/bin/bash", "-c"]

RUN apt-get update \
  && apt-get install -o Dpkg::Options::="--force-confold" -y --no-install-recommends --no-install-suggests portaudio19-dev build-essential python3-dev \
  && pip3 install -f 'https://whl.smartgic.io/' ggwave \
  && pip3 install ovos-audio-transformer-plugin-ggwave padacioso -c https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/refs/heads/main/constraints-${OVOS_CHANNEL}.txt \
  && apt-get --purge remove -y portaudio19-dev build-essential python3-dev \
  && apt-get --purge autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /var/log/{apt,dpkg.log} /tmp/* /var/tmp/*

USER "$USER"

ENTRYPOINT ["ovos-ggwave-listener"]

WORKDIR "/home/${USER}"
