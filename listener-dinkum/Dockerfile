ARG TAG=alpha
FROM smartgic/ovos-sound-base:${TAG}

HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=60s \
  CMD ovos-hc -s voice || exit 1

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI listener image (Dinkum implementation)"
LABEL org.opencontainers.image.description="The speech client is responsible for loading STT, VAD and Wake Word plugins"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false
ARG USER=ovos

USER root

COPY files/requirements.txt /tmp/requirements.txt
COPY --chmod=0755 files/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN apk update \
  && apk add --no-cache --virtual build-dependencies libatomic portaudio-dev pulseaudio-dev build-base python3-dev gfortran cmake openblas-dev \
  && apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing py3-onnxruntime py3-srt \
  && apk add --no-cache py3-vosk-api py3-scipy py3-scikit-learn \
  && pip3 install --no-cache-dir -f 'https://whl.smartgic.io/' tflite_runtime \
  && if [ "${ALPHA}" == "true" ]; then \
  pip3 install --no-cache-dir -r /tmp/requirements.txt --pre; \
  else \
  pip3 install --no-cache-dir -r /tmp/requirements.txt; \
  fi \
  && mkdir -p /home/"${USER}"/.local/share/{vosk,precise-lite,mycroft/listener} \
  && chown "${USER}":"${USER}" -R /home/"${USER}" \
  && apk del build-dependencies \
  && rm -rf "${HOME}"/.cache /tmp/requirements.txt

# RUN apt-get update \
#   && apt-get install -o Dpkg::Options::="--force-confold" -y --no-install-recommends libatomic1 portaudio19-dev libpulse-dev build-essential python3-dev \
#   && pip3 install -f 'https://whl.smartgic.io/' tflite_runtime \
#   && if [ "${ALPHA}" == "true" ]; then \
#   pip3 install -r /tmp/requirements.txt --pre; \
#   else \
#   pip3 install -r /tmp/requirements.txt; \
#   fi \
#   && mkdir -p /home/"${USER}"/.local/share/{vosk,precise-lite,mycroft/listener} \
#   && chown "${USER}":"${USER}" -R /home/"${USER}" \
#   && apt-get --purge remove -y portaudio19-dev libpulse-dev build-essential python3-dev \
#   && apt-get --purge autoremove -y \
#   && apt-get clean \
#   && rm -rf "${HOME}"/.cache /var/lib/apt /var/log/{apt,dpkg.log} /tmp/requirements.txt

USER "$USER"

ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]

WORKDIR /home/"${USER}"
