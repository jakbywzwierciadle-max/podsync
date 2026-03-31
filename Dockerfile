# ====== Budowanie binarki podsync ======
FROM golang:1.25 AS builder

WORKDIR /build
COPY . .

# Budujemy podsync z właściwego folderu źródłowego
RUN go build -o podsync ./cmd/podsync

# Pobieramy yt-dlp
RUN wget -O /usr/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp && \
    chmod a+rwx /usr/bin/yt-dlp


# ====== Obraz docelowy ======
FROM alpine:3.22
WORKDIR /app

# Instalacja zależności wymaganych przez podsync i yt-dlp
RUN apk --no-cache add ca-certificates python3 py3-pip ffmpeg tzdata libc6-compat deno

# Kopiujemy binarki z fazy build
COPY --from=builder /usr/bin/yt-dlp /usr/local/bin/youtube-dl
COPY --from=builder /build/podsync /app/podsync

# Tworzymy katalog na dane i dajemy pełne uprawnienia
RUN mkdir -p /tmp/podsync && chmod 777 /tmp/podsync

# Uruchamianie podsync
ENTRYPOINT ["/app/podsync"]
