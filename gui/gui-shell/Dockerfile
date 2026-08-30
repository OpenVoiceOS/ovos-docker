# syntax=docker/dockerfile:1.26
FROM debian:13@sha256:f324c7ff54321e8d9c588493a20244965938ce0aa50bbd1022d38010e9ffc4b1
ARG TAG=0.1.0
ARG REGISTRY=docker.io/smartgic
ARG GIT_SHA=unknown


ARG BUILD_DATE=unknown
ARG CHANNEL=alpha
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI GUI image"
LABEL org.opencontainers.image.description="Mycroft GUI with the OpenVoiceOS Shell layer"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.url="https://openvoiceos.github.io/ovos-docker"
LABEL org.opencontainers.image.ref.name="${REGISTRY}/ovos-gui-shell:${TAG}"
LABEL org.opencontainers.image.revision="${GIT_SHA}"

ARG BRANCH_OVOS=master
ARG BRANCH_MYCROFT=dev
ARG USER=ovos

ENV DEBIAN_FRONTEND=noninteractive
ENV LOTTIE_DIR=/opt/lottie
ENV IS_OVOS_CONTAINER="true"
ENV MYCROFT_DIR_GUI=/opt/mycroft-gui
ENV OVOS_DIR_SHELL=/opt/ovos-shell
ENV TERM=linux

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    printf '%s\n' \
      'path-exclude=/usr/share/doc/*' \
      'path-exclude=/usr/share/man/*' \
      'path-exclude=/usr/share/locale/*' \
      'path-include=/usr/share/locale/locale.alias' \
      > /etc/dpkg/dpkg.cfg.d/99no-docs \
    && apt-get update \
    && apt-get install -y --no-install-recommends git-core build-essential cmake gettext pkg-config pkg-kde-tools qtbase5-dev qtdeclarative5-dev libkf5kio-dev libqt5websockets5-dev libkf5i18n-dev libkf5notifications-dev libkf5plasma-dev libqt5webview5-dev qtmultimedia5-dev kirigami2-dev libqt5websockets5 libqt5webview5 libkf5configcore5 qml-module-qtwebengine qml-module-qtmultimedia qml-module-qtquick-shapes libqt5virtualkeyboard5 libqt5multimedia5 libkf5dbusaddons-dev gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools ca-certificates qtvirtualkeyboard-plugin kdeconnect qt5ct breeze-icon-theme \
    && git clone https://github.com/OpenVoiceOS/mycroft-gui-qt5.git "$MYCROFT_DIR_GUI" -b "$BRANCH_MYCROFT" \
    && mkdir -p "${MYCROFT_DIR_GUI}/build-testing" \
    && cd "${MYCROFT_DIR_GUI}/build-testing" \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_LIBDIR=lib -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    && make -j "$(nproc)" \
    && make install \
    && git clone https://github.com/OpenVoiceOS/ovos-shell.git "$OVOS_DIR_SHELL" -b "$BRANCH_OVOS" \
    && mkdir -p "${OVOS_DIR_SHELL}/build-testing" \
    && cd "${OVOS_DIR_SHELL}/build-testing" \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_LIBDIR=lib -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    && make -j "$(nproc)" \
    && make install \
    && git clone https://github.com/kbroulik/lottie-qml.git "$LOTTIE_DIR" \
    && mkdir -p "${LOTTIE_DIR}/build-testing" \
    && cd "${LOTTIE_DIR}/build-testing" \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_LIBDIR=lib -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    && make -j "$(nproc)" \
    && make install \
    && useradd --no-log-init $USER -m -c "OpenVoiceOS user" \
    && mkdir -p "/home/${USER}/.local/share/OpenVoiceOS/OvosShell" "/home/${USER}/.cache/gui_files" "/home/${USER}/.config/qt5ct" \
    && chown "${USER}:${USER}" -R "/home/${USER}" \
    && apt-get --purge remove -y git-core build-essential cmake gettext pkg-config pkg-kde-tools \
    && apt-get --purge autoremove -y \
    && rm -rf /usr/share/doc/* /usr/share/man/* \
    && if [ -d /usr/share/locale ]; then \
      find /usr/share/locale -mindepth 1 -maxdepth 1 ! -name locale.alias -exec rm -rf {} +; \
    fi \
    && rm -rf "$OVOS_DIR_SHELL" "$MYCROFT_DIR_GUI" "$LOTTIE_DIR"

USER "$USER"

COPY files/qt5ct.conf "/home/${USER}/.config/qt5ct/qt5ct.conf"

ENTRYPOINT ["ovos-shell"]

WORKDIR "/home/${USER}"
