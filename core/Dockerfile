ARG TAG=dev
FROM smartgic/ovos-sound-base:${TAG}

LABEL org.opencontainers.image.title="Open Voice OS OCI core image"
LABEL org.opencontainers.image.description="The skills service is responsible for loading skills and intent parsers"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-04-20T00:00:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG ALPHA=false
ARG USER=ovos

USER root

COPY --chmod=0755 files/entrypoint.sh /usr/local/bin/entrypoint.sh

SHELL ["/bin/bash", "-c"]

RUN apt-get update \
    && apt-get install -y swig libfann-dev build-essential python3-dev \
    && if [ "${ALPHA}" == "true" ]; then \
    # Until PR #313 is merged
    pip3 install it+https://github.com/OpenVoiceOS/ovos-core.git@refactor/double_pkg#egg=ovos-core[lgpl] --pre; \
    else \
    pip3 install ovos-core; \
    fi \
    && mkdir -p /home/${USER}/.local/share/mycroft/skills \
    && chown ${USER}:${USER} -R /home/${USER} \
    && apt-get --purge remove -y libfann-dev build-essential python3-dev \
    && apt-get --purge autoremove -y \
    && apt-get clean \
    && rm -rf ${HOME}/.cache /var/lib/apt /var/log/{apt,dpkg.log}

USER $USER

ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]
