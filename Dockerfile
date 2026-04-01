# Pobranie oficjalnego obrazu Go do budowania Podsync
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Pobranie najnowszej wersji Podsync (nightly)
RUN wget https://github.com/mxpv/podsync/releases/download/nightly/podsync-linux-amd64 -O podsync \
    && chmod +x podsync

# Końcowy obraz
FROM alpine:latest
WORKDIR /podsync

# Skopiowanie binarki
COPY --from=builder /app/podsync /usr/local/bin/podsync

# Kopiowanie configu
COPY config.toml /podsync/config.toml

# Punkt wejścia
ENTRYPOINT ["podsync", "-config", "/podsync/config.toml"]
