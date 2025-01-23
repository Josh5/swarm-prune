#!/usr/bin/env bash
###
# File: cleanup.sh
# Project: swarm-prune
# File Created: Thursday, 23rd January 2025 4:54:50 pm
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Thursday, 23rd January 2025 5:36:46 pm
# Modified By: Josh.5 (jsunnex@gmail.com)
###

set -eu

print_log() {
    timestamp=$(date +'%Y/%m/%d %H:%M:%S')
    level="$1"
    shift
    message="$*"
    echo "[${timestamp}] [ ${level}] ${message}"
}

print_log "INFO" "Checking current disk usage..."
df -h /
current_percent=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
print_log "INFO" "Root path disk usage: ${current_percent:?}%"

print_log "INFO" "Starting cleanup process..."

# Clean up containers
print_log "INFO" "  > Running container prune..."
if docker container prune --force; then
    print_log "INFO" "    [SUCCESS] Container prune completed successfully."
else
    print_log "ERROR" "    [FAILURE] Failed to prune containers."
fi

# Clean up images
FILTER_IMAGE=${FILTER_IMAGE:-}
print_log "INFO" "  > Running image prune..."
if [ -n "$FILTER_IMAGE" ]; then
    print_log "INFO" "    Using filter: '${FILTER_IMAGE}'"
    if docker image prune --all --force --filter "$FILTER_IMAGE"; then
        print_log "INFO" "    [SUCCESS] Image prune with filter completed successfully."
    else
        print_log "ERROR" "    [FAILURE] Failed to prune images with filter."
    fi
else
    if docker image prune --all --force; then
        print_log "INFO" "    [SUCCESS] Image prune without filters completed successfully."
    else
        print_log "ERROR" "    [FAILURE] Failed to prune images without filters."
    fi
fi

# Clean up builder cache
FILTER_BUILD_CACHE=${FILTER_BUILD_CACHE:-}
print_log "INFO" "  > Running builder cache prune..."
if [ -n "$FILTER_BUILD_CACHE" ]; then
    print_log "INFO" "    Using filter: '${FILTER_BUILD_CACHE}'"
    if docker builder prune --all --force --filter "$FILTER_BUILD_CACHE"; then
        print_log "INFO" "    [SUCCESS] Builder cache prune with filter completed successfully."
    else
        print_log "ERROR" "    [FAILURE] Failed to prune builder cache with filter."
    fi
else
    if docker builder prune --all --force; then
        print_log "INFO" "    [SUCCESS] Builder cache prune without filters completed successfully."
    else
        print_log "ERROR" "    [FAILURE] Failed to prune builder cache without filters."
    fi
fi

print_log "INFO" "Cleanup process completed."

# Recheck disk usage
print_log "INFO" "Rechecking disk usage after cleanup..."
df -h /
current_percent=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
print_log "INFO" "Root path disk usage after cleanup: ${current_percent:?}%"
