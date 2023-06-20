ARG TAG=alpha
FROM smartgic/ovos-base:${TAG}

HEALTHCHECK --interval=30s --timeout=3s --retries=2 --start-period=30s \
    CMD curl --header "Connection: Upgrade" http://127.0.0.1:8181 || kill 1

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI message bus image"
LABEL org.opencontainers.image.description="Message bus service, the nervous system of OpenVoiceOS (Python implementation)"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false

RUN if [ "${ALPHA}" == "true" ]; then \
    pip3 install ovos-messagebus --pre; \
    else \
    pip3 install ovos-messagebus; \
    fi \
    && rm -rf ${HOME}/.cache

ENTRYPOINT ovos-messagebus
