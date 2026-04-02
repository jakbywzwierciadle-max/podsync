# Używamy stabilnej wersji Podsync
FROM ghcr.io/mxpv/podsync:v1.12.0

WORKDIR /app

# Kopiujemy konfigurację
COPY config.toml .

# Ustawienie zmiennej środowiskowej, żeby Podsync wiedział gdzie jest config
ENV PODSYNC_CONFIG=/app/config.toml

# Domyślny port
EXPOSE 8080

# Uruchamiamy Podsync
CMD ["podsync"]
