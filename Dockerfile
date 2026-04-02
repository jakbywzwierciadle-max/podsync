FROM mxpv/podsync:latest
COPY config.toml /app/config.toml
ENV PODSYNC_CONFIG=/app/config.toml
