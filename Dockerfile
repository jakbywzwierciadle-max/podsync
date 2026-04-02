FROM tdeutsch/podsync:latest

WORKDIR /app
COPY config.toml /app/config.toml
ENV PODSYNC_CONFIG=/app/config.toml

EXPOSE 8080

# Obraz tdeutsch/podsync już ma ENTRYPOINT do podsync
