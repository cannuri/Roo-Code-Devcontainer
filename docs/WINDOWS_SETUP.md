# Windows Setup Guide for Roo Code DevContainer

## Prerequisites

### 1. Enable WSL2
WSL2 is required for Docker Desktop on Windows. If you haven't already enabled it:

1. Open PowerShell as Administrator and run:
   ```powershell
   wsl --install
   ```

2. Restart your computer when prompted

3. After restart, open PowerShell and set WSL2 as default:
   ```powershell
   wsl --set-default-version 2
   ```

### 2. Install Docker Desktop

1. Download [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
2. During installation, ensure "Use WSL 2 instead of Hyper-V" is selected
3. After installation, start Docker Desktop
4. Go to Settings → General and verify "Use the WSL 2 based engine" is checked

### 3. Configure Git for Windows

Install Git with proper line ending handling:

1. Download [Git for Windows](https://git-scm.com/download/win)
2. During installation, select:
   - "Checkout as-is, commit Unix-style line endings"
   - "Use Windows' default console window" or "Use MinTTY"

3. Configure Git globally:
   ```powershell
   git config --global core.autocrlf input
   git config --global core.eol lf
   ```

### 4. Install VSCode

1. Download [Visual Studio Code](https://code.visualstudio.com/)
2. Install the following extensions:
   - Dev Containers (ms-vscode-remote.remote-containers)
   - WSL (ms-vscode-remote.remote-wsl)

## Initial Setup for WSL2

Before using the devcontainer, run the WSL2 host setup script:

1. Open WSL2 terminal:
   ```powershell
   wsl
   ```

2. Navigate to the project and run the setup script:
   ```bash
   cd ~/Roo-Code-Devcontainer
   ./scripts/setup-wsl2-host.sh
   ```

This script will:
- Configure file watcher limits for better performance
- Set up Git for cross-platform development
- Verify Docker configuration

## Using the DevContainer

### Option 1: From Windows File System

1. Clone the repository in PowerShell:
   ```powershell
   git clone https://github.com/cannuri/Roo-Code-Devcontainer.git
   cd Roo-Code-Devcontainer
   ```

2. Open in VSCode:
   ```powershell
   code .
   ```

3. When prompted, click "Reopen in Container"

### Option 2: From WSL2 (Recommended for Performance)

1. Open WSL2 terminal:
   ```powershell
   wsl
   ```

2. Clone in WSL2 filesystem:
   ```bash
   cd ~
   git clone https://github.com/cannuri/Roo-Code-Devcontainer.git
   cd Roo-Code-Devcontainer
   ```

3. Open in VSCode from WSL2:
   ```bash
   code .
   ```

## Troubleshooting

### "sysctl: permission denied" Error

If you see this error during container initialization:
```
sysctl: permission denied on key "fs.inotify.max_user_watches"
```

This means the WSL2 host setup hasn't been run. The fix:

1. Exit the container
2. In WSL2 terminal, run:
   ```bash
   cd ~/Roo-Code-Devcontainer
   ./scripts/setup-wsl2-host.sh
   ```
3. Restart VS Code and reopen in container

### Slow Performance

If the container is slow, ensure your files are in the WSL2 filesystem:
- Bad: `/mnt/c/Users/YourName/Projects/` (Windows filesystem)
- Good: `/home/yourname/projects/` (WSL2 filesystem)

### Line Ending Issues

If you see errors about line endings:

1. In the devcontainer, run:
   ```bash
   find . -type f -name "*.sh" -exec dos2unix {} \;
   ```

2. Or configure your editor to use LF line endings

### Docker Not Starting

1. Ensure virtualization is enabled in BIOS
2. Check Windows Features:
   - Windows Subsystem for Linux
   - Virtual Machine Platform
   - Both should be enabled

3. Run in PowerShell as Admin:
   ```powershell
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   ```

### Permission Issues

If you encounter permission issues:

1. Ensure Docker Desktop is running
2. In Docker Desktop Settings → Resources → WSL Integration:
   - Enable integration with your default WSL2 distro

## Performance Tips

1. **Use WSL2 filesystem**: Clone and work within WSL2 for best performance
2. **Allocate resources**: Docker Desktop → Settings → Resources
   - CPUs: At least 4
   - Memory: At least 8GB
   - Swap: 2GB
3. **Exclude from Windows Defender**: Add WSL2 directories to exclusions

## Terminal Options

Inside the devcontainer, you have multiple shell options:
- **bash**: Default shell
- **zsh**: Installed with Oh My Zsh
- **PowerShell Core**: Available via `pwsh` if needed

To change your default shell:
```bash
chsh -s /bin/zsh
```

## Common Windows-Specific Issues

### "Docker Desktop - WSL 2 backend required"
- Ensure WSL2 is installed: `wsl --install`
- Set WSL2 as default: `wsl --set-default-version 2`
- Restart Docker Desktop

### Scripts fail with "command not found"
This is usually a line ending issue:
1. In the devcontainer terminal: `dos2unix .devcontainer/*.sh`
2. Ensure Git is configured: `git config --global core.autocrlf input`

### Container is very slow
- Move your project to WSL2 filesystem for 10x performance boost
- Avoid working in `/mnt/c/` paths
- Use `\\wsl$\Ubuntu\home\username\` to access WSL files from Windows

### "Failed to connect to the Docker daemon"
1. Ensure Docker Desktop is running
2. In Docker Desktop → Settings → General:
   - Enable "Use the WSL 2 based engine"
3. In Settings → Resources → WSL Integration:
   - Enable your WSL2 distro

### VSCode can't find the devcontainer
- Install the Dev Containers extension
- If using WSL2, open VSCode from within WSL: `wsl` then `code .`

## Quick Commands Reference

```powershell
# Check WSL version
wsl --list --verbose

# Update WSL
wsl --update

# Set default WSL version
wsl --set-default-version 2

# Install Ubuntu in WSL
wsl --install -d Ubuntu

# Access WSL filesystem from Windows
explorer.exe \\wsl$\Ubuntu\home\

# Open current directory in Windows Explorer from WSL
explorer.exe .
```