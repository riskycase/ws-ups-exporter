# Stage 1: Build dependencies
FROM python:alpine as builder

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
    i2c-tools

# Create i2c group and user
RUN addgroup --system --gid 112 i2c && \
    adduser --system --ingroup i2c worker

WORKDIR /home/worker

# Copy wheels from builder
COPY --from=builder /build/wheels /wheels
RUN pip install --no-cache /wheels/*

# Copy application code
COPY *py /home/worker/

# Set proper ownership
RUN chown -R worker:i2c /home/worker

# Switch to non-root user
USER worker

# Container configuration
EXPOSE 8000
ENTRYPOINT ["python3", "/home/worker/exporter.py"]