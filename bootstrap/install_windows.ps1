# Windows-specific bootstrapping script

# Get the dotfiles directory
$DOTFILES_DIR = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$PLATFORM_DIR = Join-Path -Path $DOTFILES_DIR -ChildPath "platform\windows"

# Print with color
function Write-ColorOutput {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$false)]
        [string]$ForegroundColor = "White"
    )
    
    Write-Host $Message -ForegroundColor $ForegroundColor
}

function Write-Info {
    param ([string]$Message)
    Write-ColorOutput -Message $Message -ForegroundColor "Cyan"
}

function Write-Success {
    param ([string]$Message)
    Write-ColorOutput -Message $Message -ForegroundColor "Green"
}

function Write-Error {
    param ([string]$Message)
    Write-ColorOutput -Message $Message -ForegroundColor "Red"
}

# Install Chocolatey if not already installed
function Install-Chocolatey {
    Write-Info "Checking for Chocolatey..."
    
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Info "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        Write-Success "Chocolatey installed successfully"
    } else {
        Write-Info "Chocolatey already installed"
    }
}

# Install packages from packages.config
function Install-Packages {
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Info "Installing packages with Chocolatey..."
        
        $packagesFile = Join-Path -Path $PLATFORM_DIR -ChildPath "packages.config"
        if (Test-Path $packagesFile) {
            choco install $packagesFile -y
            Write-Success "Packages installed successfully"
        } else {
            Write-Error "packages.config not found"
        }
    } else {
        Write-Error "Chocolatey not found, skipping package installation"
    }
}

# Set up PowerShell profile
function Setup-PowerShellProfile {
    Write-Info "Setting up PowerShell profile..."
    
    $profileFile = Join-Path -Path $PLATFORM_DIR -ChildPath "powershell_profile.ps1"
    if (Test-Path $profileFile) {
        # Create PowerShell profile directory if it doesn't exist
        if (-not (Test-Path (Split-Path -Parent $PROFILE))) {
            New-Item -ItemType Directory -Path (Split-Path -Parent $PROFILE) -Force | Out-Null
        }
        
        # Backup existing profile if it exists and is not a symlink
        if (Test-Path $PROFILE) {
            Copy-Item -Path $PROFILE -Destination "$PROFILE.backup" -Force
            Write-Info "Backed up existing PowerShell profile to $PROFILE.backup"
        }
        
        # Create symlink to profile
        if (Test-Path $profileFile) {
            # In Windows, we'll copy the file instead of creating a symlink
            Copy-Item -Path $profileFile -Destination $PROFILE -Force
            Write-Success "Copied PowerShell profile"
            
            # Add code to source common settings
            $shellrcPath = Join-Path -Path $DOTFILES_DIR -ChildPath "config\shell\shellrc.ps1"
            $aliasesPath = Join-Path -Path $DOTFILES_DIR -ChildPath "config\shell\aliases.ps1"
            
            # Add sourcing for shellrc.ps1 if it exists
            if (Test-Path $shellrcPath) {
                if (-not (Select-String -Path $PROFILE -Pattern "shellrc.ps1" -Quiet)) {
                    Add-Content -Path $PROFILE -Value "`nif (Test-Path `"$shellrcPath`") { . `"$shellrcPath`" }"
                    Write-Success "Added shellrc.ps1 sourcing to PowerShell profile"
                }
            }
            
            # Add sourcing for aliases.ps1 if it exists
            if (Test-Path $aliasesPath) {
                if (-not (Select-String -Path $PROFILE -Pattern "aliases.ps1" -Quiet)) {
                    Add-Content -Path $PROFILE -Value "`nif (Test-Path `"$aliasesPath`") { . `"$aliasesPath`" }"
                    Write-Success "Added aliases.ps1 sourcing to PowerShell profile"
                }
            }
        }
    } else {
        Write-Error "PowerShell profile template not found"
    }
}

# Main function
function Main {
    Write-Info "Starting Windows bootstrapping..."
    
    # Install Chocolatey
    Install-Chocolatey
    
    # Install packages
    Install-Packages
    
    # Set up PowerShell profile
    Setup-PowerShellProfile
    
    Write-Success "Windows bootstrapping complete!"
}

# Run the script
Main 