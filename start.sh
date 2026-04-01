#!/bin/bash

# Skrypt do uruchamiania Podsync w Dockerze

# Katalog projektu (aktualny katalog)
PROJECT_DIR=$(pwd)

# Budowanie obrazu Dockera
docker build -t podsync-example "$PROJECT_DIR"

# Tworzenie katalogów, jeśli nie istnieją
mkdir -p "$PROJECT_DIR/media"
mkdir -p "$PROJECT_DIR/data"

# Uruchomienie kontenera
docker run -d \
  -v "$PROJECT_DIR/media:/podsync/media" \
  -v "$PROJECT_DIR/data:/podsync/data" \
  --name podsync \
  podsync-example

# Pokazanie logów na żywo
docker logs -f podsync
