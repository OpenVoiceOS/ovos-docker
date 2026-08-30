# syntax=docker/dockerfile:1.26
# One reference for FROM and the base.name label, so a Renovate bump updates both.
ARG PYTHON_IMAGE=python:3.14.7-slim-trixie@sha256:cae66f2ef0ec51a9891263eeee7f987dacf0a9879e8aa9353d5606e0530619a5
FROM ${PYTHON_IMAGE}
ARG PYTHON_IMAGE
ARG TAG=0.1.0
ARG REGISTRY=docker.io/smartgic
ARG GIT_SHA=unknown
ARG OVOS_RELEASES_REF=main

ARG BUILD_DATE=unknown
ARG CHANNEL=alpha
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI skill base image"
LABEL org.opencontainers.image.description="Used as base layer for other OCI skill images"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.authors="Open Voice OS Community"
LABEL org.opencontainers.image.base.name="${PYTHON_IMAGE}"
LABEL org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.ref.name="${REGISTRY}/ovos-skill-base:${TAG}"
LABEL org.opencontainers.image.revision="${GIT_SHA}"
LABEL io.openvoiceos.constraints.ref="${OVOS_RELEASES_REF}"

ARG USER=ovos
ARG USER_UID=1000
ARG USER_GID=1000

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    UV_LINK_MODE=copy

SHELL ["/bin/bash", "-c"]

# uv as a pinned static binary (Renovate tracks the image reference)
COPY --from=ghcr.io/astral-sh/uv:0.12.7@sha256:95f2aa1fe59274951cfe9b0cbc7972e879ff1004bc8945d130a32eb0dbd85945 /uv /uvx /usr/local/bin/
COPY --chmod=0755 files/entrypoint.sh /usr/local/bin/skill-entrypoint.sh

# Runtime packages and the ovos user. libfann2 is the runtime half of the fann2 wheel built below.
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
      ca-certificates tzdata libfann2 \
 && apt-get --purge autoremove -y \
 && rm -rf /usr/share/doc/* /usr/share/man/* /var/log/{apt,dpkg.log} \
 && groupadd --gid "$USER_GID" "$USER" \
 && useradd --no-log-init --uid "$USER_UID" --gid "$USER_GID" -m -c "Open Voice OS user" "$USER" \
 && touch "/home/${USER}/.localtime" "/home/${USER}/.timezone" \
 && ln -sf "/home/${USER}/.localtime" /etc/localtime \
 && ln -sf "/home/${USER}/.timezone" /etc/timezone \
 && chown "${USER}:${USER}" "/home/${USER}/.localtime" "/home/${USER}/.timezone"

ADD --chmod=0644 https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/${OVOS_RELEASES_REF}/constraints-${CHANNEL}.txt /tmp/constraints.txt

# Python environment. The toolchain needed to build fann2 is installed and purged in this same layer,
# so it never ships in the image. setuptools is still needed at runtime by packages using
# pkg_resources; pinned like ovos-installer does (setuptools<82).
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/root/.cache/uv,sharing=locked \
    apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests \
      build-essential libfann-dev swig pkg-config \
 && if [ ! -x /usr/bin/swig2.0 ]; then ln -s /usr/bin/swig /usr/bin/swig2.0; fi \
 && python -m venv "/home/${USER}/.venv" \
 && source "/home/${USER}/.venv/bin/activate" \
 && uv pip install "setuptools<82" \
 && uv pip install ovos-core[lgpl] ovos-translate-server-plugin ahocorasick-ner -c /tmp/constraints.txt \
 && mkdir -p "/home/${USER}/.config/mycroft" "/home/${USER}/.config/OpenVoiceOS" \
      "/home/${USER}/.cache/mycroft" "/home/${USER}/.cache/OpenVoiceOS" \
      "/home/${USER}/.local/state/mycroft" "/home/${USER}/.local/state/OpenVoiceOS" \
      "/home/${USER}/.local/share/mycroft" "/home/${USER}/.local/share/OpenVoiceOS" \
      /tmp/mycroft/ipc /tmp/mycroft/cache \
 && chown "${USER}:${USER}" -R "/home/${USER}" /tmp/mycroft \
 && rm -f /usr/bin/swig2.0 \
 && apt-get --purge remove -y build-essential libfann-dev swig pkg-config \
 && apt-get --purge autoremove -y \
 && rm -rf /var/log/{apt,dpkg.log}

USER "$USER"

ENV OVOS_CHANNEL="$CHANNEL" \
    IS_OVOS_CONTAINER=true \
    PATH="/home/${USER}/.venv/bin:$PATH" \
    VIRTUAL_ENV="/home/${USER}/.venv"

ENTRYPOINT ["/usr/local/bin/skill-entrypoint.sh"]
