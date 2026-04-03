FROM ghcr.io/mxpv/podsync:latest

RUN mkdir -p /config

COPY config.toml /config/config.toml

CMD ["podsync", "--config", "/config/config.toml"]
