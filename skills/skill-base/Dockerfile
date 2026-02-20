# syntax=docker/dockerfile:1.21
FROM python:3.14.3-alpine3.23@sha256:faee120f7885a06fcc9677922331391fa690d911c020abb9e8025ff3d908e510
ARG TAG=0.1.0
ARG REGISTRY=docker.io/smartgic
ARG GIT_SHA=unknown


ARG BUILD_DATE=unknown
ARG CHANNEL=alpha
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI skill base image (Alpine based)"
LABEL org.opencontainers.image.description="Used as base layer for other OCI skill images"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.authors="Open Voice OS Community"
LABEL org.opencontainers.image.base.name="python:3.13.11-alpine3.23@sha256:e7e041128ffc3e3600509f508e44d34ab08ff432bdb62ec508d01dfc5ca459f7"
LABEL org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.ref.name="${REGISTRY}/ovos-skill-base:${TAG}"
LABEL org.opencontainers.image.revision="${GIT_SHA}"

ARG USER=ovos
ARG USER_UID=1000
ARG USER_GID=1000

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_NO_CACHE_DIR=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV UV_LINK_MODE=copy

SHELL ["/bin/sh", "-c"]

COPY --chmod=0755 files/entrypoint.sh /usr/local/bin/skill-entrypoint.sh

# Install packages and create user
RUN --mount=type=cache,target=/var/cache/apk \
  apk update \
  && apk upgrade libssl3 libcrypto3 \
  && apk add fann tzdata \
  && apk add --virtual .build-deps swig fann-dev gcc g++ \
  && addgroup -g "$USER_GID" "$USER" \
  && adduser -D -u "$USER_UID" -G "$USER" -g "Open Voice OS user" "$USER" \
  && touch "/home/${USER}/.localtime" "/home/${USER}/.timezone" \
  && ln -sf "/home/${USER}/.localtime" /etc/localtime \
  && ln -sf "/home/${USER}/.timezone" /etc/timezone \
  && chown "${USER}:${USER}" "/home/${USER}/.localtime" "/home/${USER}/.timezone"

# Setup Python environment and directories
RUN --mount=type=cache,target=/var/cache/apk \
  --mount=type=cache,target=/root/.cache/pip \
  --mount=type=cache,target=/root/.cache/uv,sharing=locked \
  python3 -m venv "/home/${USER}/.venv" --system-site-packages \
  && source "/home/${USER}/.venv/bin/activate" \
  && PIP_NO_CACHE_DIR=0 pip install --upgrade pip setuptools uv \
  && uv pip install ovos-core[lgpl] ovos-translate-server-plugin ahocorasick-ner -c https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/refs/heads/main/constraints-${CHANNEL}.txt \
  && mkdir -p "/home/${USER}/.config/mycroft" "/home/${USER}/.config/OpenVoiceOS" \
  "/home/${USER}/.cache/mycroft" "/home/${USER}/.cache/OpenVoiceOS" \
  "/home/${USER}/.local/state/mycroft" "/home/${USER}/.local/state/OpenVoiceOS" \
  "/home/${USER}/.local/share/mycroft" "/home/${USER}/.local/share/OpenVoiceOS" \
  /tmp/mycroft/ipc /tmp/mycroft/cache \
  && chown "${USER}:${USER}" -R "/home/${USER}" /tmp/mycroft \
  && apk del .build-deps

USER "$USER"

ENV OVOS_CHANNEL="$CHANNEL"
ENV IS_OVOS_CONTAINER=true
ENV PATH="/home/${USER}/.venv/bin:$PATH"
ENV VIRTUAL_ENV="/home/${USER}/.venv"

ENTRYPOINT ["/usr/local/bin/skill-entrypoint.sh"]
