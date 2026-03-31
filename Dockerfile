# ====== Build podsync ======
FROM golang:1.25 AS builder

WORKDIR /build
COPY . .

# Budujemy binarkę podsync
RUN go build -o podsync ./cmd/podsync

# Pobieramy yt-dlp
RUN wget -O /usr/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp && \
    chmod a+rwx /usr/bin/yt-dlp


# ====== Obraz docelowy ======
FROM alpine:3.22
WORKDIR /app

# Instalacja zależności
RUN apk --no-cache add ca-certificates python3 py3-pip ffmpeg tzdata libc6-compat deno

# Kopiujemy binarki
COPY --from=builder /usr/bin/yt-dlp /usr/local/bin/youtube-dl
COPY --from=builder /build/podsync /app/podsync

# Tworzymy katalog na pobrane pliki
RUN mkdir -p /tmp/podsync && chmod 777 /tmp/podsync

# Tworzymy minimalny config.toml, żeby podsync nie wyrzucał błędu
RUN echo 'Port = 10080\nDownloadPath = "/tmp/podsync"\nMaxParallelDownloads = 2' > /app/config.toml

# Uruchamianie podsync z wskazaniem pliku config
ENTRYPOINT ["/app/podsync"]
CMD ["--config", "/app/config.toml"]
