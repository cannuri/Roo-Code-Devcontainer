#!/bin/bash
# Don't exit on error - we want to complete setup even if some steps fail
set +e

echo "🚀 Setting up Roo Code development environment..."

# Source common functions
source /workspace/.devcontainer/library-scripts/common-debian.sh

# Install dos2unix for handling Windows line endings
sudo apt-get update && sudo apt-get install -y dos2unix

# Fix line endings for all shell scripts
fix_line_endings

# Skip Homebrew installation on ARM64 Linux (not well supported)
if [[ "$(uname -m)" == "aarch64" ]] && [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "⚠️  Skipping Homebrew installation on ARM64 Linux (limited support)"
    echo "📦 Installing packages via apt instead..."
    
    # Install git (should already be installed)
    if ! command -v git &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y git
    fi
    
    # Install GitHub CLI
    if ! command -v gh &> /dev/null; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
        sudo apt install -y gh
    fi
else
    # Install Homebrew on other platforms
    if ! command -v brew &> /dev/null; then
        echo "📦 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        else
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi
    
    # Install brew packages
    echo "📦 Installing brew packages..."
    brew install git gh
fi

# Install uv for Python package management
echo "🐍 Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
# uv installer puts binaries in .local/bin, not .cargo/env
export PATH="$HOME/.local/bin:$PATH"

# Clone Roo-Code repository if not already present
if [ ! -d "/workspace/Roo-Code" ]; then
    echo "📂 Cloning Roo-Code repository..."
    if ! git clone https://github.com/RooCodeInc/Roo-Code.git /workspace/Roo-Code 2>/dev/null; then
        echo "⚠️  Could not clone Roo-Code repository. It may be private or not exist yet."
        echo "   Please clone it manually after the container starts."
    fi
fi

# Clone Roo-Docs repository
if [ ! -d "/workspace/Roo-Docs" ]; then
    echo "📂 Cloning Roo-Docs repository..."
    if ! git clone https://github.com/RooCodeInc/Roo-Docs.git /workspace/Roo-Docs 2>/dev/null; then
        echo "⚠️  Could not clone Roo-Docs repository. It may be private or not exist yet."
        echo "   Please clone it manually after the container starts."
    fi
fi

# Setup Roo-Code if it exists
if [ -d "/workspace/Roo-Code" ]; then
    cd /workspace/Roo-Code
    
    # Check if package.json exists
    if [ -f "package.json" ]; then
        echo "📦 Installing dependencies..."
        if command -v pnpm &> /dev/null; then
            pnpm install || echo "⚠️  Failed to install dependencies"
        else
            echo "⚠️  pnpm not found, skipping dependency installation"
        fi
        
        # Only try to build if install succeeded and build script exists
        if [ -f "package.json" ] && grep -q '"build"' package.json; then
            echo "🔨 Building project..."
            pnpm build || echo "⚠️  Build failed, but continuing setup"
        fi
    else
        echo "⚠️  No package.json found in Roo-Code repository"
    fi
else
    echo "⚠️  Roo-Code directory not found, skipping build step"
fi

# Create launch.json for debugging
mkdir -p /workspace/.vscode
cat > /workspace/.vscode/launch.json << 'EOF'
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Run Extension",
      "type": "extensionHost",
      "request": "launch",
      "runtimeExecutable": "${execPath}",
      "args": [
        "--extensionDevelopmentPath=${workspaceFolder}/Roo-Code"
      ],
      "outFiles": [
        "${workspaceFolder}/Roo-Code/out/**/*.js"
      ],
      "preLaunchTask": "npm: build"
    },
    {
      "name": "Extension Tests",
      "type": "extensionHost",
      "request": "launch",
      "runtimeExecutable": "${execPath}",
      "args": [
        "--extensionDevelopmentPath=${workspaceFolder}/Roo-Code",
        "--extensionTestsPath=${workspaceFolder}/Roo-Code/out/test/suite/index"
      ],
      "outFiles": [
        "${workspaceFolder}/Roo-Code/out/test/**/*.js"
      ],
      "preLaunchTask": "npm: build"
    }
  ]
}
EOF

# Create tasks.json
cat > /workspace/.vscode/tasks.json << 'EOF'
{
  "version": "2.0.0",
  "tasks": [
    {
      "type": "npm",
      "script": "build",
      "path": "Roo-Code",
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "problemMatcher": "$tsc",
      "label": "npm: build",
      "detail": "Build Roo-Code"
    },
    {
      "type": "npm",
      "script": "dev",
      "path": "Roo-Code",
      "isBackground": true,
      "problemMatcher": {
        "pattern": {
          "regexp": "^([^:]+):(\\d+):(\\d+):\\s+(error|warning):\\s+(.+)$",
          "file": 1,
          "line": 2,
          "column": 3,
          "severity": 4,
          "message": 5
        },
        "background": {
          "activeOnStart": true,
          "beginsPattern": "^.*Starting compilation.*$",
          "endsPattern": "^.*Watching for file changes.*$"
        }
      },
      "label": "npm: dev",
      "detail": "Start development server"
    }
  ]
}
EOF


echo "✅ Development environment setup complete!"
echo ""
echo "📝 Next steps:"
if [ -d "/workspace/Roo-Code" ]; then
    echo "   1. Open a terminal and run: cd /workspace/Roo-Code && pnpm dev"
    echo "   2. Press F5 to launch the extension in a new VSCode window"
else
    echo "   1. Clone your Roo-Code repository to /workspace/Roo-Code"
    echo "   2. Run: cd /workspace/Roo-Code && pnpm install"
    echo "   3. Run: pnpm dev to start development"
fi
echo ""
echo "🛠️  Available tools:"
echo "   - Node.js $(node --version 2>/dev/null || echo 'not found')"
echo "   - pnpm $(pnpm --version 2>/dev/null || echo 'not found')"
echo "   - Python $(python3 --version 2>/dev/null || echo 'not found')"
echo "   - uv $(uv --version 2>/dev/null || echo 'not found')"

# Exit successfully
exit 0