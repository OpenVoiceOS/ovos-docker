ARG TAG=alpha
FROM smartgic/ovos-skill-base:${TAG}

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI Wikipedia skill image"
LABEL org.opencontainers.image.description="Query Wikipedia for answers to all your questions. Get just a summary, or ask for more to get in-depth information"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false

RUN if [ "${ALPHA}" == "true" ]; then \
    pip3 install git+https://github.com/OpenVoiceOS/skill-ovos-wikipedia.git --pre; \
    else \
    pip3 install ovos-skill-wikipedia; \
    fi \
    && rm -rf "${HOME}/.cache"

ENTRYPOINT ["ovos-skill-launcher", "skill-ovos-wikipedia.openvoiceos"]
