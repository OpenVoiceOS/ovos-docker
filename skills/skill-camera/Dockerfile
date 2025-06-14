ARG TAG=0.1.0
ARG REGISTRY=docker.io/smartgic
FROM "${REGISTRY}/ovos-skill-base:${TAG}"

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI icamera skill image"
LABEL org.opencontainers.image.description="Let Open Voice OS to take pictures using a connected webcam"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false

RUN if [ "${ALPHA}" == "true" ]; then \
    pip3 install --no-cache-dir ovos-skill-camera --pre; \
    else \
    pip3 install --no-cache-dir ovos-skill-camera; \
    fi \
    && rm -rf "${HOME}/.cache"

ENTRYPOINT ["ovos-skill-launcher", "ovos-skill-camera.openvoiceos"]
