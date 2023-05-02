ARG TAG=dev
FROM smartgic/ovos-skill-base:${TAG}

LABEL org.opencontainers.image.title="Open Voice OS OCI personal skill image"
LABEL org.opencontainers.image.description="Learn history and personality of Mycroft"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-04-20T00:00:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false

RUN if [ "${ALPHA}" == "true" ]; then \
    pip3 install ovos-skill-personal --pre; \
    else \
    pip3 install ovos-skill-personal; \
    fi \
    && rm -rf ${HOME}/.cache

ENTRYPOINT ["ovos-skill-launcher", "ovos-skill-personal.OpenVoiceOS"]
