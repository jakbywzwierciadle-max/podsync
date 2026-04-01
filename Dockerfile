# ===== Builder =====
FROM golang:1.21-alpine AS builder
WORKDIR /build
RUN apk add --no-cache git
RUN git clone https://github.com/mxpv/podsync.git .
RUN go build -o podsync

# ===== Final =====
FROM alpine:3.18
WORKDIR /app
COPY --from=builder /build/podsync /app/podsync
COPY config.yml /app/config.yml
RUN mkdir -p /mnt/data
EXPOSE 10000
CMD ["/app/podsync", "/app/config.yml"]
