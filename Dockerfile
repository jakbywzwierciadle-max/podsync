FROM ghcr.io/mxpv/podsync:v1.12.0

WORKDIR /app
COPY config.toml /app/config.toml
ENV PODSYNC_CONFIG=/app/config.toml

EXPOSE 8080
