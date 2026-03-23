# Install script for wezterm-config (Windows PowerShell)
# Usage: irm https://raw.githubusercontent.com/bzwang-phys/wezterm-config/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

$Repo = "https://github.com/bzwang-phys/wezterm-config.git"
$ConfigDir = Join-Path $env:USERPROFILE ".config\wezterm"

Write-Host "==> Installing wezterm config to $ConfigDir"

# Check git is available
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Error: git is not installed."
    exit 1
}

# Backup existing config if it exists and is not this repo
if (Test-Path $ConfigDir) {
    if (Test-Path (Join-Path $ConfigDir ".git")) {
        $existingRemote = git -C $ConfigDir remote get-url origin 2>$null
        if ($existingRemote -eq $Repo) {
            Write-Host "==> Repo already cloned, pulling latest changes..."
            git -C $ConfigDir pull --rebase
            Write-Host "==> Done!"
            exit 0
        }
    }
    $timestamp = [int](Get-Date -UFormat %s)
    $backup = "${ConfigDir}.bak.${timestamp}"
    Write-Host "==> Existing config found, backing up to $backup"
    Move-Item $ConfigDir $backup
}

# Ensure parent directory exists
$parentDir = Split-Path $ConfigDir -Parent
if (-not (Test-Path $parentDir)) {
    New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
}

# Clone
Write-Host "==> Cloning $Repo..."
git clone $Repo $ConfigDir

Write-Host "==> Done! Restart wezterm to apply the new config."
