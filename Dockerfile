FROM golang:1.22 AS builder

WORKDIR /build
RUN git clone https://github.com/mxpv/podsync.git .
RUN go build -o podsync

FROM alpine:3.19

WORKDIR /app

RUN apk --no-cache add ca-certificates ffmpeg python3 py3-pip bash

# yt-dlp
RUN wget -O /usr/local/bin/youtube-dl https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
    && chmod a+rx /usr/local/bin/youtube-dl

# dane
RUN mkdir -p /data && chmod 777 /data

COPY --from=builder /build/podsync /app/podsync

# dynamiczny config z ENV
ENTRYPOINT ["/bin/bash", "-c", "\
echo '[server]' > /app/config.toml && \
echo 'port = '${PORT:-10000} >> /app/config.toml && \
echo '' >> /app/config.toml && \
echo '[storage]' >> /app/config.toml && \
echo 'type = \"local\"' >> /app/config.toml && \
echo 'data_dir = \"'/data'\"' >> /app/config.toml && \
echo '' >> /app/config.toml && \
echo '[feeds]' >> /app/config.toml && \
URLS=${FEED_URLS} && \
IFS=',' read -ra ARR <<< \"$URLS\" && \
i=1 && \
for url in \"${ARR[@]}\"; do \
  echo \"  [feeds.feed$i]\" >> /app/config.toml && \
  echo \"  url = \\\"$url\\\"\" >> /app/config.toml && \
  echo '' >> /app/config.toml && \
  i=$((i+1)) ; \
done && \
echo '===== CONFIG =====' && \
cat /app/config.toml && \
echo '==================' && \
/app/podsync --config /app/config.toml \
"]
