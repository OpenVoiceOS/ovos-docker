ARG TAG=alpha
FROM smartgic/ovos-skill-base:${TAG}

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI persona skill image"
LABEL org.opencontainers.image.description="Give Open Voice OS some sass with Persona!"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false

RUN if [ "${ALPHA}" == "true" ]; then \
    pip3 install git+https://github.com/OpenVoiceOS/ovos-persona.git --pre; \
    else \
    pip3 install ovos-persona; \
    fi \
    && rm -rf "${HOME}/.cache"

ENTRYPOINT ["ovos-skill-launcher", "persona.openvoiceos"]
