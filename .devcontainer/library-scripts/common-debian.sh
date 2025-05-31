#!/usr/bin/env bash
# Common setup script that works across platforms

set -e

# Detect if running on Windows through WSL2
if grep -qi microsoft /proc/version 2>/dev/null; then
    export RUNNING_IN_WSL=true
    echo "🪟 Detected WSL2 environment"
fi

# Function to handle line endings
fix_line_endings() {
    if [ "$RUNNING_IN_WSL" = true ]; then
        # Convert CRLF to LF for scripts
        find /workspace -name "*.sh" -type f -exec dos2unix {} \; 2>/dev/null || true
    fi
}

# Export functions for use in other scripts
export -f fix_line_endings