FROM debian:trixie-slim

ARG BUILD_DATE=unknown
ARG CHANNEL=alpha
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI base image"
LABEL org.opencontainers.image.description="Used as base layer for other OCI images"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.authors="Open Voice OS Community"

ARG USER=ovos
ARG USER_UID=1000
ARG USER_GID=1000

COPY --chmod=0755 files/ovos-hc.py /usr/local/bin/ovos-hc

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_NO_CACHE_DIR=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

SHELL ["/bin/bash", "-c"]

# Create user with specific UID/GID for better security and consistency
RUN groupadd --gid "$USER_GID" "$USER" \
  && useradd --no-log-init --uid "$USER_UID" --gid "$USER_GID" -m -c "Open Voice OS user" "$USER"

# Install packages and setup environment
RUN apt-get update \
  && apt-get install -y --no-install-recommends --no-install-suggests \
  ca-certificates \
  git \
  curl \
  python3-pip \
  python3-venv \
  && c_rehash \
  && python3 -m venv "/home/${USER}/.venv" \
  && source "/home/${USER}/.venv/bin/activate" \
  && pip install --upgrade pip setuptools wheel \
  && mkdir -p "/home/${USER}"/.config/{mycroft,OpenVoiceOS} \
  && mkdir -p "/home/${USER}"/.cache/{mycroft,OpenVoiceOS} \
  && mkdir -p "/home/${USER}"/.local/state/mycroft \
  && mkdir -p "/home/${USER}"/.local/share/{mycroft,OpenVoiceOS} \
  && chown "${USER}:${USER}" -R "/home/${USER}" \
  && apt-get --purge autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /var/log/{apt,dpkg.log} /tmp/* /var/tmp/*

USER "$USER"

ENV OVOS_CHANNEL="$CHANNEL"
ENV IS_OVOS_CONTAINER=true
ENV PATH="/home/${USER}/.venv/bin:$PATH"
ENV VIRTUAL_ENV="/home/${USER}/.venv"
