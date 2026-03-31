# ====== Build Podsync ======
FROM golang:1.25 AS builder

WORKDIR /build
COPY . .

# Wyłączamy proxy Go i sumdb, aby uniknąć problemów z pobieraniem
ENV GOPROXY=direct
ENV GOSUMDB=off

# Pobieramy zależności i budujemy binarkę
RUN go mod tidy
RUN go mod download
RUN go build -o podsync ./cmd/podsync

# Pobieramy yt-dlp
RUN wget -O /usr/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp && \
    chmod a+rwx /usr/bin/yt-dlp


# ====== Obraz docelowy ======
FROM alpine:3.22

WORKDIR /app

# Instalacja zależności wymaganych przez Podsync i yt-dlp
RUN apk --no-cache add ca-certificates python3 py3-pip ffmpeg tzdata libc6-compat deno

# Kopiujemy binarkę i yt-dlp z buildera
COPY --from=builder /usr/bin/yt-dlp /usr/local/bin/youtube-dl
COPY --from=builder /build/podsync /app/podsync

# Tworzymy katalog na pobrane pliki
RUN mkdir -p /tmp/podsync && chmod 777 /tmp/podsync

# Tworzymy poprawny config.toml
RUN mkdir -p /app && \
    cat <<EOF > /app/config.toml
Port = 10080
DownloadPath = "/tmp/podsync"
MaxParallelDownloads = 2
EOF

# Uruchomienie Podsync
ENTRYPOINT ["/app/podsync"]
CMD ["--config", "/app/config.toml"]
