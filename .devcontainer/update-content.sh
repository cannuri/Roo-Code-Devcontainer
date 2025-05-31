#!/bin/bash
# This script runs when the container content is updated (e.g., after pulling new changes)

echo "📦 Updating dependencies..."

# Update dependencies if Roo-Code exists
if [ -d "/workspace/Roo-Code" ] && [ -f "/workspace/Roo-Code/package.json" ]; then
    cd /workspace/Roo-Code
    echo "Updating Roo-Code dependencies..."
    pnpm install || echo "⚠️  Failed to update dependencies"
fi

# Update tools
echo "🔧 Checking for tool updates..."
if command -v uv &> /dev/null; then
    uv self update || echo "uv is already up to date"
fi

echo "✅ Content update complete!"