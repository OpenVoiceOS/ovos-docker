# syntax=docker/dockerfile:1.24
ARG TAG=0.1.0
ARG REGISTRY=docker.io/smartgic
FROM "${REGISTRY}/ovos-sound-base:${TAG}"
ARG TAG
ARG REGISTRY
ARG GIT_SHA=unknown
ARG OVOS_RELEASES_REF=main
ENV OVOS_RELEASES_REF=${OVOS_RELEASES_REF}


HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=60s \
    CMD ovos-hc -s skills || exit 1

ARG BUILD_DATE=unknown
ARG CHANNEL=alpha
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI core image"
LABEL org.opencontainers.image.description="The skills service is responsible for loading skills and intent parsers"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.ref.name="${REGISTRY}/ovos-core-buildroot:${TAG}"
LABEL org.opencontainers.image.revision="${GIT_SHA}"
LABEL io.openvoiceos.constraints.ref="${OVOS_RELEASES_REF}"

ARG ALPHA=false
ARG USER=ovos

USER root

COPY files/requirements.txt /tmp/requirements.txt
COPY --chmod=0755 files/entrypoint.sh /usr/local/bin/entrypoint.sh

SHELL ["/bin/bash", "-c"]

ADD --chmod=0644 https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/${OVOS_RELEASES_REF}/constraints-${CHANNEL}.txt /tmp/constraints.txt

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/root/.cache/uv,sharing=locked \
    apt-get update \
    && apt-get install -y --no-install-recommends libfann-dev build-essential python3-dev  \
    && if [ "${ALPHA}" == "true" ]; then \
    uv pip install -r /tmp/requirements.txt -c /tmp/constraints.txt; \
    else \
    uv pip install -r /tmp/requirements.txt -c /tmp/constraints.txt; \
    fi \
    && mkdir -p "/home/${USER}/.local/share/mycroft/skills" "/home/${USER}/nltk_data" \
    && chown "${USER}:${USER}" -R "/home/${USER}" \
    && apt-get --purge remove -y build-essential python3-dev \
    && apt-get --purge autoremove -y \
    && rm -rf /var/log/{apt,dpkg.log} /tmp/requirements.txt

USER "$USER"

ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]

WORKDIR "/home/${USER}"
