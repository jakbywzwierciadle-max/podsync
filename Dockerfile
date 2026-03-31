# =====================
# BUILDER
# =====================
FROM golang:1.25 AS builder

WORKDIR /build
COPY . .

RUN go build -o podsync ./cmd/podsync

RUN wget -O /usr/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
    && chmod a+rwx /usr/bin/yt-dlp

# =====================
# RUNTIME
# =====================
FROM alpine:3.22

WORKDIR /app

RUN apk --no-cache add ca-certificates python3 py3-pip ffmpeg tzdata libc6-compat deno bash

RUN mkdir -p /tmp/podsync && chmod 777 /tmp/podsync

COPY --from=builder /usr/bin/yt-dlp /usr/local/bin/youtube-dl
COPY --from=builder /build/podsync /app/podsync

# ENTRYPOINT generuje config.toml dynamicznie z wielu feedów
ENTRYPOINT ["/bin/bash", "-c", "\
echo 'Port = '${PORT:-10080} > /app/config.toml && \
echo 'DownloadPath = \"'${DOWNLOAD_PATH:-/tmp/podsync}'\"' >> /app/config.toml && \
echo 'MaxParallelDownloads = '${MAX_PARALLEL_DOWNLOADS:-2} >> /app/config.toml && \
echo 'DataDir = \"'${DATA_DIR:-/tmp/podsync}'\"' >> /app/config.toml && \
echo '' >> /app/config.toml && \
IFS=',' read -ra URLS <<< \"$FEED_URLS\" && \
for url in \"${URLS[@]}\"; do \
  echo '[[Feeds]]' >> /app/config.toml && \
  echo 'Url = \"'$url'\"' >> /app/config.toml && \
  echo '' >> /app/config.toml ; \
done && \
cat /app/config.toml && \
/app/podsync --config /app/config.toml \
"]
