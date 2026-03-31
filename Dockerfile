# ====== Faza build ======
FROM golang:1.25 AS builder

WORKDIR /build
COPY . .

# Budujemy podsync z folderu źródłowego
RUN go build -o podsync ./cmd/podsync

# Pobieramy yt-dlp
RUN wget -O /usr/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp && \
    chmod a+rwx /usr/bin/yt-dlp


# ====== Obraz docelowy ======
FROM alpine:3.22
WORKDIR /app

# Instalacja zależności potrzebnych przez podsync i yt-dlp
RUN apk --no-cache add ca-certificates python3 py3-pip ffmpeg tzdata libc6-compat deno

# Kopiujemy binarki z fazy build
COPY --from=builder /usr/bin/yt-dlp /usr/local/bin/youtube-dl
COPY --from=builder /build/podsync /app/podsync

# Tworzymy katalog na dane i nadajemy pełne prawa
RUN mkdir -p /tmp/podsync && chmod 777 /tmp/podsync

# NIE kopiujemy config.toml – konfigurujemy przez ENV
# COPY --from=builder /build/config.toml /app/config.toml  <-- usunięte/zakomentowane

# Uruchamianie podsync
ENTRYPOINT ["/app/podsync"]
