ARG TAG=dev
FROM smartgic/ovos-sound-base:${TAG}

LABEL org.opencontainers.image.title="Open Voice OS OCI audio image"
LABEL org.opencontainers.image.description="The audio service handles playback and queueing of tracks"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-04-20T00:00:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG BRANCH
ARG USER=ovos

ENV DEBIAN_FRONTEND noninteractive
ENV OVOS_DIR /home/${USER}/audio

USER root

COPY files/requirements.txt /tmp/requirements.txt

SHELL ["/bin/bash", "-c"]

RUN curl -sS https://forslund.github.io/mycroft-desktop-repo/mycroft-desktop.gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/mimic.gpg \
  && echo "deb http://forslund.github.io/mycroft-desktop-repo bionic main" | tee -a /etc/apt/sources.list.d/mimic.list \
  && apt-get update \
  && apt-get install -y portaudio19-dev mimic \
  && git clone https://github.com/OpenVoiceOS/ovos-audio.git $OVOS_DIR -b $BRANCH \
  && pip3 install -f 'https://whl.smartgic.io/' onnxruntime \
  && pip3 install -r /tmp/requirements.txt \
  && pip3 install $OVOS_DIR -r ${OVOS_DIR}/requirements.txt \
  && mkdir -p /home/${USER}/.config/mycroft/apps \
  && chown ${USER}:${USER} -R /home/${USER}/ \
  && rm -rf /tmp/requirements.txt \
  && apt-get autoremove -y \
  && apt-get clean

USER $USER

ENTRYPOINT ovos-audio
