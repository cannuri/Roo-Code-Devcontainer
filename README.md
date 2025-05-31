# Roo Code Development Container

This repository provides a VSCode devcontainer configuration for developing Roo Code with minimal setup across Linux, macOS, and Windows.

## Features

- Pre-configured TypeScript/Node.js development environment
- All recommended VSCode extensions pre-installed
- Automatic cloning and setup of Roo-Code and Roo-Docs repositories
- Homebrew package manager (cross-platform)
- Python with uv package manager
- GitHub CLI and Git configuration
- Prettier with project-specific configuration
- Debug configurations for extension development
- Automatic `pnpm dev` startup
- **Full Windows support via WSL2** with automated setup scripts
- Cross-platform shell compatibility (bash/zsh)
- Automatic line ending handling for Windows developers

## Prerequisites

### All Platforms
- Docker Desktop installed and running
- VSCode with the Dev Containers extension
- Git configured with GitHub access (for private repos)

### Windows Users
**Important**: Windows users need WSL2 for Docker Desktop. See our detailed [Windows Setup Guide](docs/WINDOWS_SETUP.md) for:
- WSL2 installation and configuration
- Docker Desktop setup for Windows
- Line ending configuration
- Performance optimization tips

### macOS Users
- Docker Desktop for Mac (Apple Silicon or Intel)
- Xcode Command Line Tools: `xcode-select --install`
- See our detailed [macOS Setup Guide](docs/MACOS_SETUP.md) for specific instructions

### Linux Users
- Docker Engine and Docker Compose
- Add your user to the docker group: `sudo usermod -aG docker $USER`

## Getting Started

### Quick Start for Windows Users

We provide PowerShell scripts to simplify setup:

```powershell
# Check your environment first
.\scripts\check-windows-setup.ps1

# Quick start (recommended: use WSL2 for better performance)
.\scripts\start-devcontainer-windows.ps1 -UseWSL
```

### Manual Setup (All Platforms)

1. Clone this repository:
   ```bash
   git clone https://github.com/cannuri/Roo-Code-Devcontainer.git
   cd Roo-Code-Devcontainer
   ```

2. **Windows/WSL2 Users Only**: Run the host setup script first:
   ```bash
   ./scripts/setup-wsl2-host.sh
   ```

3. Open in VSCode:
   ```bash
   code .
   ```

4. When prompted, click "Reopen in Container" or run the command:
   - `Dev Containers: Reopen in Container`

5. Wait for the container to build and post-create scripts to complete (first run may take 5-10 minutes)

## Container Structure

After setup, your workspace will contain:
```
/workspace/
├── Roo-Code/          # Main Roo Code repository
├── Roo-Docs/          # Documentation repository
└── .vscode/           # VSCode configurations
    ├── launch.json    # Debug configurations
    └── tasks.json     # Build tasks
```

## Development Workflow

### Running the Extension

1. The development server starts automatically (`pnpm dev`)
2. Press `F5` to launch a new VSCode window with the extension loaded
3. Use the Extension Host window to test your changes

### Building

```bash
cd /workspace/Roo-Code
pnpm build
```

### Running Tests

```bash
cd /workspace/Roo-Code
pnpm test
```

### Debugging

Two debug configurations are available:
- **Run Extension**: Launches the extension in a new VSCode window
- **Extension Tests**: Runs the test suite with debugging

## Installed Tools

### VSCode Extensions
- TypeScript language support
- ESLint
- Prettier
- Error Lens
- Test Runner
- GitHub Actions
- GitHub Pull Requests
- GitLens
- Docker

### Command Line Tools
- Node.js 20.x
- pnpm
- Python 3.11 with uv
- Homebrew
- Git
- GitHub CLI (`gh`)
- TypeScript
- VSCode Extension CLI (`vsce`)

## Customization

### Adding Extensions

Edit `.devcontainer/devcontainer.json` and add extension IDs to the `customizations.vscode.extensions` array.

### Adding System Packages

1. For apt packages: Edit `.devcontainer/Dockerfile`
2. For Homebrew packages: Edit `.devcontainer/post-create.sh`
3. For npm packages: Add to `post-create.sh` or the Dockerfile

### Changing Ports

Edit the `forwardPorts` array in `.devcontainer/devcontainer.json`.

## Troubleshooting

### Container Build Fails

1. Ensure Docker Desktop is running
2. Check Docker resource limits (recommend 4GB+ RAM)
3. Clear Docker cache: `docker system prune -a`

### Extensions Not Loading

1. Reload the VSCode window: `Developer: Reload Window`
2. Check the Extensions view for any errors
3. Manually install from the Extensions sidebar if needed

### Development Server Issues

Check the dev server logs:
```bash
cat /tmp/pnpm-dev.log
```

Restart the dev server:
```bash
cd /workspace/Roo-Code
pkill -f "pnpm dev"
pnpm dev
```

## Headless Operations

The container includes the VSCode CLI for headless operations:

```bash
code --help
```

This can be useful for automated testing and CI/CD pipelines.

## Contributing

To improve this devcontainer:

1. Fork this repository
2. Make your changes
3. Test thoroughly on Linux, macOS, and Windows
4. Submit a pull request

## License

This devcontainer configuration follows the same license as Roo Code.