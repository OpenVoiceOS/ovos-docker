# syntax=docker/dockerfile:1.26@sha256:ecfaec9ed6d810b56388c508f4121597bfbba70d41a6dfeee4d8cad5f295fc32
# core/Dockerfile

ARG SOUND_BASE_IMAGE=ovos-sound-base

############################
# RUNTIME (base for final)
############################
FROM ${SOUND_BASE_IMAGE} AS runtime

ARG SOUND_BASE_IMAGE
HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=60s \
  CMD ovos-hc -s skills || exit 1

ARG BUILD_DATE=unknown
ARG VERSION=unknown
ARG IMAGE_REF=ovos-core:dev
ARG GIT_SHA=unknown
ARG OVOS_RELEASES_REF=main
ENV OVOS_RELEASES_REF=${OVOS_RELEASES_REF}

LABEL org.opencontainers.image.title="Open Voice OS OCI core image" \
      org.opencontainers.image.description="The skills service is responsible for loading skills and intent parsers" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs" \
      org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker" \
      org.opencontainers.image.vendor="Open Voice OS" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.authors="Open Voice OS Community" \
      org.opencontainers.image.base.name="${SOUND_BASE_IMAGE}" \
      org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker" \
      org.opencontainers.image.ref.name="${IMAGE_REF}" \
      org.opencontainers.image.revision="${GIT_SHA}" \
      io.openvoiceos.constraints.ref="${OVOS_RELEASES_REF}"

ARG USER=ovos
USER root
SHELL ["/bin/bash", "-c"]

COPY files/requirements.txt /tmp/requirements.txt
COPY --chmod=0755 files/entrypoint.sh /usr/local/bin/entrypoint.sh

############################
# BUILDER (compile deps → wheels)
############################
FROM ${SOUND_BASE_IMAGE} AS builder

ARG OVOS_CHANNEL=alpha
ENV OVOS_CHANNEL=${OVOS_CHANNEL}
ARG OVOS_RELEASES_REF=main
ARG UV_PRERELEASE=allow

USER root
SHELL ["/bin/bash", "-c"]

# Build deps (incl. swig) and swig2.0 shim for fann2
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests \
      libfann-dev build-essential python3-dev git swig pkg-config \
 && if [ ! -x /usr/bin/swig2.0 ]; then ln -s /usr/bin/swig /usr/bin/swig2.0; fi

COPY files/requirements.txt /tmp/requirements.txt

ADD --chmod=0644 https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/${OVOS_RELEASES_REF}/constraints-${OVOS_CHANNEL}.txt /tmp/constraints.txt

# pre-releases only for the alpha channel (UV_PRERELEASE=allow)
RUN --mount=type=cache,target=/root/.cache/pip \
    PIP_NO_CACHE_DIR=0 python -m pip wheel $( [ "${UV_PRERELEASE}" = "allow" ] && echo --pre ) -r /tmp/requirements.txt \
        -c /tmp/constraints.txt \
        -w /tmp/wheels

############################
# FINAL: runtime + wheels + app bits
############################
FROM runtime
ARG USER=ovos
ARG UV_PRERELEASE=allow
USER root
SHELL ["/bin/bash", "-c"]

# Runtime lib needed by fann2 wheel
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt-get update \
 && apt-get install -y --no-install-recommends libfann2

# The wheelhouse is bind-mounted from the builder stage instead of copied, so it never becomes a layer.
# Same pre-release policy for the offline install.
RUN --mount=type=bind,from=builder,source=/tmp/wheels,target=/tmp/wheels \
    python -m pip install --no-index --find-links=/tmp/wheels $( [ "${UV_PRERELEASE}" = "allow" ] && echo --pre ) -r /tmp/requirements.txt \
 && python -m compileall -q -j 0 "/home/${USER}/.venv/lib" \
 && mkdir -p "/home/${USER}/.local/share/mycroft/skills" "/home/${USER}/nltk_data" \
 && chown "${USER}:${USER}" -R "/home/${USER}" \
 && rm -f /tmp/requirements.txt

USER "$USER"
WORKDIR "/home/${USER}"
ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]
