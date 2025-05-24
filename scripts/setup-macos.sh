#!/bin/bash

# macOS-specific setup script for Roo Code devcontainer

echo "Setting up Roo Code devcontainer on macOS..."

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker Desktop for Mac first."
    echo "Visit: https://www.docker.com/products/docker-desktop/"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "Error: Docker daemon is not running. Please start Docker Desktop."
    exit 1
fi

# Check if VSCode CLI is installed
if ! command -v code &> /dev/null; then
    echo "VSCode CLI not found in PATH."
    
    # Common VSCode locations on macOS
    VSCODE_PATHS=(
        "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
        "/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code"
        "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
    )
    
    FOUND_CODE=false
    for path in "${VSCODE_PATHS[@]}"; do
        if [ -f "$path" ]; then
            echo "Found VSCode at: $path"
            echo "Adding to PATH..."
            export PATH="$(dirname "$path"):$PATH"
            FOUND_CODE=true
            break
        fi
    done
    
    if [ "$FOUND_CODE" = false ]; then
        echo "Could not find VSCode installation."
        echo "Please ensure VSCode is installed or add the 'code' command to your PATH manually."
        echo "You can do this by:"
        echo "1. Opening VSCode"
        echo "2. Opening Command Palette (Cmd+Shift+P)"
        echo "3. Running 'Shell Command: Install 'code' command in PATH'"
        exit 1
    fi
fi

# Install Dev Containers extension if not already installed
echo "Checking for Dev Containers extension..."
if ! code --list-extensions | grep -q "ms-vscode-remote.remote-containers"; then
    echo "Installing Dev Containers extension..."
    code --install-extension ms-vscode-remote.remote-containers
fi

# Fix common macOS Docker issues
echo "Configuring Docker for macOS..."

# Ensure Docker has enough resources
cat << EOF

Please ensure Docker Desktop has adequate resources allocated:
1. Open Docker Desktop
2. Go to Settings > Resources
3. Recommended settings:
   - CPUs: At least 4
   - Memory: At least 8 GB
   - Swap: At least 2 GB
   - Disk image size: At least 60 GB

Press Enter when you've verified these settings...
EOF
read -r

# Clean up any existing problematic containers
echo "Cleaning up any existing containers..."
docker container prune -f 2>/dev/null || true

# Reset Docker's package signing keys (helps with GPG errors)
echo "Resetting Docker build cache to avoid GPG errors..."
docker builder prune -f

echo "Setup complete! You can now open the devcontainer with:"
echo "code --folder-uri vscode-remote://dev-container+$(echo -n "$(pwd)" | xxd -p)/workspace"
echo ""
echo "Or simply:"
echo "1. Open this folder in VSCode"
echo "2. When prompted, click 'Reopen in Container'"