# ---- Builder ----
FROM golang:1.25 AS builder

WORKDIR /build
COPY . .

# Build Podsync
RUN go build -o podsync ./cmd/podsync

# Pobierz yt-dlp
RUN wget -O /usr/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
    && chmod a+rwx /usr/bin/yt-dlp

# ---- Final Image ----
FROM alpine:3.22

WORKDIR /app

# Podstawowe narzędzia
RUN apk --no-cache add ca-certificates python3 py3-pip ffmpeg tzdata libc6-compat deno bash

# Trwały katalog danych Render
RUN mkdir -p /mnt/data && chmod 777 /mnt/data

# Kopiowanie plików z build stage
COPY --from=builder /usr/bin/yt-dlp /usr/local/bin/youtube-dl
COPY --from=builder /build/podsync /app/podsync

# ENTRYPOINT generujący config i uruchamiający Podsync
ENTRYPOINT ["/bin/bash", "-c", "\
echo \"Port = ${PORT:-10080}\" > /app/config.toml && \
echo \"DownloadPath = \\\"${DOWNLOAD_PATH:-/mnt/data}\\\"\" >> /app/config.toml && \
echo \"MaxParallelDownloads = ${MAX_PARALLEL_DOWNLOADS:-2}\" >> /app/config.toml && \
echo \"\" >> /app/config.toml && \
echo \"[Storage]\" >> /app/config.toml && \
echo \"Type = \\\"local\\\"\" >> /app/config.toml && \
echo \"DataDir = \\\"${DATA_DIR:-/mnt/data}\\\"\" >> /app/config.toml && \
echo \"\" >> /app/config.toml && \
URLS=${FEED_URLS:-https://www.youtube.com/channel/UCO6_hwMtQZ0SLElfDMaqJGQ} && \
IFS=',' read -ra ARR <<< \"$URLS\" && \
i=1 && \
for url in \"${ARR[@]}\"; do \
  echo \"[Feeds.feed$i]\" >> /app/config.toml && \
  echo \"URL = \\\"$url\\\"\" >> /app/config.toml && \
  echo \"\" >> /app/config.toml && \
  i=$((i+1)) ; \
done && \
echo '===== CONFIG =====' && cat /app/config.toml && echo '==================' && \
/app/podsync --config /app/config.toml \
"]
