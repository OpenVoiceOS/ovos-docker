# syntax=docker/dockerfile:1.24
ARG TAG=0.1.0
ARG REGISTRY=docker.io/smartgic
ARG SOUND_BASE_IMAGE=${REGISTRY}/ovos-sound-base:${TAG}
FROM ${SOUND_BASE_IMAGE}
ARG TAG
ARG REGISTRY
ARG GIT_SHA=unknown
ARG UV_PRERELEASE=allow


HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=60s \
  CMD ovos-hc -s voice || exit 1

ARG BUILD_DATE=unknown
ARG VERSION=unknown
ARG SOUND_BASE_IMAGE

LABEL org.opencontainers.image.title="Open Voice OS OCI listener image (Dinkum implementation)"
LABEL org.opencontainers.image.description="The speech client is responsible for loading STT, VAD and Wake Word plugins"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.authors="Open Voice OS Community"
LABEL org.opencontainers.image.base.name="${REGISTRY}/ovos-sound-base:${TAG}"
LABEL org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.ref.name="${REGISTRY}/ovos-listener:${TAG}"
LABEL org.opencontainers.image.revision="${GIT_SHA}"

ARG USER=ovos

COPY files/requirements.txt /tmp/requirements.txt
COPY --chmod=0755 files/entrypoint.sh /usr/local/bin/entrypoint.sh

USER root

SHELL ["/bin/bash", "-c"]

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/root/.cache/uv,sharing=locked \
    apt-get update \
 && apt-get install -o Dpkg::Options::="--force-confold" -y --no-install-recommends --no-install-suggests libatomic1 portaudio19-dev libpulse-dev build-essential python3-dev \
 && uv pip install -f 'https://whl.smartgic.io/' tflite_runtime \
 && uv pip install --prerelease=${UV_PRERELEASE} -r /tmp/requirements.txt -c https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/refs/heads/main/constraints-${OVOS_CHANNEL}.txt \
 && mkdir -p "/home/${USER}/.local/share/vosk" "/home/${USER}/.local/share/precise-lite" "/home/${USER}/.local/share/mycroft/listener" \
 && chown "${USER}:${USER}" -R "/home/${USER}" \
 && apt-get --purge remove -y portaudio19-dev libpulse-dev build-essential python3-dev \
 && apt-get --purge autoremove -y \
 && rm -rf /var/log/{apt,dpkg.log} /tmp/* /var/tmp/*

USER "$USER"

ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]

WORKDIR "/home/${USER}"
