#!/bin/sh
set -e

# Add worker to the group that owns /dev/i2c-1
usermod -a -G $(stat -c '%g' /dev/i2c-1) worker

# Switch to worker user and run the application
exec su -s /bin/sh worker -c "python3 /home/worker/exporter.py"