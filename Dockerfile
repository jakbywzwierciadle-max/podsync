FROM ghcr.io/mxpv/podsync:latest
WORKDIR /app
COPY config.toml .
ENV PODSYNC_CONFIG=/app/config.toml
