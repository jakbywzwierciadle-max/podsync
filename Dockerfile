FROM golang:1.25 AS builder

WORKDIR /build
COPY . .

RUN go build -o podsync ./cmd/podsync

RUN wget -O /usr/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
    && chmod a+rwx /usr/bin/yt-dlp


FROM alpine:3.22

WORKDIR /app

RUN apk --no-cache add ca-certificates python3 py3-pip ffmpeg tzdata libc6-compat deno bash

RUN mkdir -p /app/data && chmod 777 /app/data

COPY --from=builder /usr/bin/yt-dlp /usr/local/bin/youtube-dl
COPY --from=builder /build/podsync /app/podsync

ENTRYPOINT ["/bin/bash", "-c", "\
/app/podsync \
  --port ${PORT:-10080} \
  --dir ${DATA_DIR:-/app/data} \
  https://www.youtube.com/channel/UCO6_hwMtQZ0SLElfDMaqJGQ \
"]
