# =====================
# BUILDER
# =====================
FROM golang:1.25 AS builder

WORKDIR /build
COPY . .

# Budujemy Podsync
RUN go build -o podsync ./cmd/podsync

# Pobieramy yt-dlp
RUN wget -O /usr/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
    && chmod a+rwx /usr/bin/yt-dlp

# =====================
# RUNTIME
# =====================
FROM alpine:3.22

WORKDIR /app

# Potrzebne pakiety
RUN apk --no-cache add ca-certificates python3 py3-pip ffmpeg tzdata libc6-compat deno bash

# Tworzymy katalog na dane Podsync
RUN mkdir -p /tmp/podsync && chmod 777 /tmp/podsync

# Kopiujemy binarki
COPY --from=builder /usr/bin/yt-dlp /usr/local/bin/youtube-dl
COPY --from=builder /build/podsync /app/podsync

# ENTRYPOINT generuje config.toml z env variables
ENTRYPOINT ["/bin/bash", "-c", "\
cat <<EOF > /app/config.toml
Port = \${PORT:-10080}
DownloadPath = \${DOWNLOAD_PATH:-/tmp/podsync}
MaxParallelDownloads = \${MAX_PARALLEL_DOWNLOADS:-2}
DataDir = \${DATA_DIR:-/tmp/podsync}

[[Feeds]]
Url = \"\${FEED_URL}\"
EOF
/app/podsync --config /app/config.toml
"]
