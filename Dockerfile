# Oficjalny obraz Podsync
FROM ghcr.io/mxpv/podsync:latest

# Kopiujemy konfigurację
COPY config.toml /podsync/config.toml

# Railway dynamicznie przypisuje port przez ENV PORT
ENV PORT 10000

# Uruchomienie Podsync – tylko konfiguracja, port bierze z ENV
CMD ["podsync", "-c", "/podsync/config.toml"]
