# Używamy stabilnego obrazu Podsync z Docker Hub
FROM tdeutsch/podsync:latest

# Ustawiamy katalog roboczy
WORKDIR /app

# Kopiujemy config.toml do kontenera
COPY config.toml /app/config.toml

# Podsync odczyta nasz config
ENV PODSYNC_CONFIG=/app/config.toml

# Eksponujemy port 8080 (dla web interface / feed)
EXPOSE 8080

# Nie nadpisujemy ENTRYPOINT ani CMD — obraz już uruchamia Podsync
