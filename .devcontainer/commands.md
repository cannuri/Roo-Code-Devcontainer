# Useful Commands for Roo Code Development

## Installing Roo Code Extension in Container

If the Roo Code extension is not installed automatically, you can install it manually:

```bash
# First, make sure the extension is built
cd /workspace/Roo-Code
pnpm build

# Then install it in the container
bash /workspace/.devcontainer/install-roo-code-extension.sh
```

## Development Commands

```bash
# Start development mode
cd /workspace/Roo-Code && pnpm dev

# Run tests
pnpm test

# Build the extension
pnpm build

# Package the extension
pnpm package
```

## Git Commands

If you're seeing "too many active changes", you may want to:

```bash
# Check git status
git status

# Add all changes
git add .

# Commit changes
git commit -m "Your commit message"

# Or stash changes temporarily
git stash
```