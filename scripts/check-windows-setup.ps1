# Roo Code DevContainer - Windows Environment Checker
# Run this script in PowerShell to verify your Windows setup

Write-Host "🔍 Checking Windows environment for Roo Code DevContainer..." -ForegroundColor Cyan
Write-Host ""

$issues = @()
$warnings = @()

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    $warnings += "Not running as Administrator. Some checks may be limited."
}

# Check Windows version
Write-Host "Checking Windows version..." -ForegroundColor Yellow
$os = Get-CimInstance -ClassName Win32_OperatingSystem
$version = [Version]$os.Version
if ($version.Major -lt 10 -or ($version.Major -eq 10 -and $version.Build -lt 19041)) {
    $issues += "Windows version too old. WSL2 requires Windows 10 version 2004 or higher."
} else {
    Write-Host "✅ Windows version: $($os.Caption) Build $($os.BuildNumber)" -ForegroundColor Green
}

# Check WSL
Write-Host "`nChecking WSL installation..." -ForegroundColor Yellow
try {
    $wslVersion = wsl --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ WSL is installed" -ForegroundColor Green
        
        # Check WSL2
        $wslList = wsl --list --verbose 2>$null
        if ($wslList -match "VERSION\s+2") {
            Write-Host "✅ WSL2 is available" -ForegroundColor Green
        } else {
            $warnings += "WSL2 not detected. Run: wsl --set-default-version 2"
        }
    } else {
        $issues += "WSL not installed. Run: wsl --install"
    }
} catch {
    $issues += "WSL not installed. Run: wsl --install"
}

# Check Docker Desktop
Write-Host "`nChecking Docker Desktop..." -ForegroundColor Yellow
$dockerPath = Get-Command docker -ErrorAction SilentlyContinue
if ($dockerPath) {
    try {
        $dockerVersion = docker --version
        Write-Host "✅ Docker is installed: $dockerVersion" -ForegroundColor Green
        
        # Check if Docker is running
        docker ps 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Docker is running" -ForegroundColor Green
        } else {
            $issues += "Docker is not running. Please start Docker Desktop."
        }
    } catch {
        $issues += "Docker is installed but not accessible. Check Docker Desktop settings."
    }
} else {
    $issues += "Docker Desktop not installed. Download from: https://www.docker.com/products/docker-desktop/"
}

# Check Git
Write-Host "`nChecking Git installation..." -ForegroundColor Yellow
$gitPath = Get-Command git -ErrorAction SilentlyContinue
if ($gitPath) {
    $gitVersion = git --version
    Write-Host "✅ Git is installed: $gitVersion" -ForegroundColor Green
    
    # Check Git config
    $autocrlf = git config --get core.autocrlf
    if ($autocrlf -ne "input") {
        $warnings += "Git core.autocrlf should be 'input'. Run: git config --global core.autocrlf input"
    }
} else {
    $issues += "Git not installed. Download from: https://git-scm.com/download/win"
}

# Check VSCode
Write-Host "`nChecking VSCode installation..." -ForegroundColor Yellow
$codePath = Get-Command code -ErrorAction SilentlyContinue
if ($codePath) {
    Write-Host "✅ VSCode is installed" -ForegroundColor Green
    
    # Check for required extensions
    $extensions = code --list-extensions 2>$null
    if ($extensions -notcontains "ms-vscode-remote.remote-containers") {
        $warnings += "Dev Containers extension not installed. Install: ms-vscode-remote.remote-containers"
    }
    if ($extensions -notcontains "ms-vscode-remote.remote-wsl") {
        $warnings += "WSL extension not installed. Install: ms-vscode-remote.remote-wsl"
    }
} else {
    $issues += "VSCode not installed. Download from: https://code.visualstudio.com/"
}

# Check Hyper-V/Virtualization
Write-Host "`nChecking virtualization..." -ForegroundColor Yellow
$hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online -ErrorAction SilentlyContinue
$vm = Get-WindowsOptionalFeature -FeatureName VirtualMachinePlatform -Online -ErrorAction SilentlyContinue
$wsl = Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -ErrorAction SilentlyContinue

if ($vm.State -eq "Enabled") {
    Write-Host "✅ Virtual Machine Platform is enabled" -ForegroundColor Green
} else {
    $issues += "Virtual Machine Platform not enabled. Run as admin: dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart"
}

if ($wsl.State -eq "Enabled") {
    Write-Host "✅ Windows Subsystem for Linux is enabled" -ForegroundColor Green
} else {
    $issues += "WSL feature not enabled. Run as admin: dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart"
}

# Summary
Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "SUMMARY" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

if ($issues.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "`n✅ Your system is ready for Roo Code DevContainer!" -ForegroundColor Green
} else {
    if ($issues.Count -gt 0) {
        Write-Host "`n❌ ISSUES FOUND (must fix):" -ForegroundColor Red
        foreach ($issue in $issues) {
            Write-Host "  - $issue" -ForegroundColor Red
        }
    }
    
    if ($warnings.Count -gt 0) {
        Write-Host "`n⚠️  WARNINGS (recommended to fix):" -ForegroundColor Yellow
        foreach ($warning in $warnings) {
            Write-Host "  - $warning" -ForegroundColor Yellow
        }
    }
}

Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")