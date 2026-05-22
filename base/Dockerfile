# syntax=docker/dockerfile:1.24
FROM python:3.14.5-slim-trixie@sha256:c845af9399020c7e562969a13689e929074a10fd057acd1b1fad06a2fb068e97

ARG BUILD_DATE=unknown
ARG CHANNEL=alpha
ARG VERSION=unknown
ARG IMAGE_REF=ovos-base:alpha
ARG GIT_SHA=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI base image" \
      org.opencontainers.image.description="Used as base layer for other OCI images" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs" \
      org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker" \
      org.opencontainers.image.vendor="Open Voice OS" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.authors="Open Voice OS Community" \
      org.opencontainers.image.base.name="python:3.13.11-slim-trixie@sha256:56ab277ddf459858f94052252565945c34617c841818faf8f34f6896de06cffe" \
      org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker" \
      org.opencontainers.image.ref.name="${IMAGE_REF}" \
      org.opencontainers.image.revision="${GIT_SHA}"

ARG USER=ovos
ARG USER_UID=1000
ARG USER_GID=1000

COPY --chmod=0755 files/ovos-hc.py /usr/local/bin/ovos-hc

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

SHELL ["/bin/bash", "-c"]

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    printf '%s\n' \
      'path-exclude=/usr/share/doc/*' \
      'path-exclude=/usr/share/man/*' \
      'path-exclude=/usr/share/locale/*' \
      'path-include=/usr/share/locale/locale.alias' \
      > /etc/dpkg/dpkg.cfg.d/99no-docs \
 && apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests \
      ca-certificates git curl \
 && apt-get --purge autoremove -y \
 && rm -rf /usr/share/doc/* /usr/share/man/* \
 && if [ -d /usr/share/locale ]; then \
      find /usr/share/locale -mindepth 1 -maxdepth 1 ! -name locale.alias -exec rm -rf {} +; \
    fi \
 && rm -rf /var/log/{apt,dpkg.log} /tmp/* /var/tmp/*

RUN --mount=type=cache,target=/root/.cache/pip \
    groupadd --gid "$USER_GID" "$USER" \
 && useradd --no-log-init --uid "$USER_UID" --gid "$USER_GID" -m -c "Open Voice OS user" "$USER" \
 && python -m venv "/home/${USER}/.venv" \
 && source "/home/${USER}/.venv/bin/activate" \
 && PIP_NO_CACHE_DIR=0 pip install --upgrade pip setuptools wheel uv \
 && mkdir -p "/home/${USER}"/.{config,cache,local/{state,share}}/{mycroft,OpenVoiceOS} \
 && chown "${USER}:${USER}" -R "/home/${USER}"

USER "$USER"

ENV OVOS_CHANNEL="$CHANNEL" \
    IS_OVOS_CONTAINER=true \
    PATH="/home/${USER}/.venv/bin:$PATH" \
    VIRTUAL_ENV="/home/${USER}/.venv"
