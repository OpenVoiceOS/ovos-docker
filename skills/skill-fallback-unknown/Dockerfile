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

LABEL org.opencontainers.image.title="Open Voice OS OCI fallback unknown skill image"
LABEL org.opencontainers.image.description="Capture unrecognized Utterances"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.authors="Open Voice OS Community"
LABEL org.opencontainers.image.base.name="${REGISTRY}/ovos-skill-base:${TAG}"
LABEL org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.ref.name="${REGISTRY}/ovos-skill-fallback-unknown:${TAG}"
LABEL org.opencontainers.image.revision="${GIT_SHA}"
LABEL io.openvoiceos.constraints.ref="${OVOS_RELEASES_REF}"

ADD --chmod=0644 https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/${OVOS_RELEASES_REF}/constraints-${OVOS_CHANNEL}.txt /tmp/constraints.txt

RUN --mount=type=cache,target=/home/ovos/.cache/uv,uid=1000,gid=1000,sharing=locked \
    uv pip install ovos-skill-fallback-unknown -c /tmp/constraints.txt

ENV SKILL_ID="ovos-skill-fallback-unknown.openvoiceos"

# A loaded skill answers mycroft.<skill_id>.is_ready (ovos-workshop ProcessStatus); the start period
# covers waiting for ovos-core to become ready before the skill loads.
HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=180s \
  CMD ovos-hc -s "$SKILL_ID" || exit 1

CMD ["ovos-skill-launcher", "ovos-skill-fallback-unknown.openvoiceos"]
