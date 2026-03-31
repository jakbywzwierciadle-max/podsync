# 1️⃣ Etap budowy Podsync
FROM golang:1.25 AS builder

WORKDIR /build
COPY . .

# Budujemy binarkę Podsync
RUN go build -o podsync ./cmd/podsync

# Pobieramy yt-dlp
RUN wget -O /usr/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
    && chmod a+rwx /usr/bin/yt-dlp


# 2️⃣ Etap finalny z Alpine
FROM alpine:3.22

WORKDIR /app

# Instalujemy potrzebne pakiety
RUN apk --no-cache add ca-certificates python3 py3-pip ffmpeg tzdata libc6-compat deno

# Tworzymy katalog na dane Podsync
RUN mkdir -p /tmp/podsync && chmod 777 /tmp/podsync

# Kopiujemy binarkę i yt-dlp
COPY --from=builder /usr/bin/yt-dlp /usr/local/bin/youtube-dl
COPY --from=builder /build/podsync /app/podsync

# Tworzymy minimalny config.toml w kontenerze
RUN echo '[Feeds]' > /app/config.toml \
    && echo '[[Feeds]]' >> /app/config.toml \
    && echo 'Url = "https://www.youtube.com/channel/UCO6_hwMtQZ0SLElfDMaqJGQ"' >> /app/config.toml \
    && echo 'Port = 10080' >> /app/config.toml \
    && echo 'DownloadPath = "/tmp/podsync"' >> /app/config.toml \
    && echo 'MaxParallelDownloads = 2' >> /app/config.toml \
    && echo 'DataDir = "/tmp/podsync"' >> /app/config.toml

# Uruchamiamy Podsync wskazując config
ENTRYPOINT ["/app/podsync"]
CMD ["--config", "/app/config.toml"]
