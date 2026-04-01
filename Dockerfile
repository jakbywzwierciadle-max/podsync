FROM golang:1.25 AS builder

WORKDIR /build

# klon repo
RUN git clone https://github.com/mxpv/podsync.git .

# build
RUN go build -o podsync ./cmd/podsync

# yt-dlp
RUN wget -O /usr/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
    && chmod a+rwx /usr/bin/yt-dlp


FROM alpine:3.22

WORKDIR /app

RUN apk --no-cache add ca-certificates python3 py3-pip ffmpeg tzdata libc6-compat deno bash

# katalog danych (KLUCZOWE)
RUN mkdir -p /app/data && chmod 777 /app/data

COPY --from=builder /usr/bin/yt-dlp /usr/local/bin/youtube-dl
COPY --from=builder /build/podsync /app/podsync

# generowanie config + start
ENTRYPOINT ["/bin/bash", "-c", "\
echo \"Port = ${PORT:-10000}\" > /app/config.toml && \
echo \"DownloadPath = \\\"/app/data\\\"\" >> /app/config.toml && \
echo \"MaxParallelDownloads = 2\" >> /app/config.toml && \
echo \"DataDir = \\\"/app/data\\\"\" >> /app/config.toml && \
echo \"\" >> /app/config.toml && \
echo \"[Storage]\" >> /app/config.toml && \
echo \"Type = \\\"local\\\"\" >> /app/config.toml && \
echo \"\" >> /app/config.toml && \
echo \"[Feeds.feed1]\" >> /app/config.toml && \
echo \"URL = \\\"https://www.youtube.com/channel/UCO6_hwMtQZ0SLElfDMaqJGQ\\\"\" >> /app/config.toml && \
echo '===== CONFIG =====' && \
cat /app/config.toml && \
echo '==================' && \
/app/podsync --config /app/config.toml \
"]
