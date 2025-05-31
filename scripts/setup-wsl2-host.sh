#!/bin/bash
# Setup script for WSL2 host (run this before starting the devcontainer)

echo "🔧 WSL2 Host Setup Script for Roo Code Devcontainer"
echo "=================================================="
echo ""

# Check if running in WSL2
if [[ -z "$WSL_DISTRO_NAME" ]] && ! grep -qi microsoft /proc/version 2>/dev/null; then
    echo "❌ This script should only be run on WSL2"
    exit 1
fi

echo "📝 This script will configure your WSL2 host for optimal devcontainer performance"
echo ""

# Configure file watcher limits
echo "1. Setting up file watcher limits..."
if grep -q "fs.inotify.max_user_watches" /etc/sysctl.conf; then
    echo "   ✓ File watcher limits already configured"
else
    echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf
    echo "   ✓ Added file watcher configuration"
fi

# Apply the settings
echo "2. Applying system settings..."
sudo sysctl -p

# Configure Docker if not already done
echo "3. Checking Docker configuration..."
if command -v docker &> /dev/null; then
    echo "   ✓ Docker is installed"
    
    # Ensure user is in docker group
    if groups | grep -q docker; then
        echo "   ✓ User is in docker group"
    else
        echo "   ! Adding user to docker group..."
        sudo usermod -aG docker $USER
        echo "   ✓ Added user to docker group (you may need to log out and back in)"
    fi
else
    echo "   ⚠️  Docker not found. Please install Docker Desktop for Windows"
fi

# Configure Git for Windows line endings
echo "4. Configuring Git..."
git config --global core.autocrlf input
git config --global core.eol lf
echo "   ✓ Git configured for cross-platform development"

echo ""
echo "✅ WSL2 host setup complete!"
echo ""
echo "Next steps:"
echo "1. If you were added to the docker group, log out and back in"
echo "2. Open VS Code and reopen in container"
echo ""