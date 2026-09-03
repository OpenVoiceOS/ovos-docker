# syntax=docker/dockerfile:1.27@sha256:bde3983e9c939224420ddaf6b784cc30e09b035a4dea01f581230c50809f372e
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
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/ovos-docker"
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

# fann2 is a dependency of ovos-padatious 1.x only: it is what needs the swig toolchain, and
# libfann2 is its runtime half. The 2.x line dropped fann2 and moved padatious into the plugins
# extra, so a channel on it installs none of this and asking for lgpl there only earns an
# unknown-extra warning. The channel's own padatious pin decides, rather than the channel name,
# so this keeps holding once stable and testing move to a 2.x core.
#
# The build toolchain is installed and purged in this same layer, so it never ships in the image.
# Timezone files are pointed at the user's home so the entrypoint can set TZ without root.
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/root/.cache/uv,sharing=locked \
    padatious_major="$(sed -n 's/^ovos[-_]padatious[^0-9]*\([0-9][0-9]*\).*/\1/p' /tmp/constraints.txt | head -1)" \
 && padatious_major="${padatious_major:-1}" \
 && if [ "${padatious_major}" -lt 2 ]; then \
      fann2_build="build-essential libfann-dev swig pkg-config"; \
      fann2_runtime="libfann2"; \
      core_extra="ovos-core[lgpl]"; \
    else \
      fann2_build=""; \
      fann2_runtime=""; \
      core_extra="ovos-core[plugins]"; \
    fi \
 && echo "ovos-padatious ${padatious_major}.x -> ${core_extra}${fann2_build:+ (+ fann2 toolchain)}" \
 && apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests \
      ${fann2_runtime} ${fann2_build} \
 && if [ -n "${fann2_build}" ] && [ ! -x /usr/bin/swig2.0 ]; then ln -s /usr/bin/swig /usr/bin/swig2.0; fi \
 && uv pip install "${core_extra}" ovos-translate-server-plugin ahocorasick-ner -c /tmp/constraints.txt \
 && mkdir -p /tmp/mycroft/ipc /tmp/mycroft/cache \
 && touch "/home/${USER}/.localtime" "/home/${USER}/.timezone" \
 && ln -sf "/home/${USER}/.localtime" /etc/localtime \
 && ln -sf "/home/${USER}/.timezone" /etc/timezone \
 && chown "${USER}:${USER}" -R "/home/${USER}" /tmp/mycroft \
 && rm -f /usr/bin/swig2.0 \
 && if [ -n "${fann2_build}" ]; then apt-get --purge remove -y ${fann2_build}; fi \
 && apt-get --purge autoremove -y \
 && rm -rf /var/log/{apt,dpkg.log}

# Fail the build rather than ship an image with no intent engine: padatious reaches it only
# through an ovos-core extra, so an upstream extra rename would otherwise leave the build green
# and the image useless. Runs in every build that already happens - pull request dry runs
# included, on both architectures and every channel. See the script for the reasoning.
RUN ovos-assert-intent-engine

USER "$USER"

ENTRYPOINT ["/usr/local/bin/skill-entrypoint.sh"]
