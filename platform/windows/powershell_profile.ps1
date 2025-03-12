# Windows PowerShell Profile

# Check if running as administrator
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal $user
    $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# Set window title
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal] $identity
$adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

if ($principal.IsInRole($adminRole)) {
    $host.UI.RawUI.WindowTitle = "Administrator: $($env:USERNAME)@$($env:COMPUTERNAME)"
} else {
    $host.UI.RawUI.WindowTitle = "$($env:USERNAME)@$($env:COMPUTERNAME)"
}

# Set PSReadLine options for better history
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineOption -MaximumHistoryCount 10000
    Set-PSReadLineOption -PredictionSource History
}

# Set colorful prompt
function prompt {
    $prefix = ""
    if (Test-Administrator) {
        $prefix = "[ADMIN] "
    }
    
    $location = Get-Location
    $shortPath = $location.Path.Replace($HOME, "~")
    
    Write-Host "$prefix" -NoNewline -ForegroundColor Red
    Write-Host "$env:USERNAME@$env:COMPUTERNAME" -NoNewline -ForegroundColor Green
    Write-Host ":" -NoNewline
    Write-Host "$shortPath" -NoNewline -ForegroundColor Blue
    return "$ "
}

# Source common PowerShell settings
$shellrcPath = Join-Path -Path $HOME -ChildPath ".shellrc.ps1"
if (Test-Path $shellrcPath) {
    . $shellrcPath
}

# Source aliases
$aliasesPath = Join-Path -Path $HOME -ChildPath ".aliases.ps1"
if (Test-Path $aliasesPath) {
    . $aliasesPath
}

# Windows-specific aliases and functions
function Open-Explorer { explorer.exe . }
Set-Alias -Name e. -Value Open-Explorer

function Get-PublicIP { (Invoke-WebRequest -Uri "https://api.ipify.org").Content }
Set-Alias -Name publicip -Value Get-PublicIP

function Start-AdminPowerShell {
    Start-Process powershell -Verb RunAs
}
Set-Alias -Name admin -Value Start-AdminPowerShell

function Get-DiskUsage {
    Get-WmiObject -Class Win32_LogicalDisk | 
    Where-Object { $_.DriveType -eq 3 } | 
    Select-Object DeviceID, 
        @{Name="Size(GB)";Expression={[math]::Round($_.Size/1GB,2)}}, 
        @{Name="FreeSpace(GB)";Expression={[math]::Round($_.FreeSpace/1GB,2)}}, 
        @{Name="% Free";Expression={[math]::Round(($_.FreeSpace/$_.Size)*100,2)}}
}
Set-Alias -Name df -Value Get-DiskUsage

function Get-ProcessByMemory {
    Get-Process | Sort-Object -Property WS -Descending | Select-Object -First 10 Name, @{Name="Memory (MB)";Expression={[math]::Round($_.WS / 1MB, 2)}}
}
Set-Alias -Name top -Value Get-ProcessByMemory

# Set up Chocolatey tab completion
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

# Set up posh-git if installed
$poshGitModule = Get-Module -ListAvailable -Name posh-git
if ($poshGitModule) {
    Import-Module posh-git
}

# Set up oh-my-posh if installed
$ohmyposhModule = Get-Module -ListAvailable -Name oh-my-posh
if ($ohmyposhModule) {
    Import-Module oh-my-posh
    Set-PoshPrompt -Theme paradox
}

# Set up Terminal-Icons if installed
$terminalIconsModule = Get-Module -ListAvailable -Name Terminal-Icons
if ($terminalIconsModule) {
    Import-Module Terminal-Icons
}

# Set up z directory jumper if installed
$zModule = Get-Module -ListAvailable -Name z
if ($zModule) {
    Import-Module z
}

# Set up environment variables for development tools
# Node.js
$nodePath = "$env:APPDATA\npm"
if (Test-Path $nodePath) {
    $env:Path = "$nodePath;$env:Path"
}

# Python
$pythonPath = "$env:LOCALAPPDATA\Programs\Python"
if (Test-Path $pythonPath) {
    $latestPython = Get-ChildItem $pythonPath | Where-Object { $_.Name -like "Python*" } | Sort-Object -Property Name -Descending | Select-Object -First 1
    if ($latestPython) {
        $env:Path = "$($latestPython.FullName);$($latestPython.FullName)\Scripts;$env:Path"
    }
}

# Go
$goPath = "$env:PROGRAMFILES\Go"
if (Test-Path $goPath) {
    $env:GOROOT = $goPath
    $env:GOPATH = "$env:USERPROFILE\go"
    $env:Path = "$env:GOROOT\bin;$env:GOPATH\bin;$env:Path"
}

# Java
$javaPath = "$env:PROGRAMFILES\Java"
if (Test-Path $javaPath) {
    $latestJava = Get-ChildItem $javaPath | Where-Object { $_.Name -like "jdk*" } | Sort-Object -Property Name -Descending | Select-Object -First 1
    if ($latestJava) {
        $env:JAVA_HOME = $latestJava.FullName
        $env:Path = "$env:JAVA_HOME\bin;$env:Path"
    }
}

# Load local settings that shouldn't be in git
$localRcPath = "$HOME\.localrc.ps1"
if (Test-Path $localRcPath) {
    . $localRcPath
} 