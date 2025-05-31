# macOS Setup Guide for Roo Code Devcontainer

This guide provides specific instructions for running the Roo Code devcontainer on macOS.

## Prerequisites

1. **Docker Desktop for Mac**
   - Download and install from [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   - Ensure Docker Desktop is running (you should see the whale icon in your menu bar)
   - Allocate sufficient resources:
     - Open Docker Desktop → Settings → Resources
     - CPUs: At least 4
     - Memory: At least 8 GB
     - Swap: At least 2 GB
     - Disk image size: At least 60 GB

2. **Visual Studio Code**
   - Download and install from [VS Code](https://code.visualstudio.com/)
   - Install the "Dev Containers" extension (ms-vscode-remote.remote-containers)

3. **Command Line Tools**
   - Ensure you have Git installed: `git --version`
   - If not, install Xcode Command Line Tools: `xcode-select --install`

## Setup Instructions

### 1. Enable VS Code CLI (if needed)

If the `code` command isn't available in your terminal:
1. Open VS Code
2. Press `Cmd+Shift+P` to open Command Palette
3. Type and run: "Shell Command: Install 'code' command in PATH"
4. Restart your terminal

### 2. Clone and Setup

```bash
# Clone the repository
git clone https://github.com/cannuri/Roo-Code-Devcontainer.git
cd Roo-Code-Devcontainer

# Run the macOS setup script
./scripts/setup-macos.sh
```

### 3. Open in Devcontainer

You have two options:

**Option A: Via VS Code UI**
1. Open VS Code
2. File → Open Folder → Select the Roo-Code-Devcontainer folder
3. When prompted "Folder contains a Dev Container configuration", click "Reopen in Container"

**Option B: Via Command Line**
```bash
# From the Roo-Code-Devcontainer directory
code .
```
Then click "Reopen in Container" when prompted.

## Troubleshooting

### "No installation of Code oss was found" Error

This error occurs when using the Roo Code CLI directly. Instead:
1. Use the setup script provided: `./scripts/setup-macos.sh`
2. Or manually set the VS Code path: 
   ```bash
   export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
   ```

### Docker Build Errors (GPG Signature)

If you encounter GPG signature errors during build:
1. Clear Docker's build cache: `docker builder prune -f`
2. Remove all containers: `docker container prune -f`
3. Restart Docker Desktop
4. Try building again

### Performance Issues

macOS file system performance can be slower with Docker. The devcontainer is configured with:
- `consistency=cached` mount option for better performance
- Consider keeping heavy node_modules inside the container

### "Command not found" Errors

If commands like `pnpm` aren't found:
1. Ensure you're running commands inside the container, not on your host
2. Check the VS Code terminal shows "node ➜ /workspace"
3. Try rebuilding the container: Command Palette → "Dev Containers: Rebuild Container"

## Additional Notes

- The devcontainer will clone the Roo-Code repository inside the container
- All development should be done within the container for consistency
- Port 3000, 3001, 5173, and 8080 are automatically forwarded
- The container uses Zsh with Oh My Zsh pre-configured