# Quick start script for Windows users
# This script helps Windows users get started with the Roo Code DevContainer

param(
    [switch]$SkipChecks,
    [switch]$UseWSL
)

Write-Host "🚀 Roo Code DevContainer Quick Start for Windows" -ForegroundColor Cyan
Write-Host ""

# Run environment check unless skipped
if (-not $SkipChecks) {
    Write-Host "Running environment check..." -ForegroundColor Yellow
    & "$PSScriptRoot\check-windows-setup.ps1"
    
    Write-Host "`nContinue with setup? (Y/N): " -NoNewline -ForegroundColor Yellow
    $continue = Read-Host
    if ($continue -ne 'Y' -and $continue -ne 'y') {
        Write-Host "Setup cancelled." -ForegroundColor Red
        exit 1
    }
}

# Clone or update repository
$repoPath = if ($UseWSL) {
    "\\wsl$\Ubuntu\home\$env:USERNAME\roo-code-devcontainer"
} else {
    "$env:USERPROFILE\Projects\roo-code-devcontainer"
}

if ($UseWSL) {
    Write-Host "`nSetting up in WSL2..." -ForegroundColor Yellow
    
    # Ensure WSL directory exists
    wsl -e bash -c "mkdir -p ~/Projects"
    
    # Clone or pull in WSL
    $cloneCmd = @"
cd ~/Projects
if [ -d 'roo-code-devcontainer' ]; then
    cd roo-code-devcontainer
    git pull
else
    git clone https://github.com/cannuri/Roo-Code-Devcontainer.git roo-code-devcontainer
    cd roo-code-devcontainer
fi
pwd
"@
    
    $projectPath = wsl -e bash -c $cloneCmd
    Write-Host "✅ Repository ready at: $projectPath" -ForegroundColor Green
    
    # Open in VSCode from WSL
    Write-Host "`nOpening in VSCode..." -ForegroundColor Yellow
    wsl -e bash -c "cd ~/Projects/roo-code-devcontainer && code ."
    
} else {
    Write-Host "`nSetting up in Windows filesystem..." -ForegroundColor Yellow
    
    # Ensure directory exists
    if (-not (Test-Path "$env:USERPROFILE\Projects")) {
        New-Item -ItemType Directory -Path "$env:USERPROFILE\Projects" | Out-Null
    }
    
    Set-Location "$env:USERPROFILE\Projects"
    
    # Clone or pull
    if (Test-Path "roo-code-devcontainer") {
        Set-Location "roo-code-devcontainer"
        git pull
    } else {
        git clone https://github.com/cannuri/Roo-Code-Devcontainer.git roo-code-devcontainer
        Set-Location "roo-code-devcontainer"
    }
    
    Write-Host "✅ Repository ready at: $(Get-Location)" -ForegroundColor Green
    
    # Open in VSCode
    Write-Host "`nOpening in VSCode..." -ForegroundColor Yellow
    code .
}

Write-Host "`n✅ Setup complete!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "1. VSCode will open automatically" -ForegroundColor White
Write-Host "2. Click 'Reopen in Container' when prompted" -ForegroundColor White
Write-Host "3. Wait for the container to build (first time: ~5-10 minutes)" -ForegroundColor White
Write-Host "4. Start developing! The dev server starts automatically." -ForegroundColor White
Write-Host "`nFor better performance, use -UseWSL flag next time!" -ForegroundColor Yellow