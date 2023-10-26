ARG TAG=alpha
FROM smartgic/ovos-skill-base:${TAG}

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI date and time skill image"
LABEL org.opencontainers.image.description="Get the local time or time for major cities around the world"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false

RUN if [ "${ALPHA}" == "true" ]; then \
    # ovos-audio is required because of https://github.com/OpenVoiceOS/skill-ovos-date-time/issues/22
    pip3 install ovos-skill-date-time ovos-audio --pre; \
    else \
    pip3 install ovos-skill-date-time ovos-audio; \
    fi \
    && rm -rf "${HOME}/.cache"

ENTRYPOINT ["ovos-skill-launcher", "skill-ovos-date-time.openvoiceos"]
