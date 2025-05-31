#!/bin/bash
set -e

# Ensure git is configured
if [ -z "$(git config --global user.name)" ]; then
    echo "⚙️ Configuring git..."
    git config --global user.name "Developer"
    git config --global user.email "developer@roo-code.local"
fi

# Start pnpm dev in background if not already running
if ! pgrep -f "pnpm dev" > /dev/null; then
    echo "🚀 Starting development server..."
    cd /workspace/Roo-Code
    nohup pnpm dev > /tmp/pnpm-dev.log 2>&1 &
    echo "📝 Development server started. Check logs at /tmp/pnpm-dev.log"
fi

echo "✨ Roo Code devcontainer is ready!"