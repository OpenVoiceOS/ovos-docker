ARG TAG=alpha
FROM smartgic/ovos-skill-base:${TAG}

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI fallback ChatGPT skill image"
LABEL org.opencontainers.image.description="Capture unrecognized utterances and ask to ChatGPT"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false

COPY --chmod=0755 files/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN if [ "${ALPHA}" == "true" ]; then \
    pip3 install git+https://github.com/OpenVoiceOS/skill-ovos-fallback-chatgpt.git --pre; \
    else \
    pip3 install ovos-skill-fallback-chatgpt; \
    fi \
    && rm -rf "${HOME}/.cache" \
    && mkdir -p "${HOME}"/.config/mycroft/skills/skill-ovos-fallback-chatgpt.openvoiceos

ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]

WORKDIR /home/"${USER}"
