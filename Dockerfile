FROM mxpv/podsync:latest

# kopiujemy config do kontenera
COPY config.toml /app/config.toml

# ustawiamy ścieżkę do configu (dla pewności)
ENV PODSYNC_CONFIG=/app/config.toml
