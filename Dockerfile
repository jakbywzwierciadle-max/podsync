FROM tdeutsch/podsync:latest

WORKDIR /app
COPY config.toml /app/config.toml
ENV PODSYNC_CONFIG=/app/config.toml
EXPOSE 8080
CMD ["podsync"]
