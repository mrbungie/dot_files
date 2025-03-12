# Windows dotfiles installer
# This script handles the installation of dotfiles on Windows systems

$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ConfigDir = Join-Path $DotfilesDir "config"
$PlatformDir = Join-Path $DotfilesDir "platform"

# Print functions with color
function Write-Info {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Red
}

function Show-Usage {
    Write-Host "Usage: .\install.ps1 [OPTIONS]"
    Write-Host "Options:"
    Write-Host "  -All         Install everything (default if no options provided)"
    Write-Host "  -Git        Install git configuration only"
    Write-Host "  -Aliases    Install shell aliases only"
    Write-Host "  -Shell      Install shell configuration only"
    Write-Host "  -Help       Show this help message"
}

function Install-DotFiles {
    param(
        [switch]$All,
        [switch]$Git,
        [switch]$Aliases,
        [switch]$Shell,
        [switch]$Help
    )

    if ($Help) {
        Show-Usage
        return
    }

    Write-Info "Starting Windows dotfiles installation..."

    # If no specific options are provided, install everything
    if (-not ($Git -or $Aliases -or $Shell)) {
        $All = $true
    }

    # Install Git configuration
    if ($All -or $Git) {
        $GitConfigSource = Join-Path $ConfigDir "git\gitconfig"
        if (Test-Path $GitConfigSource) {
            Copy-Item -Path $GitConfigSource -Destination "$env:USERPROFILE\.gitconfig" -Force
            Write-Success "Installed Git configuration"
        }
    }

    # Install PowerShell aliases
    if ($All -or $Aliases) {
        $AliasesSource = Join-Path $ConfigDir "shell\aliases"
        if (Test-Path $AliasesSource) {
            Copy-Item -Path $AliasesSource -Destination "$env:USERPROFILE\Documents\WindowsPowerShell\aliases.ps1" -Force
            Write-Success "Installed PowerShell aliases"
        }
    }

    # Install PowerShell profile
    if ($All -or $Shell) {
        $ShellrcSource = Join-Path $ConfigDir "shell\shellrc"
        if (Test-Path $ShellrcSource) {
            Copy-Item -Path $ShellrcSource -Destination "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Force
            Write-Success "Installed PowerShell profile"
        }
    }

    Write-Success "Dotfiles installation complete!"
}

# Parse command line arguments
$params = @{}
foreach ($arg in $args) {
    switch ($arg) {
        "--all" { $params["All"] = $true }
        "--git" { $params["Git"] = $true }
        "--aliases" { $params["Aliases"] = $true }
        "--shell" { $params["Shell"] = $true }
        "--help" { $params["Help"] = $true }
    }
}

# Run the installer with parsed parameters
Install-DotFiles @params 