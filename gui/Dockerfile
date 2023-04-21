FROM debian:bookworm-backports

LABEL org.opencontainers.image.title="Open Voice OS OCI GUI image"
LABEL org.opencontainers.image.description="Mycroft GUI with the OpenVoiceOS Shell layer"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-04-20T00:00:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG BRANCH_OVOS
ARG BRANCH_MYCROFT
ARG USER=ovos

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive
ENV OVOS_DIR_SHELL /opt/ovos-shell
ENV MYCROFT_DIR_GUI /opt/mycroft-gui
ENV LOTTIE_DIR /opt/lottie

RUN apt-get update \
    && apt-get install -y git-core g++ cmake extra-cmake-modules gettext pkg-config pkg-kde-tools qtbase5-dev qtdeclarative5-dev libkf5kio-dev libqt5websockets5-dev libkf5i18n-dev libkf5notifications-dev libkf5plasma-dev libqt5webview5-dev qtmultimedia5-dev  kirigami2-dev libqt5websockets5 libqt5webview5 libkf5configcore5 qml-module-qtwebengine qml-module-qtmultimedia libqt5multimedia5 \
    && git clone https://github.com/MycroftAI/mycroft-gui.git $MYCROFT_DIR_GUI -b $BRANCH_MYCROFT \
    && mkdir -p ${MYCROFT_DIR_GUI}/build-testing \
    && cd ${MYCROFT_DIR_GUI}/build-testing \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_LIBDIR=lib -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    && make -j $(nproc) \
    && make install \
    && git clone https://github.com/OpenVoiceOS/ovos-shell.git $OVOS_DIR_SHELL -b $BRANCH_OVOS \
    && mkdir -p ${OVOS_DIR_SHELL}/build-testing \
    && cd ${OVOS_DIR_SHELL}/build-testing \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_LIBDIR=lib -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    && make -j $(nproc) \
    && make install \
    && git clone https://github.com/kbroulik/lottie-qml.git $LOTTIE_DIR \
    && mkdir -p ${LOTTIE_DIR}/build-testing \
    && cd ${LOTTIE_DIR}/build-testing \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_LIBDIR=lib -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    && make -j $(nproc) \
    && make install \
    && useradd --no-log-init $USER -m -c "OpenVoiceOS user" \
    && mkdir -p /home/${USER}/.local/share/OpenVoiceOS/OvosShell \
    && chown ${USER}:${USER} -R /home/${USER}/.local/share/OpenVoiceOS \
    && groupdel kvm \
    && groupdel render \
    && apt-get remove -y git-core g++ cmake extra-cmake-modules gettext pkg-config pkg-kde-tools \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf $OVOS_DIR_SHELL $MYCROFT_DIR_GUI $LOTTIE_DIR

USER ovos

ENTRYPOINT ovos-shell
