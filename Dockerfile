# ===== Builder =====
FROM golang:1.25-alpine AS builder

WORKDIR /build

# Pobierz kod Podsync
RUN apk add --no-cache git
RUN git clone https://github.com/mxpv/podsync.git .
RUN go build -o podsync

# ===== Final =====
FROM alpine:3.19

WORKDIR /app

# Skopiuj binarkę z buildera
COPY --from=builder /build/podsync /app/podsync

# Utwórz katalog na dane
RUN mkdir -p /mnt/data && chmod 777 /mnt/data

# Skopiuj konfigurację
COPY config.toml /app/config.toml

# Uruchom Podsync
CMD ["/app/podsync", "--config", "/app/config.toml"]
