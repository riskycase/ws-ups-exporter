#!/bin/sh
set -e

I2C_GID=$(stat -c '%g' /dev/i2c-1)

# Create group only if it doesn't exist
if ! getent group $I2C_GID > /dev/null; then
    addgroup -g $I2C_GID i2c_device
fi

# Add user to group
usermod -a -G i2c_device worker

exec su -s /bin/sh worker -c "python3 /home/worker/exporter.py"