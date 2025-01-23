#!/usr/bin/env bash
###
# File: entrypoint.sh
# Project: swarm-prune
# File Created: Thursday, 23rd January 2025 4:59:33 pm
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Thursday, 23rd January 2025 5:24:14 pm
# Modified By: Josh.5 (jsunnex@gmail.com)
###
set -eu

# Set default values if environment variables are not set
CRON_SCHEDULE="${CRON_SCHEDULE:-0 3 * * 0}" # Default: Sunday at 3 AM
FILTER_IMAGE="${FILTER_IMAGE:-label!=keep}"
FILTER_BUILD_CACHE="${FILTER_BUILD_CACHE:-label!=keep}"

# Write the cron job with the provided schedule
echo "$CRON_SCHEDULE /usr/local/bin/cleanup.sh >> /proc/1/fd/1 2>> /proc/1/fd/2" > /etc/crontabs/root

# Ensure the cleanup script can read the filters from the environment
export FILTER_IMAGE
export FILTER_BUILD_CACHE

# Start cron in the foreground
echo "Starting cron with schedule: $CRON_SCHEDULE"
crond -f -d 8
