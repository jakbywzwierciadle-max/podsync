# Use minimal base image
FROM alpine:3.19

# Install required packages
RUN apk add --no-cache ca-certificates tzdata

# Set working directory
WORKDIR /app

# Download latest Podsync binary
# (możesz przypiąć wersję jeśli chcesz stabilność)
ADD https://github.com/mxpv/podsync/releases/latest/download/podsync-linux-amd64 /app/podsync

# Make binary executable
RUN chmod +x /app/podsync

# Create directory for data
RUN mkdir -p /data

# Environment variables (override w Railway/Render)
ENV CONFIG_PATH=/data/config.toml

# Expose port (domyślny Podsync)
EXPOSE 8080

# Run Podsync
CMD ["/app/podsync"]
