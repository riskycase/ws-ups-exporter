#!/bin/sh

# Get the i2c group ID from the host mount
I2C_GID=$(stat -c '%g' /dev/i2c-1)

# Create i2c group with the host's GID
addgroup --system --gid $I2C_GID i2c

# Add worker user to i2c group
adduser worker i2c

# Switch to worker user and run the application
exec su worker -c "python3 /home/worker/exporter.py"