# ===== BUILD =====
FROM golang:1.25 AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/mxpv/podsync.git .

WORKDIR /app/cmd/podsync

# 🔴 budujemy binarkę do /app/podsync
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /app/podsync

# ===== RUNTIME =====
FROM alpine:3.19

WORKDIR /app

RUN apk add --no-cache ca-certificates ffmpeg tzdata

# 🔴 kopiujemy dokładnie z tej samej ścieżki
COPY --from=builder /app/podsync /app/podsync

COPY config.toml /app/config.toml

# 🔴 upewniamy się że jest executable
RUN chmod +x /app/podsync

EXPOSE 10000

CMD ["/app/podsync", "--config", "/app/config.toml"]
