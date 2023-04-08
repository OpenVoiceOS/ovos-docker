FROM debian:bookworm-backports AS build

ARG BRANCH

RUN apt-get update \
    && apt-get install -y git cmake gcc g++ build-essential \
    && git clone https://github.com/OpenVoiceOS/ovos-bus-server.git -b $BRANCH /usr/src/ovos-bus-server

WORKDIR /usr/src/ovos-bus-server/server

RUN cmake . \
    && make

FROM debian:bookworm-backports

LABEL org.opencontainers.image.title="OpenVoiceOS OCI message bus, C++ implementation"
LABEL org.opencontainers.image.description="Alternative C++ messagebus server implementation for ovos-core using the WebSocket++ WebSocket library"
LABEL org.opencontainers.image.version="0.0.8"
LABEL org.opencontainers.image.created="2023-03-23T21:16:00Z"
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/smartgic/docker-mycroft/commit/fe816972b4509e77542698fa6fe0330fdc78740a"
LABEL org.opencontainers.image.vendor="OpenVoiceOS"

ARG USER=ovos

COPY --from=build /usr/src/ovos-bus-server/server/ovos-bus-server /usr/local/bin/

RUN useradd --no-log-init $USER -m -c "OpenVoiceOS user"

USER $USER

ENTRYPOINT ovos-bus-server