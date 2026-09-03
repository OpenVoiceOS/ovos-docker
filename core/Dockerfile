# syntax=docker/dockerfile:1.27@sha256:bde3983e9c939224420ddaf6b784cc30e09b035a4dea01f581230c50809f372e
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
      org.opencontainers.image.documentation="https://openvoiceos.github.io/ovos-docker" \
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

COPY files/requirements.txt /tmp/requirements.txt

ADD --chmod=0644 https://raw.githubusercontent.com/OpenVoiceOS/ovos-releases/${OVOS_RELEASES_REF}/constraints-${OVOS_CHANNEL}.txt /tmp/constraints.txt

# Build deps, plus the swig toolchain and swig2.0 shim only where fann2 is still built.
#
# fann2 is a dependency of ovos-padatious 1.x, which reaches the venv through the lgpl extra.
# The 2.x line dropped fann2 and moved padatious into plugins, so a channel on it needs neither
# the toolchain nor lgpl - asking for that extra there only earns an unknown-extra warning. The
# decision comes from the channel's own padatious pin rather than its name, so it keeps holding
# once stable and testing move to a 2.x core, and an unreadable pin falls back to building fann2.
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    padatious_major="$(sed -n 's/^ovos[-_]padatious[^0-9]*\([0-9][0-9]*\).*/\1/p' /tmp/constraints.txt | head -1)" \
 && padatious_major="${padatious_major:-1}" \
 && if [ "${padatious_major}" -lt 2 ]; then \
      fann2_build="libfann-dev swig pkg-config"; \
    else \
      fann2_build=""; \
      sed -i 's/^ovos-core\[lgpl,plugins\]$/ovos-core[plugins]/' /tmp/requirements.txt; \
    fi \
 && echo "ovos-padatious ${padatious_major}.x -> $(grep '^ovos-core\[' /tmp/requirements.txt)${fann2_build:+ (+ fann2 toolchain)}" \
 && apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests \
      build-essential python3-dev git ${fann2_build} \
 && if [ -n "${fann2_build}" ] && [ ! -x /usr/bin/swig2.0 ]; then ln -s /usr/bin/swig /usr/bin/swig2.0; fi

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

# This stage inherits /tmp/requirements.txt from `runtime`, so it is the untouched copy - the
# builder edited its own. Rather than re-deriving the padatious major here, both halves hang off
# one observable fact: whether the builder actually produced a fann2 wheel. Present means
# padatious 1.x, which needs the libfann2 runtime and the lgpl extra; absent means 2.x, which
# needs neither, and asking for lgpl there only earns an unknown-extra warning.
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=bind,from=builder,source=/tmp/wheels,target=/tmp/wheels \
    if compgen -G "/tmp/wheels/fann2-*.whl" > /dev/null; then \
      echo "fann2 wheel present -> libfann2 + ovos-core[lgpl,plugins]"; \
      apt-get update && apt-get install -y --no-install-recommends libfann2; \
    else \
      echo "no fann2 wheel -> no libfann2, ovos-core[plugins]"; \
      sed -i 's/^ovos-core\[lgpl,plugins\]$/ovos-core[plugins]/' /tmp/requirements.txt; \
    fi

# The wheelhouse is bind-mounted from the builder stage instead of copied, so it never becomes a layer.
# Same pre-release policy for the offline install.
RUN --mount=type=bind,from=builder,source=/tmp/wheels,target=/tmp/wheels \
    python -m pip install --no-index --find-links=/tmp/wheels $( [ "${UV_PRERELEASE}" = "allow" ] && echo --pre ) -r /tmp/requirements.txt \
 && python -m compileall -q -j 0 "/home/${USER}/.venv/lib" \
 && mkdir -p "/home/${USER}/.local/share/mycroft/skills" "/home/${USER}/nltk_data" \
 && chown "${USER}:${USER}" -R "/home/${USER}" \
 && rm -f /tmp/requirements.txt

# Fail the build rather than ship an image with no intent engine.
#
# padatious reaches the venv only through an ovos-core extra, and which extra carries it changed
# between the 1.x and 2.x lines. That makes it quietly droppable: an upstream extra rename, or a
# well-meant "the lgpl extra is obsolete" edit, leaves every build green and every image useless.
# Asserting here rather than in CI means it runs in each build that already happens - pull request
# dry runs included, on both architectures and every channel - with no image loading needed.
#
# The fann2 half is derived from the padatious that actually landed, not from the channel, so it
# keeps holding once stable and testing move to a 2.x core.
RUN <<'PY' python
from importlib.metadata import PackageNotFoundError, version


def installed(name):
    try:
        return version(name)
    except PackageNotFoundError:
        return None


padatious = installed("ovos-padatious")
if padatious is None:
    raise SystemExit(
        "no intent engine: ovos-padatious is not installed. It reaches this image only "
        "through an ovos-core extra, so an extra changed without a replacement requirement."
    )

fann2 = installed("fann2")
needs_fann2 = int(padatious.split(".")[0]) < 2

if needs_fann2 and fann2 is None:
    raise SystemExit(
        f"ovos-padatious {padatious} is a 1.x release and needs fann2, but fann2 is not "
        "installed - the build chain was skipped where it was still required."
    )

if not needs_fann2 and fann2 is not None:
    print(f"note: ovos-padatious {padatious} does not need fann2, yet fann2 {fann2} is present")

print(f"intent engine ok: ovos-padatious {padatious}, fann2 {fann2 or 'not needed'}")
PY

USER "$USER"
WORKDIR "/home/${USER}"
ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]
