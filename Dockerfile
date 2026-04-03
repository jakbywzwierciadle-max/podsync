FROM ghcr.io/mxpv/podsync:latest

# Utwórz katalog na konfigurację
RUN mkdir -p /app

# Skopiuj config.toml z repo do obrazu
COPY config.toml /app/config.toml

# Skopiuj katalog data (jeśli istnieje)
COPY data /app/data

# Ustaw katalog roboczy
WORKDIR /app

# Domyślna komenda startowa
CMD ["podsync", "--config", "/app/config.toml"]
