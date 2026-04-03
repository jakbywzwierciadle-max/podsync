FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata wget

WORKDIR /app

# Pobranie binarki w bardziej niezawodny sposób
RUN wget -O /app/podsync https://github.com/mxpv/podsync/releases/latest/download/podsync-linux-amd64

RUN chmod +x /app/podsync

RUN mkdir -p /data

ENV CONFIG_PATH=/data/config.toml

EXPOSE 8080

CMD ["/app/podsync"]
