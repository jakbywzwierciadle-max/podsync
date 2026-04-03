FROM ghcr.io/mxpv/podsync:latest

# Tworzymy katalog, którego Railway nie nadpisuje
RUN mkdir -p /opt/podsync

# Kopiujemy config do bezpiecznego miejsca
COPY config.toml /opt/podsync/config.toml

# Ustawiamy katalog roboczy
WORKDIR /opt/podsync

# Uruchamiamy Podsync z pełną ścieżką
CMD ["podsync", "--config", "/opt/podsync/config.toml"]
