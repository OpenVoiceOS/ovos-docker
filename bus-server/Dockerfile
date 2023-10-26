FROM debian:bookworm-slim AS build

ARG BRANCH=master

RUN apt-get update \
    && apt-get install -y --no-install-recommends git cmake gcc g++ build-essential ca-certificates \
    && git clone https://github.com/OpenVoiceOS/ovos-bus-server.git -b $BRANCH /usr/src/ovos-bus-server

WORKDIR /usr/src/ovos-bus-server/server

RUN cmake . \
    && make

FROM debian:bookworm-slim

HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=60s \
    CMD curl --header "Connection: Upgrade" --header "Upgrade: Websocket" http://127.0.0.1:8181/core || kill 1

ARG BUILD_DATE=unknown
ARG VERSION=unknown

LABEL org.opencontainers.image.title="Open Voice OS OCI message bus, C++ implementation"
LABEL org.opencontainers.image.description="Alternative C++ messagebus server implementation for ovos-core using the WebSocket++ WebSocket library"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.documentation="https://openvoiceos.github.io/community-docs"
LABEL org.opencontainers.image.source="https://github.com/OpenVoiceOS/ovos-docker"
LABEL org.opencontainers.image.vendor="Open Voice OS"

ARG USER=ovos

COPY --from=build /usr/src/ovos-bus-server/server/ovos-bus-server /usr/local/bin/

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && useradd --no-log-init $USER -m -c "Open Voice OS user" \
    && apt-get --purge autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt /var/log/{apt,dpkg.log}

USER $USER

ENV IS_OVOS_CONTAINER "true"

ENTRYPOINT ovos-bus-server
