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

RUN adduser --disabled-password "$USER" \
    && mkdir -p /home/"${USER}"/.config/mycroft /home/"${USER}"/.cache/mycroft /home/"${USER}"/.local/share/mycroft /tmp/mycroft/ipc /tmp/mycroft/cache \
    && chown "${USER}":"${USER}" -R /home/"${USER}" /tmp/mycroft \
    && apk add --no-cache git python3 py3-pip py3-wheel py3-numpy swig fann-dev \
    && apk add --no-cache --virtual .build-deps python3-dev gcc g++ \
    && python3 -m venv /home/"${USER}"/.venv --system-site-packages \
    && . /home/"${USER}"/.venv/bin/activate \
    && if [ "${ALPHA}" == "true" ]; then \
    # Install PyYAML before as a workaround to avoid AttributeError: cython_sources error.
    pip3 install PyYAML; \
    pip3 install ovos-core[lgpl] ovos-translate-server-plugin --pre; \
    else \
    pip3 install ovos-core[lgpl] ovos-translate-server-plugin; \
    fi \
    && chown "${USER}":"${USER}" -R /home/"${USER}" \
    && rm -rf /home/"${USER}"/.cache

USER $USER

ENV IS_OVOS_CONTAINER "true"
ENV PATH /home/"${USER}"/.venv/bin:$PATH
ENV VIRTUAL_ENV /home/"${USER}"/.venv
