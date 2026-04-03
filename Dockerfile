FROM ghcr.io/mxpv/podsync:latest

RUN mkdir -p /etc/podsync

COPY config.toml /etc/podsync/config.toml

CMD ["podsync", "--config", "/etc/podsync/config.toml"]
