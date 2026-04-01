# Pobiera oficjalny obraz Podsync
FROM ghcr.io/mxpv/podsync:latest

# Kopiuje konfigurację
COPY config.toml /app/config.toml

# Ustawienie katalogu pracy
WORKDIR /app

# Domyślna komenda startowa
CMD ["podsync", "--config", "/app/config.toml"]
