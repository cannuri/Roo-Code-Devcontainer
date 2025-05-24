#!/bin/bash
# Cross-platform initialization script

set -e

# Detect the host OS
detect_host_os() {
    if [[ -n "$WSL_DISTRO_NAME" ]] || grep -qi microsoft /proc/version 2>/dev/null; then
        echo "windows-wsl2"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

HOST_OS=$(detect_host_os)
echo "🖥️  Detected host OS: $HOST_OS"

# Platform-specific configurations
case "$HOST_OS" in
    "windows-wsl2")
        echo "🪟 Configuring for Windows/WSL2..."
        
        # Set Git to handle line endings properly
        git config --global core.autocrlf input
        git config --global core.eol lf
        
        # Create symbolic links for Windows users' common directories
        if [ -d "/mnt/c/Users" ]; then
            # Find the Windows username
            WIN_USER=$(cd /mnt/c/Users && ls -d */ | grep -v -E "^(Default|Public|All Users)/" | head -1 | tr -d '/')
            if [ -n "$WIN_USER" ]; then
                # Create convenient symlinks
                ln -sf "/mnt/c/Users/$WIN_USER/Downloads" ~/Downloads 2>/dev/null || true
                ln -sf "/mnt/c/Users/$WIN_USER/Documents" ~/Documents 2>/dev/null || true
            fi
        fi
        
        # Add WSL2-specific performance improvements
        echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf
        sudo sysctl -p
        ;;
        
    "macos")
        echo "🍎 Configuring for macOS..."
        # macOS-specific configurations if needed
        ;;
        
    "linux")
        echo "🐧 Configuring for Linux..."
        # Linux-specific configurations if needed
        ;;
esac

# Common configurations for all platforms
echo "⚙️  Applying common configurations..."

# Ensure proper permissions
chmod -R 755 /workspace/.devcontainer/*.sh 2>/dev/null || true

# Create a platform info file for reference
cat > /workspace/.devcontainer-platform-info << EOF
Host OS: $HOST_OS
Container OS: $(uname -s) $(uname -r)
Node Version: $(node --version)
npm Version: $(npm --version)
pnpm Version: $(pnpm --version)
Git Version: $(git --version)
Docker Client: $(docker --version 2>/dev/null || echo "Not available in container")
Date: $(date)
EOF

echo "✅ Cross-platform initialization complete!"