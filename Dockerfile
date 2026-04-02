FROM ghcr.io/mxpv/podsync:v1.12.0
COPY config.toml /app/config.toml
ENV PODSYNC_CONFIG=/app/config.toml
