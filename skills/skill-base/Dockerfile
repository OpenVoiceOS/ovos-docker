# syntax=docker/dockerfile:1.26@sha256:ecfaec9ed6d810b56388c508f4121597bfbba70d41a6dfeee4d8cad5f295fc32
# Default to a local BuildKit context name; Bake maps it to target:base.
ARG BASE_IMAGE=ovos-base
FROM ${BASE_IMAGE}
ARG BASE_IMAGE
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
LABEL org.opencontainers.image.base.name="${REGISTRY}/ovos-base:${TAG}"
LABEL org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.ref.name="${REGISTRY}/ovos-skill-base:${TAG}"
LABEL org.opencontainers.image.revision="${GIT_SHA}"
LABEL io.openvoiceos.constraints.ref="${OVOS_RELEASES_REF}"

ARG USER=ovos
USER root
SHELL ["/bin/bash", "-c"]

COPY --chmod=0755 files/entrypoint.sh /usr/local/bin/skill-entrypoint.sh

ADD --chmod=0644 https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/${OVOS_RELEASES_REF}/constraints-${CHANNEL}.txt /tmp/constraints.txt

# libfann2 is the runtime half of the fann2 wheel; the toolchain that builds it is installed and
# purged in this same layer, so it never ships in the image. Timezone files are pointed at the
# user's home so the entrypoint can set TZ without root.
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/root/.cache/uv,sharing=locked \
    apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests \
      libfann2 build-essential libfann-dev swig pkg-config \
 && if [ ! -x /usr/bin/swig2.0 ]; then ln -s /usr/bin/swig /usr/bin/swig2.0; fi \
 && uv pip install ovos-core[lgpl] ovos-translate-server-plugin ahocorasick-ner -c /tmp/constraints.txt \
 && mkdir -p /tmp/mycroft/ipc /tmp/mycroft/cache \
 && touch "/home/${USER}/.localtime" "/home/${USER}/.timezone" \
 && ln -sf "/home/${USER}/.localtime" /etc/localtime \
 && ln -sf "/home/${USER}/.timezone" /etc/timezone \
 && chown "${USER}:${USER}" -R "/home/${USER}" /tmp/mycroft \
 && rm -f /usr/bin/swig2.0 \
 && apt-get --purge remove -y build-essential libfann-dev swig pkg-config \
 && apt-get --purge autoremove -y \
 && rm -rf /var/log/{apt,dpkg.log}

USER "$USER"

ENTRYPOINT ["/usr/local/bin/skill-entrypoint.sh"]
