FROM golang:1.25 AS builder

WORKDIR /build
COPY . .

RUN go build -o podsync ./cmd/podsync

RUN wget -O /usr/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
    && chmod a+rwx /usr/bin/yt-dlp

FROM alpine:3.22

WORKDIR /app

RUN apk --no-cache add ca-certificates python3 py3-pip ffmpeg tzdata libc6-compat bash \
    && mkdir -p /mnt/data \
    && chmod 777 /mnt/data

COPY --from=builder /build/podsync /app/podsync
COPY config.toml /app/config.toml
COPY --from=builder /usr/bin/yt-dlp /usr/local/bin/yt-dlp

CMD ["/app/podsync", "--config", "/app/config.toml"]
