ARG TAG=0.1.0
ARG REGISTRY=docker.io/smartgic
ARG PHAL_IMAGE=${REGISTRY}/ovos-phal:${TAG}
FROM ${PHAL_IMAGE}
ARG TAG
ARG REGISTRY
ARG GIT_SHA=unknown
ARG OVOS_RELEASES_REF=main
ENV OVOS_RELEASES_REF=${OVOS_RELEASES_REF}


HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=60s \
    CMD ovos-hc -s PHAL.admin || exit 1

ARG BUILD_DATE=unknown
ARG VERSION=unknown
ARG PHAL_IMAGE

LABEL org.opencontainers.image.title="Open Voice OS OCI PHAL Admin image"
LABEL org.opencontainers.image.description="This service is intended for handling any OS-level interactions requiring escalation of privileges"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.authors="Open Voice OS Community"
LABEL org.opencontainers.image.base.name="${REGISTRY}/ovos-phal:${TAG}"
LABEL org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.ref.name="${REGISTRY}/ovos-phal-admin:${TAG}"
LABEL org.opencontainers.image.revision="${GIT_SHA}"
LABEL io.openvoiceos.constraints.ref="${OVOS_RELEASES_REF}"

USER root

COPY --chmod=0755 files/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]

WORKDIR /root
