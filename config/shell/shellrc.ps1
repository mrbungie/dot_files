# Common PowerShell settings
# These settings should work across Windows systems

# Set default editor
$env:EDITOR = "notepad"
$env:VISUAL = "notepad"

# Set PSReadLine options for better history
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineOption -MaximumHistoryCount 10000
}

# Set colorful prompt
function prompt {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal] $identity
    $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

    $prefix = ""
    if ($principal.IsInRole($adminRole)) {
        $prefix = "[ADMIN] "
        $host.UI.RawUI.WindowTitle = "Administrator: $($env:USERNAME)@$($env:COMPUTERNAME)"
    }
    
    $location = Get-Location
    $shortPath = $location.Path.Replace($HOME, "~")
    
    Write-Host "$prefix" -NoNewline -ForegroundColor Red
    Write-Host "$env:USERNAME@$env:COMPUTERNAME" -NoNewline -ForegroundColor Green
    Write-Host ":" -NoNewline
    Write-Host "$shortPath" -NoNewline -ForegroundColor Blue
    return "$ "
}

# Set PATH additions
$env:Path = "$HOME\.local\bin;$env:Path"
$env:Path = "$HOME\bin;$env:Path"

# Node.js version manager (nvm for Windows)
$nvmPath = "$env:APPDATA\nvm"
if (Test-Path $nvmPath) {
    $env:NVM_HOME = $nvmPath
    $env:NVM_SYMLINK = "$env:PROGRAMFILES\nodejs"
    $env:Path = "$env:NVM_HOME;$env:NVM_SYMLINK;$env:Path"
}

# Python environment
$pyenvPath = "$env:USERPROFILE\.pyenv"
if (Test-Path $pyenvPath) {
    $env:PYENV = $pyenvPath
    $env:Path = "$env:PYENV\bin;$env:PYENV\shims;$env:Path"
}

# Go language
$goPath = "$env:PROGRAMFILES\Go"
if (Test-Path $goPath) {
    $env:GOROOT = $goPath
    $env:GOPATH = "$env:USERPROFILE\go"
    $env:Path = "$env:GOROOT\bin;$env:GOPATH\bin;$env:Path"
}

# Rust language
$cargoPath = "$env:USERPROFILE\.cargo"
if (Test-Path $cargoPath) {
    $env:Path = "$cargoPath\bin;$env:Path"
}

# Java home
$javaPath = "$env:PROGRAMFILES\Java"
if (Test-Path $javaPath) {
    $latestJava = Get-ChildItem $javaPath | Where-Object { $_.Name -like "jdk*" } | Sort-Object -Property Name -Descending | Select-Object -First 1
    if ($latestJava) {
        $env:JAVA_HOME = $latestJava.FullName
        $env:Path = "$env:JAVA_HOME\bin;$env:Path"
    }
}

# Load custom functions
$functionsPath = "$HOME\.functions.ps1"
if (Test-Path $functionsPath) {
    . $functionsPath
}

# Load local settings that shouldn't be in git
$localRcPath = "$HOME\.localrc.ps1"
if (Test-Path $localRcPath) {
    . $localRcPath
}

# Set default starting directory
Set-Location $HOME 