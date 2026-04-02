FROM ghcr.io/mxpv/podsync:latest

WORKDIR /app

COPY . .

RUN echo "========== CONFIG ==========" && cat config.toml && echo "============================"

ENV PODSYNC_CONFIG=/app/config.toml
