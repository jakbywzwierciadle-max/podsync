# =========================
# Builder stage
# =========================
FROM golang:1.25 AS builder

WORKDIR /build

# Skopiuj cały kod źródłowy
COPY . .

# Skopiuj ścieżkę do main.go w podsync
RUN go build -o podsync ./cmd/podsync

# Pobierz yt-dlp i ustaw uprawnienia
RUN wget -O /usr/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp && \
    chmod a+rwx /usr/bin/yt-dlp


# =========================
# Final stage
# =========================
FROM alpine:3.22

WORKDIR /app

# Zainstaluj wymagane zależności
RUN apk --no-cache add ca-certificates python3 py3-pip ffmpeg tzdata libc6-compat deno

# Skopiuj yt-dlp i podsync z buildera
COPY --from=builder /usr/bin/yt-dlp /usr/local/bin/youtube-dl
COPY --from=builder /build/podsync /app/podsync

# Podsync uruchamia się z ENV, więc nie potrzebujemy config.toml
ENTRYPOINT ["/app/podsync"]
