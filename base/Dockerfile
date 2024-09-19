FROM alpine:edge

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI base image"
LABEL org.opencontainers.image.description="Used as base layer for other Open Voice OS OCI images"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG USER=ovos

COPY --chmod=0755 files/ovos-hc.py /usr/local/bin/ovos-hc

RUN apk update \
  && apk add --no-cache bash git curl python3 py3-pip py3-virtualenv \
  && addgroup "$USER" \
  && adduser "$USER" -G "$USER" -g "Open Voice OS user" -D -s /bin/bash \
  && python3 -m venv --system-site-packages "/home/${USER}/.venv" \
  && . "/home/${USER}/.venv/bin/activate" \
  && bash -c "mkdir -p /home/"${USER}"/{.config,.cache,.local/{state/mycroft,share}}/{mycroft,OpenVoiceOS}" \
  && chown "${USER}:${USER}" -R "/home/${USER}" \
  && apk del python3-dbg python3-dev python3-doc \
  && rm -rf "${HOME}/.cache"

USER "$USER"

ENV IS_OVOS_CONTAINER "true"
ENV PATH "/home/${USER}/.venv/bin:$PATH"
ENV VIRTUAL_ENV "/home/${USER}/.venv"
