FROM alpine:3.23

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
LABEL org.opencontainers.image.base.name="alpine:3.22"

ARG USER=ovos
ARG USER_UID=1000
ARG USER_GID=1000

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_NO_CACHE_DIR=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

SHELL ["/bin/sh", "-c"]

# Install packages and create user
RUN apk upgrade --no-cache libssl3 libcrypto3 \
  && apk add --no-cache git python3 py3-pip py3-wheel py3-numpy swig fann-dev py3-scikit-learn \
  && apk add --no-cache --virtual .build-deps python3-dev gcc g++ \
  && addgroup -g "$USER_GID" "$USER" \
  && adduser -D -u "$USER_UID" -G "$USER" -g "Open Voice OS user" "$USER"

# Setup Python environment and directories
RUN python3 -m venv "/home/${USER}/.venv" --system-site-packages \
  && source "/home/${USER}/.venv/bin/activate" \
  && pip install --upgrade pip setuptools uv \
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
