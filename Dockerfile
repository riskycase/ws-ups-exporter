# Stage 1: Build dependencies
FROM python:alpine AS builder

LABEL org.opencontainers.image.source=https://github.com/riskycase/ws-ups-exporter
LABEL org.opencontainers.image.description="Waveshare UPS HAT (D) Prometheus server"
LABEL org.opencontainers.image.licenses=GPL-3.0-only

# Install build dependencies
RUN apk add --no-cache \
    make \
    gcc \
    musl-dev \
    python3-dev \
    linux-headers \
    i2c-tools

# Create directory for build
WORKDIR /build

# Install Python dependencies
COPY requirements.txt .
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /build/wheels -r requirements.txt

# Stage 2: Runtime
FROM python:alpine

# Install only runtime dependencies
RUN apk add --no-cache \
    i2c-tools \
    shadow

# Create user without specific GID - we'll handle groups at runtime
RUN adduser --system worker

WORKDIR /home/worker

# Copy wheels from builder
COPY --from=builder /build/wheels /wheels
RUN pip install --no-cache /wheels/*

# Copy application code
COPY *py /home/worker/

# Set proper ownership
RUN chown -R worker /home/worker

# Create an entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8000

# Don't switch to worker user in Dockerfile
# Let the entrypoint handle it
ENTRYPOINT ["/entrypoint.sh"]

HEALTHCHECK --interval=30s --timeout=3s \
  CMD python3 -c "import smbus; smbus.SMBus(1)" || exit 1