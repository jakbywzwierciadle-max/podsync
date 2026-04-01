# Oficjalny obraz Podsync
FROM ghcr.io/mxpv/podsync:latest

# Kopiujemy config
COPY config.toml /podsync/config.toml

# Railway dynamicznie przypisuje port, dlatego CMD używa ENV PORT
ENV PORT 10000

# Uruchomienie Podsync z konfiguracją
CMD ["podsync", "-c", "/podsync/config.toml", "-p", "${PORT}"]
