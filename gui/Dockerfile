FROM debian:bookworm-slim

LABEL org.opencontainers.image.title="OpenVoiceOS OCI GUI image"
LABEL org.opencontainers.image.description=""
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-03-23T21:16:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="OpenVoiceOS"

ARG BRANCH
ARG USER=ovos

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive
ENV OVOS_DIR /opt/ovos-gui


ARG BRANCH

RUN apt-get update \
    && apt-get install -y git-core g++ cmake extra-cmake-modules gettext pkg-config qml-module-qtwebengine pkg-kde-tools qtbase5-dev qtdeclarative5-dev libkf5kio-dev libqt5websockets5-dev libkf5i18n-dev libkf5notifications-dev libkf5plasma-dev libqt5webview5-dev qtmultimedia5-dev qml-module-qtmultimedia kirigami2-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && useradd --no-log-init $USER -m -c "OpenVoiceOS user" \
    && groupdel kvm \
    && groupdel render

RUN git clone https://github.com/OpenVoiceOS/ovos-shell.git \
    ${OVOS_DIR}/gui -b $BRANCH && \
    mkdir -p ${OVOS_DIR}/gui/build-testing && \
    cd ${OVOS_DIR}/gui/build-testing && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_LIBDIR=lib -DKDE_INSTALL_USE_QT_SYS_PATHS=ON && \
    make -j $(nproc) && \
    make install

RUN git clone https://github.com/kbroulik/lottie-qml.git \
    ${OVOS_DIR}/lottie-qml && \
    mkdir -p ${OVOS_DIR}/lottie-qml/build-testing && \
    cd ${OVOS_DIR}/lottie-qml/build-testing && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_LIBDIR=lib -DKDE_INSTALL_USE_QT_SYS_PATHS=ON && \
    make -j $(nproc) && \
    make install && \
    rm -rf $OVOS_DIR

RUN mkdir -p /etc/mycroft && \
    chown ovos:ovos /etc/mycroft/

USER ovos

# COPY files/mycroft.conf /etc/mycroft/mycroft.conf

ENTRYPOINT ["mycroft-gui-app"]