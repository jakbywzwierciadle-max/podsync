# Dockerfile
FROM ghcr.io/mxpv/podsync:nightly

# Tworzenie potrzebnych katalogów
RUN mkdir -p /podsync/media/example /podsync/media/another /podsync/cache /podsync/temp

# Kopiowanie configu
COPY config.toml /podsync/config.toml

# Ustawienie katalogu roboczego
WORKDIR /podsync

# Uruchomienie Podsync
CMD ["podsync", "--config", "config.toml"]
