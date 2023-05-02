ARG TAG=alpha
FROM smartgic/ovos-phal:${TAG}

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI PHAL Admin image"
LABEL org.opencontainers.image.description="This service is intended for handling any OS-level interactions requiring escalation of privileges"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

USER root

ENTRYPOINT ovos_PHAL_admin
