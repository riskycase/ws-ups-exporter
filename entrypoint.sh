#!/bin/sh
set -e

# Get the i2c group ID from the host mount
if [ ! -e /dev/i2c-1 ]; then
    echo "Error: /dev/i2c-1 device not found"
    exit 1
fi

I2C_GID=$(stat -c '%g' /dev/i2c-1)

# Create i2c group with the host's GID
groupadd -g $I2C_GID i2c || {
    echo "Error: Failed to create i2c group"
    exit 1
}

# Add worker user to i2c group
usermod -a -G i2c worker || {
    echo "Error: Failed to add worker to i2c group"
    exit 1
}

# Make sure the working directory has correct permissions
chown -R worker:worker /home/worker

# Switch to worker user and run the application
exec su -s /bin/sh worker -c "python3 /home/worker/exporter.py"