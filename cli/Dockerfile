ARG TAG=0.1.0
FROM "smartgic/ovos-base:${TAG}"

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI CLI image"
LABEL org.opencontainers.image.description="Command line for Open Voice OS"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false
ARG USER=ovos

USER root

COPY files/requirements.txt /tmp/requirements.txt

RUN apk update \
    && apk add --no-cache --virtual build-dependencies build-base python3-dev \
    && apk add --no-cache vim nano \
    && if [ "${ALPHA}" == "true" ]; then \
    pip3 install --no-cache-dir -r /tmp/requirements.txt --pre; \
    else \
    pip3 install --no-cache-dir -r /tmp/requirements.txt; \
    fi \
    && bash -c 'mkdir -p "/home/${USER}/.local/state/mycroft" "/home/${USER}/stdout /var/log/mycroft"' \
    && chown "${USER}:${USER}" -R "/home/${USER}" /var/log/mycroft \
    && apk del build-dependencies \
    && rm -rf "${HOME}/.cache /tmp/requirements.txt"

USER "$USER"

ENV EDITOR=vim
ENV TERM=linux

ENTRYPOINT ["sleep", "infinity"]

WORKDIR "/home/${USER}"
