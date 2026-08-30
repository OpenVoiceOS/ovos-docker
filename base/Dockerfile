# syntax=docker/dockerfile:1.26@sha256:ecfaec9ed6d810b56388c508f4121597bfbba70d41a6dfeee4d8cad5f295fc32
# One reference for FROM and the base.name label, so a Renovate bump updates both.
ARG PYTHON_IMAGE=python:3.13.15-slim-trixie@sha256:7ce4b6dfe35e55397b7cda544f8a13f191b7ae28dc5aad71fe664dbc9bc2623f
FROM ${PYTHON_IMAGE}
ARG PYTHON_IMAGE

ARG BUILD_DATE=unknown
ARG CHANNEL=alpha
ARG VERSION=unknown
ARG IMAGE_REF=ovos-base:alpha
ARG GIT_SHA=unknown
ARG OVOS_RELEASES_REF=main

LABEL org.opencontainers.image.title="Open Voice OS OCI base image" \
      org.opencontainers.image.description="Used as base layer for other OCI images" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.documentation="https://openvoiceos.github.io/ovos-docker" \
      org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker" \
      org.opencontainers.image.vendor="Open Voice OS" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.authors="Open Voice OS Community" \
      org.opencontainers.image.base.name="${PYTHON_IMAGE}" \
      org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker" \
      org.opencontainers.image.ref.name="${IMAGE_REF}" \
      org.opencontainers.image.revision="${GIT_SHA}" \
      io.openvoiceos.constraints.ref="${OVOS_RELEASES_REF}"

ARG USER=ovos
ARG USER_UID=1000
ARG USER_GID=1000

# uv as a pinned static binary (Renovate tracks the image reference); no unpinned "pip install uv"
COPY --from=ghcr.io/astral-sh/uv:0.12.7@sha256:95f2aa1fe59274951cfe9b0cbc7972e879ff1004bc8945d130a32eb0dbd85945 /uv /uvx /usr/local/bin/
# MALLOC_ARENA_MAX=2: the services are heavily threaded; fewer glibc arenas means less RSS on small devices.
COPY --chmod=0755 files/ovos-hc.py /usr/local/bin/ovos-hc

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    MALLOC_ARENA_MAX=2

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

# The venv keeps the pip bundled with the (digest-pinned) Python image. setuptools is still needed at
# runtime by packages using pkg_resources; pinned like ovos-installer does (setuptools<82).
# Bytecode is compiled at install time (UV_COMPILE_BYTECODE, and compileall after pip installs) so
# services start fast on small devices; PYTHONDONTWRITEBYTECODE keeps the running container from
# writing .pyc files into its layer.
RUN --mount=type=cache,target=/root/.cache/uv,sharing=locked \
    groupadd --gid "$USER_GID" "$USER" \
 && useradd --no-log-init --uid "$USER_UID" --gid "$USER_GID" -m -c "Open Voice OS user" "$USER" \
 && python -m venv "/home/${USER}/.venv" \
 && source "/home/${USER}/.venv/bin/activate" \
 && uv pip install "setuptools<82" \
 && mkdir -p "/home/${USER}"/.{config,cache,local/{state,share}}/{mycroft,OpenVoiceOS} \
 && chown "${USER}:${USER}" -R "/home/${USER}"

USER "$USER"

ENV OVOS_CHANNEL="$CHANNEL" \
    IS_OVOS_CONTAINER=true \
    PATH="/home/${USER}/.venv/bin:$PATH" \
    VIRTUAL_ENV="/home/${USER}/.venv"
