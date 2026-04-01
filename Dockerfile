# Dockerfile
FROM ghcr.io/mxpv/podsync:nightly

# Tworzymy katalogi w kontenerze
RUN mkdir -p /podsync/data /podsync/media/example

# Kopiujemy plik konfiguracyjny
COPY config.toml /podsync/config.toml

# Wolumeny dla danych i mediów (opcjonalnie, ale zalecane)
VOLUME ["/podsync/data", "/podsync/media"]

# Ustawiamy katalog roboczy
WORKDIR /podsync

# Polecenie startowe
CMD ["./podsync", "-c", "config.toml"]
