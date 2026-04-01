# ===== BUILD =====
FROM golang:1.25 AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/mxpv/podsync.git .

WORKDIR /app/cmd/podsync

# statyczna binarka
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /app/podsync

# ===== RUNTIME =====
FROM alpine:3.19

WORKDIR /app

RUN apk add --no-cache ca-certificates ffmpeg tzdata

COPY --from=builder /app/podsync /app/podsync

EXPOSE 10000

# 🔥 dynamiczny config (zero problemów z plikami)
CMD ["/bin/sh", "-c", "\
echo 'Port = 10000' > /app/config.toml && \
echo 'DownloadPath = \"/tmp\"' >> /app/config.toml && \
echo '' >> /app/config.toml && \
echo '[Storage]' >> /app/config.toml && \
echo 'Type = \"memory\"' >> /app/config.toml && \
echo '' >> /app/config.toml && \
echo '[Feeds.feed1]' >> /app/config.toml && \
echo 'URL = \"https://www.youtube.com/channel/UCO6_hwMtQZ0SLElfDMaqJGQ\"' >> /app/config.toml && \
echo '===== CONFIG =====' && \
cat /app/config.toml && \
echo '==================' && \
/app/podsync --config /app/config.toml \
"]
