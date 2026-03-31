# =========================
# Builder stage
# =========================
FROM golang:1.25 AS builder

WORKDIR /build
COPY . .

# Kompilacja podsync
RUN go build -o podsync ./cmd/podsync

# yt-dlp
RUN wget -O /usr/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp && \
    chmod a+rwx /usr/bin/yt-dlp

# =========================
# Final stage
# =========================
FROM alpine:3.22

WORKDIR /app

RUN apk --no-cache add ca-certificates python3 py3-pip ffmpeg tzdata libc6-compat deno

# Skopiuj yt-dlp i podsync
COPY --from=builder /usr/bin/yt-dlp /usr/local/bin/youtube-dl
COPY --from=builder /build/podsync /app/podsync

# Tworzymy katalog na dane
RUN mkdir -p /tmp/podsync && chmod 777 /tmp/podsync

# Podsync uruchamia się całkowicie przez ENV
ENTRYPOINT ["/app/podsync"]
