FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata wget

WORKDIR /app

# poprawna nazwa pliku (z v2.x)
RUN wget -O podsync.tar.gz \
    https://github.com/mxpv/podsync/releases/latest/download/podsync_Linux_x86_64.tar.gz

RUN tar -xzf podsync.tar.gz && \
    mv podsync /app/podsync && \
    chmod +x /app/podsync && \
    rm podsync.tar.gz

RUN mkdir -p /data

ENV CONFIG_PATH=/data/config.toml

EXPOSE 8080

CMD ["./podsync"]
