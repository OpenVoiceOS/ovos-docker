# syntax=docker/dockerfile:1.27@sha256:bde3983e9c939224420ddaf6b784cc30e09b035a4dea01f581230c50809f372e
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

LABEL org.opencontainers.image.title="Open Voice OS OCI weather skill image"
LABEL org.opencontainers.image.description="Weather forecasts and current conditions for any location"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.authors="Open Voice OS Community"
LABEL org.opencontainers.image.base.name="${REGISTRY}/ovos-skill-base:${TAG}"
LABEL org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.ref.name="${REGISTRY}/ovos-skill-weather:${TAG}"
LABEL org.opencontainers.image.revision="${GIT_SHA}"
LABEL io.openvoiceos.constraints.ref="${OVOS_RELEASES_REF}"

ADD --chmod=0644 https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/${OVOS_RELEASES_REF}/constraints-${OVOS_CHANNEL}.txt /tmp/constraints.txt

# timezonefinder has no arm64 wheel and builds from source; the compiler is installed and purged in
# the same layer so it never ships in the image.
USER root

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/root/.cache/uv,sharing=locked \
    apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests build-essential \
 && uv pip install ovos-skill-weather -c /tmp/constraints.txt \
 && chown "${USER}:${USER}" -R "/home/${USER}/.venv" \
 && apt-get --purge remove -y build-essential \
 && apt-get --purge autoremove -y \
 && rm -rf /var/log/{apt,dpkg.log}

USER "$USER"

ENV SKILL_ID="ovos-skill-weather.openvoiceos"

# A loaded skill answers mycroft.<skill_id>.is_ready (ovos-workshop ProcessStatus); the start period
# covers waiting for ovos-core to become ready before the skill loads.
HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=180s \
  CMD ovos-hc -s "$SKILL_ID" || exit 1

CMD ["ovos-skill-launcher", "ovos-skill-weather.openvoiceos"]
