FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o podsync ./cmd/podsync

FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/podsync /usr/local/bin/podsync
COPY config.toml /app/config.toml
ENV PODSYNC_CONFIG=/app/config.toml
RUN mkdir -p /app/data
EXPOSE 8080
CMD ["podsync"]
