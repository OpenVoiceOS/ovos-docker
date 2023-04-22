ARG TAG=dev
FROM smartgic/ovos-sound-base:${TAG}

LABEL org.opencontainers.image.title="Open Voice OS OCI listener image"
LABEL org.opencontainers.image.description="The speech client is responsible for loading STT, VAD and Wake Word plugins"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-04-20T00:00:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG BRANCH
ARG USER=ovos

ENV DEBIAN_FRONTEND noninteractive
ENV OVOS_DIR /home/${USER}/listener

USER root

COPY files/requirements.txt /tmp/requirements.txt

SHELL ["/bin/bash", "-c"]

RUN apt-get update \
  && apt-get install -y portaudio19-dev libpulse-dev \
  && git clone https://github.com/OpenVoiceOS/ovos-listener.git $OVOS_DIR -b $BRANCH \
  && pip3 install -f 'https://whl.smartgic.io/' tflite_runtime onnxruntime vosk \
  && pip3 install -r /tmp/requirements.txt \
  && pip3 install $OVOS_DIR -r ${OVOS_DIR}/requirements.txt \
  && mkdir -p /home/${USER}/.local/share/vosk /home/${USER}/.local/share/precise-lite \
  && chown ${USER}:${USER} -R /home/${USER}/ \
  && apt-get remove --purge -y portaudio19-dev libpulse-dev \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf ${HOME}/.cache $OVOS_DIR /var/lib/apt /var/log/dpkg.log /tmp/requirements.txt

USER $USER

ENTRYPOINT ovos-listener
