FROM ghcr.io/mxpv/podsync:latest

RUN mkdir -p /opt/podsync

COPY config.toml /opt/podsync/config.toml

WORKDIR /opt/podsync
