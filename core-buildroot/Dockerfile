# syntax=docker/dockerfile:1.27@sha256:bde3983e9c939224420ddaf6b784cc30e09b035a4dea01f581230c50809f372e
ARG TAG=0.1.0
ARG REGISTRY=docker.io/smartgic
FROM "${REGISTRY}/ovos-sound-base:${TAG}"
ARG TAG
ARG REGISTRY
ARG GIT_SHA=unknown


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

ARG USER=ovos

USER root

COPY files/requirements.txt /tmp/requirements.txt
COPY --chmod=0755 files/entrypoint.sh /usr/local/bin/entrypoint.sh

ADD --chmod=0644 https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/refs/heads/main/constraints-${CHANNEL}.txt /tmp/constraints.txt

SHELL ["/bin/bash", "-c"]

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/root/.cache/uv,sharing=locked \
    padatious_major="$(sed -n 's/^ovos[-_]padatious[^0-9]*\([0-9][0-9]*\).*/\1/p' /tmp/constraints.txt | head -1)" \
    && padatious_major="${padatious_major:-1}" \
    && if [ "${padatious_major}" -lt 2 ]; then \
    fann2_build="libfann-dev"; \
    else \
    fann2_build=""; \
    sed -i 's/^ovos-core\[lgpl,plugins\]$/ovos-core[plugins]/' /tmp/requirements.txt; \
    fi \
    && echo "ovos-padatious ${padatious_major}.x -> $(grep '^ovos-core\[' /tmp/requirements.txt)${fann2_build:+ (+ fann2 headers)}" \
    && apt-get update \
    && apt-get install -y --no-install-recommends build-essential python3-dev ${fann2_build} \
    && uv pip install -r /tmp/requirements.txt -c /tmp/constraints.txt \
    && mkdir -p "/home/${USER}/.local/share/mycroft/skills" "/home/${USER}/nltk_data" \
    && chown "${USER}:${USER}" -R "/home/${USER}" \
    && apt-get --purge remove -y build-essential python3-dev \
    && apt-get --purge autoremove -y \
    && rm -rf /var/log/{apt,dpkg.log} /tmp/requirements.txt /tmp/constraints.txt

USER "$USER"

ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]

WORKDIR "/home/${USER}"
