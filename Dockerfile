FROM golang:1.25-alpine AS builder

ARG TAG=""
ARG COMMIT=""
ARG DATE=""

WORKDIR /build

RUN apk add --no-cache git

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build \
    -trimpath \
    -tags netgo \
    -ldflags "-s -w -X 'main.version=${TAG}' -X 'main.commit=${COMMIT}' -X 'main.date=${DATE}'" \
    -o /build/podsync \
    ./cmd/podsync

FROM alpine:3.21

RUN apk add --no-cache \
    ca-certificates \
    ffmpeg \
    python3 \
    tzdata \
    wget \
    && wget -O /usr/local/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux \
    && chmod a+rx /usr/local/bin/yt-dlp \
    && ln -s /usr/local/bin/yt-dlp /usr/local/bin/youtube-dl

COPY --from=builder /build/podsync /usr/local/bin/podsync
COPY html/ /app/html/

WORKDIR /app

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/podsync"]
