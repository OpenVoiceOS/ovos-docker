ARG TAG=dev
FROM smartgic/ovos-sound-base:${TAG}

LABEL org.opencontainers.image.title="Open Voice OS OCI audio image"
LABEL org.opencontainers.image.description="The audio service handles playback and queueing of tracks"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-04-20T00:00:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false
ARG USER=ovos

ENV DEBIAN_FRONTEND noninteractive

USER root

COPY files/requirements.txt /tmp/requirements.txt

SHELL ["/bin/bash", "-c"]

RUN curl -sS https://forslund.github.io/mycroft-desktop-repo/mycroft-desktop.gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/mimic.gpg \
  && echo "deb http://forslund.github.io/mycroft-desktop-repo bionic main" | tee -a /etc/apt/sources.list.d/mimic.list \
  && apt-get update \
  && apt-get install -y portaudio19-dev mimic build-essential python3-dev \
  && pip3 install -f 'https://whl.smartgic.io/' onnxruntime \
  && if [ "${ALPHA}" == "true" ]; then \
  pip3 install -r /tmp/requirements.txt --pre; \
  else \
  pip3 install -r /tmp/requirements.txt; \
  fi \
  && mkdir -p /home/${USER}/.config/mycroft/apps \
  && chown ${USER}:${USER} -R /home/${USER} \
  && apt-get --purge remove -y portaudio19-dev build-essential python3-dev \
  && apt-get --purge autoremove -y \
  && apt-get clean \
  && rm -rf ${HOME}/.cache /var/lib/apt /var/log/{apt,dpkg.log} /tmp/requirements.txt

USER $USER

ENTRYPOINT ovos-audio
