# syntax=docker/dockerfile:1.26
ARG TAG=0.1.0
ARG REGISTRY=docker.io/smartgic
ARG SKILL_BASE_IMAGE=${REGISTRY}/ovos-skill-base:${TAG}
FROM ${SKILL_BASE_IMAGE}
ARG TAG
ARG REGISTRY
ARG GIT_SHA=unknown
ARG OVOS_RELEASES_REF=main


ARG BUILD_DATE=unknown
ARG VERSION=unknown
ARG SKILL_BASE_IMAGE
ARG USER=ovos

LABEL org.opencontainers.image.title="Open Voice OS OCI date and time skill image"
LABEL org.opencontainers.image.description="Get the local time or time for major cities around the world"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.authors="Open Voice OS Community"
LABEL org.opencontainers.image.base.name="${REGISTRY}/ovos-skill-base:${TAG}"
LABEL org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.ref.name="${REGISTRY}/ovos-skill-date-time:${TAG}"
LABEL org.opencontainers.image.revision="${GIT_SHA}"
LABEL io.openvoiceos.constraints.ref="${OVOS_RELEASES_REF}"
# ovos-audio is required because of https://github.com/OpenVoiceOS/skill-ovos-date-time/issues/22

ADD --chmod=0644 https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/${OVOS_RELEASES_REF}/constraints-${OVOS_CHANNEL}.txt /tmp/constraints.txt

# Some dependencies have no pre-built wheel for every architecture; the toolchain is installed and
# purged in the same layer so it never ships in the image.
USER root

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/root/.cache/uv,sharing=locked \
    apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests build-essential cmake \
 && uv pip install ovos-skill-date-time ovos-audio -c /tmp/constraints.txt \
 && chown "${USER}:${USER}" -R "/home/${USER}/.venv" \
 && apt-get --purge remove -y build-essential cmake \
 && apt-get --purge autoremove -y \
 && rm -rf /var/log/{apt,dpkg.log}

USER "$USER"

CMD ["ovos-skill-launcher", "ovos-skill-date-time.openvoiceos"]
