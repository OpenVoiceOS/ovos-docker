ARG TAG=0.1.0
FROM "smartgic/ovos-skill-base:${TAG}"

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI ggwave skill image"
LABEL org.opencontainers.image.description="Allows you to enable or disable ggwave by voice"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false

RUN if [ "${ALPHA}" == "true" ]; then \
    pip3 install ovos-skill-ggwave --pre; \
    else \
    pip3 install ovos-skill-ggwave; \
    fi \
    && rm -rf "${HOME}/.cache"

ENTRYPOINT ["ovos-skill-launcher", "ovos-skill-ggwave.openvoiceos"]
