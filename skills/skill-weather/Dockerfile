ARG TAG=alpha
FROM smartgic/ovos-skill-base:${TAG}

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI weather skill image"
LABEL org.opencontainers.image.description="Get weather conditions, forecasts, expected precipitation and more! By default, it will tell you about your device's configured location. You can also ask for other cities around the world."
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false
ARG USER=ovos

USER root

RUN apk add --no-cache libgomp

USER $USER

RUN if [ "${ALPHA}" == "true" ]; then \
    pip3 install git+https://github.com/OpenVoiceOS/skill-ovos-weather.git --pre; \
    else \
    pip3 install ovos-skill-weather; \
    fi \
    && rm -rf "${HOME}/.cache"

ENTRYPOINT ["ovos-skill-launcher", "skill-ovos-weather.openvoiceos"]
