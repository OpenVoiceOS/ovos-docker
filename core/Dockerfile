ARG TAG=alpha
FROM smartgic/ovos-sound-base:${TAG}

HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=60s \
    CMD ovos-hc -s skills || exit 1

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI core image"
LABEL org.opencontainers.image.description="The skills service is responsible for loading skills and intent parsers"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false
ARG USER=ovos

USER root

COPY files/requirements.txt /tmp/requirements.txt
COPY --chmod=0755 files/entrypoint.sh /usr/local/bin/entrypoint.sh

SHELL ["/bin/bash", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends libfann-dev build-essential python3-dev \
    && if [ "${ALPHA}" == "true" ]; then \
    pip3 install -r /tmp/requirements.txt --pre; \
    else \
    pip3 install -r /tmp/requirements.txt; \
    fi \
    && mkdir -p /home/${USER}/.local/share/mycroft/skills /home/${USER}/nltk_data \
    && chown ${USER}:${USER} -R /home/${USER} \
    && apt-get --purge remove -y build-essential python3-dev \
    && apt-get --purge autoremove -y \
    && apt-get clean \
    && rm -rf ${HOME}/.cache /var/lib/apt /var/log/{apt,dpkg.log} /tmp/requirements.txt

USER $USER

ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]

WORKDIR /home/${USER}
