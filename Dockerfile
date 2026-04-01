# ===== Builder Stage =====
FROM golang:1.25-alpine AS builder

# Zainstaluj potrzebne narzędzia
RUN apk add --no-cache git

# Ustaw katalog roboczy
WORKDIR /build

# Pobierz repozytorium Podsync
RUN git clone https://github.com/mxpv/podsync.git .

# Buduj binarkę Podsync z właściwego folderu
RUN go build -o podsync ./cmd/podsync

# ===== Final Stage =====
FROM alpine:3.19

# Zainstaluj ffmpeg (potrzebne do konwersji audio/video)
RUN apk add --no-cache ffmpeg

# Utwórz katalog aplikacji i danych
WORKDIR /app
RUN mkdir -p /mnt/data

# Skopiuj binarkę z buildera
COPY --from=builder /build/podsync .

# Skopiuj domyślną konfigurację (jeśli masz gotowy plik)
# COPY config.yml /app/config.yml

# Ustawienie zmiennych środowiskowych dla Render
ENV DOWNLOAD_PATH=/mnt/data
ENV DATA_DIR=/mnt/data
ENV PORT=10000
ENV MAX_PARALLEL_DOWNLOADS=2

# Otwórz port
EXPOSE 10000

# Uruchom Podsync
CMD ["./podsync", "-c", "/app/config.yml"]
