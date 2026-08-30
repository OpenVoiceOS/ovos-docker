# syntax=docker/dockerfile:1.26@sha256:ecfaec9ed6d810b56388c508f4121597bfbba70d41a6dfeee4d8cad5f295fc32
# sound-base/Dockerfile
# Multi-stage to compile pyalsaaudio without shipping toolchains.

# Default to a local BuildKit context name; Bake maps it to target:base.
ARG BASE_IMAGE=ovos-base

############################
# RUNTIME (final)
############################
FROM ${BASE_IMAGE} AS runtime

ARG BASE_IMAGE
ARG BUILD_DATE=unknown
ARG VERSION=unknown
ARG IMAGE_REF=ovos-sound-base:dev
ARG GIT_SHA=unknown
ARG OVOS_RELEASES_REF=main

LABEL org.opencontainers.image.title="Open Voice OS OCI sound base image" \
      org.opencontainers.image.description="Sound base layer for audio related images" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.documentation="https://openvoiceos.github.io/ovos-docker" \
      org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker" \
      org.opencontainers.image.vendor="Open Voice OS" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.authors="Open Voice OS Community" \
      org.opencontainers.image.base.name="${BASE_IMAGE}" \
      org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker" \
      org.opencontainers.image.ref.name="${IMAGE_REF}" \
      org.opencontainers.image.revision="${GIT_SHA}" \
      io.openvoiceos.constraints.ref="${OVOS_RELEASES_REF}"

ARG USER=ovos
USER root
SHELL ["/bin/bash", "-c"]

# Audio runtime ONLY (toolchains live in builder)
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt-get update \
 && apt-get install -o Dpkg::Options::="--force-confold" -y --no-install-recommends --no-install-suggests \
      gpg alsa-utils libasound2-plugins flac libportaudio2 \
      pulseaudio-utils pipewire pipewire-alsa mpg123 music123 \
      sox libsox-fmt-all procps \
 && apt-get --purge autoremove -y \
 && rm -rf /var/log/{apt,dpkg.log} /tmp/* /var/tmp/*

# Pulse client config (same path/name as repo)
COPY files/client.conf /etc/pulse/client.conf

# Ensure expected dirs and audio group membership
RUN mkdir -p "/home/${USER}/.config/mycroft/apps" "/home/${USER}/.config/pulse" \
 && chown "${USER}:${USER}" -R "/home/${USER}" \
 && usermod -a -G audio "$USER"

############################
# BUILDER (temporary toolchains)
############################
FROM ${BASE_IMAGE} AS builder
USER root
SHELL ["/bin/bash", "-c"]

# Build pyalsaaudio wheels against same ABI as runtime
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests \
      build-essential python3-dev libasound2-dev swig

RUN --mount=type=cache,target=/root/.cache/pip \
    PIP_NO_CACHE_DIR=0 python -m pip wheel pyalsaaudio -w /tmp/wheels

############################
# FINAL assemble
############################
FROM runtime
USER root
SHELL ["/bin/bash", "-c"]

RUN --mount=type=bind,from=builder,source=/tmp/wheels,target=/tmp/wheels \
    python -m pip install --no-index --find-links=/tmp/wheels pyalsaaudio \
 && python -m compileall -q -j 0 "/home/${USER}/.venv/lib"

ARG USER=ovos
USER "${USER}"
