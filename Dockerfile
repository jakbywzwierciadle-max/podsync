# --- BUILD ---
FROM golang:1.25-alpine AS builder

RUN apk add --no-cache git

WORKDIR /build

RUN git clone https://github.com/mxpv/podsync.git .

# 🔥 KLUCZOWA ZMIANA
WORKDIR /build/cmd/podsync

RUN go build -o /build/podsync

# --- RUNTIME ---
FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

COPY --from=builder /build/podsync /app/podsync

RUN chmod +x /app/podsync

RUN mkdir -p /data

ENV CONFIG_PATH=/data/config.toml

EXPOSE 8080

CMD ["./podsync"]
