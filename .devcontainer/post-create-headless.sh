#!/bin/bash
set -e

echo "🤖 Setting up Roo Code headless evaluation environment..."

# Install Homebrew silently
export NONINTERACTIVE=1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Configure Homebrew PATH
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install required packages
brew install git gh python@3.11

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.cargo/env

# Clone repositories
git clone https://github.com/RooCodeInc/Roo-Code.git /workspace/Roo-Code
git clone https://github.com/RooCodeInc/Roo-Docs.git /workspace/Roo-Docs

# Setup Roo-Code
cd /workspace/Roo-Code
pnpm install:all
pnpm build

# Create evaluation script
cat > /workspace/run-eval.sh << 'EOF'
#!/bin/bash
set -e

# Run evaluation tasks
echo "🧪 Running Roo Code evaluation suite..."

cd /workspace/Roo-Code

# Run tests
echo "📋 Running tests..."
pnpm test

# Run linting
echo "🔍 Running linters..."
pnpm lint

# Run type checking
echo "📝 Type checking..."
pnpm typecheck

# Additional evaluation commands can be added here
# For example:
# pnpm eval:performance
# pnpm eval:memory

echo "✅ Evaluation complete!"
EOF

chmod +x /workspace/run-eval.sh

echo "✅ Headless environment ready!"
echo "📝 Run evaluations with: /workspace/run-eval.sh"