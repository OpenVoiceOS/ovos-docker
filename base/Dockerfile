FROM debian:bookworm-backports

LABEL org.opencontainers.image.title="OpenVoiceOS OCI base image"
LABEL org.opencontainers.image.description="Used as base image for other OCI images"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-03-23T21:16:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="OpenVoiceOS"

ARG BRANCH
ARG USER=ovos

ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

RUN apt-get update \
  && apt-get install -y git python3 python3-pip python3-venv \
  && c_rehash \
  && useradd --no-log-init $USER -m -c "OpenVoiceOS user" \
  && python3 -m venv /home/${USER}/.venv \
  && . /home/${USER}/.venv/bin/activate \
  && pip3 install -U pip wheel ovos-core \
  && mkdir -p /home/${USER}/.config/mycroft /home/${USER}/.cache/mycroft /home/${USER}/.local/share/mycroft /tmp/mycroft/ipc /tmp/mycroft/cache \
  && chown ${USER}:${USER} -R /home/${USER}/ /tmp/mycroft/ \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf ${HOME}/.cache /var/lib/apt /var/log/dpkg.log

USER $USER

ENV PATH /home/${USER}/.venv/bin:$PATH
ENV VIRTUAL_ENV /home/${USER}/.venv
