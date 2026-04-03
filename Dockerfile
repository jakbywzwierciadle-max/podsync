# --- BUILD STAGE ---
FROM golang:1.22-alpine AS builder

RUN apk add --no-cache git

WORKDIR /build

# clone repo
RUN git clone https://github.com/mxpv/podsync.git .

# build binary
RUN go build -o podsync

# --- RUNTIME STAGE ---
FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

# copy binary from builder
COPY --from=builder /build/podsync /app/podsync

RUN chmod +x /app/podsync

RUN mkdir -p /data

ENV CONFIG_PATH=/data/config.toml

EXPOSE 8080

CMD ["./podsync"]
