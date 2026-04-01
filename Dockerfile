# ===== Builder =====
FROM golang:1.25-alpine AS builder

WORKDIR /build

RUN apk add --no-cache git

# Pobierz repo
RUN git clone https://github.com/mxpv/podsync.git .

# Buduj z właściwego folderu
RUN go build -o podsync ./cmd/podsync

# ===== Final =====
FROM alpine:3.19

WORKDIR /app

# FFmpeg wymagany przez podsync
RUN apk add --no-cache ffmpeg

# Skopiuj binarkę
COPY --from=builder /build/podsync /app/podsync

# Skopiuj config
COPY config.yml /app/config.yml

# Katalog na dane
RUN mkdir -p /mnt/data && chmod 777 /mnt/data

EXPOSE 10000

CMD ["/app/podsync", "/app/config.yml"]
