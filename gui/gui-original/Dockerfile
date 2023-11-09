FROM debian:bookworm-backports

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI Mycroft original GUI image"
LABEL org.opencontainers.image.description="Mycroft original GUI"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG BRANCH_OVOS=master
ARG BRANCH_MYCROFT=dev
ARG USER=ovos

ENV DEBIAN_FRONTEND noninteractive
ENV LOTTIE_DIR /opt/lottie
ENV IS_OVOS_CONTAINER "true"
ENV MYCROFT_DIR_GUI /opt/mycroft-gui
ENV TERM linux

RUN apt-get update \
    && apt-get install -y --no-install-recommends git-core build-essential cmake gettext pkg-config pkg-kde-tools qtbase5-dev qtdeclarative5-dev libkf5kio-dev libqt5websockets5-dev libkf5i18n-dev libkf5notifications-dev libkf5plasma-dev libqt5webview5-dev qtmultimedia5-dev kirigami2-dev libqt5websockets5 libqt5webview5 libkf5configcore5 qml-module-qtwebengine qml-module-qtmultimedia qml-module-qtquick-shapes libqt5virtualkeyboard5 libqt5multimedia5 libkf5dbusaddons-dev gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-omx-generic ca-certificates \
    && git clone https://github.com/OpenVoiceOS/mycroft-gui-qt5.git "$MYCROFT_DIR_GUI" -b "$BRANCH_MYCROFT" \
    && mkdir -p "${MYCROFT_DIR_GUI}"/build-testing \
    && cd "${MYCROFT_DIR_GUI}"/build-testing \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_LIBDIR=lib -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    && make -j $(nproc) \
    && make install \
    && git clone https://github.com/kbroulik/lottie-qml.git "$LOTTIE_DIR" \
    && mkdir -p "${LOTTIE_DIR}"/build-testing \
    && cd "${LOTTIE_DIR}"/build-testing \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_LIBDIR=lib -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    && make -j $(nproc) \
    && make install \
    && useradd --no-log-init "$USER" -m -c "OpenVoiceOS user" \
    && mkdir -p /home/"${USER}"/.local/share/OpenVoiceOS/OvosShell /home/"${USER}"/.cache/gui_files \
    && chown "${USER}":"${USER}" -R /home/"${USER}" \
    && apt-get --purge remove -y git-core build-essential cmake gettext pkg-config pkg-kde-tools \
    && apt-get --purge autoremove -y \
    && apt-get clean \
    && rm -rf "$MYCROFT_DIR_GUI" "$LOTTIE_DIR"

USER "$USER"

ENTRYPOINT ovos-gui-app

