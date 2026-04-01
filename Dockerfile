# ===== Build =====
FROM golang:1.25 AS builder

WORKDIR /build

RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/mxpv/podsync.git .

WORKDIR /build/cmd/podsync
RUN go build -o /podsync

# ===== Runtime =====
FROM alpine:3.19

WORKDIR /app

RUN apk add --no-cache ca-certificates ffmpeg tzdata

# katalog na dane (Render disk)
RUN mkdir -p /mnt/data

# kopiujemy binarkę
COPY --from=builder /podsync /app/podsync

# 🔴 KLUCZ: kopiujemy config
COPY config.toml /app/config.toml

EXPOSE 10000

CMD ["/app/podsync", "--config", "/app/config.toml"]
