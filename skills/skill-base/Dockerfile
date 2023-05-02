FROM alpine:edge

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI skill base image (Alpine based)"
LABEL org.opencontainers.image.description="Used as base layer for other OCI skill images"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false
ARG USER=ovos

RUN adduser --disabled-password $USER \
    && mkdir -p /home/${USER}/.config/mycroft /home/${USER}/.cache/mycroft /home/${USER}/.local/share/mycroft /tmp/mycroft/ipc /tmp/mycroft/cache \
    && chown ${USER}:${USER} -R /home/${USER} /tmp/mycroft \
    && apk add --no-cache git python3 py3-pip py3-wheel swig \
    && apk add --no-cache --virtual .build-deps python3-dev fann-dev gcc g++ \
    && if [ "${ALPHA}" == "true" ]; then \
    # Install PyYAML before as a workaround to avoid AttributeError: cython_sources error.
    pip3 install PyYAML; \
    pip3 install ovos-core[lgpl] --pre; \
    else \
    pip3 install ovos-core[lgpl]; \
    fi \
    && apk del .build-deps \
    && rm -rf ${HOME}/.cache

USER $USER
