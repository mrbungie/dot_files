# PowerShell aliases for Windows
# These are the PowerShell equivalents of the bash/zsh aliases

# Navigation
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
function ..... { Set-Location ..\..\..\.. }
function ~ { Set-Location $HOME }

# List directory contents
function ll { Get-ChildItem -Force }
function la { Get-ChildItem -Force }
function l { Get-ChildItem }

# Git shortcuts
function g { git $args }
function ga { git add $args }
function gc { git commit $args }
function gco { git checkout $args }
function gd { git diff $args }
function gs { git status $args }
function gl { git log $args }
function gp { git push $args }
function gpl { git pull $args }
function gb { git branch $args }

# Directory shortcuts
function dl { Set-Location "$HOME\Downloads" }
function dt { Set-Location "$HOME\Desktop" }
function doc { Set-Location "$HOME\Documents" }
function dev { Set-Location "$HOME\Development" }

# System
function h { Get-History }
function j { Get-Job }
function p { Get-Process $args }

# Network
function ip { (Invoke-WebRequest -Uri "https://api.ipify.org").Content }
function localip { Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -like "*Ethernet*" -or $_.InterfaceAlias -like "*Wi-Fi*" } | Select-Object IPAddress }
function ping5 { ping -n 5 $args }

# Utility
function c { Clear-Host }
function path { $env:Path -split ';' }
function now { Get-Date -Format "HH:mm:ss" }
function today { Get-Date -Format "dd-MM-yyyy" }

# Editor
function e { if ($env:EDITOR) { & $env:EDITOR $args } else { notepad $args } }

# Docker
function d { docker $args }
function dc { docker-compose $args }
function dps { docker ps $args }
function di { docker images $args }

# Kubernetes
function k { kubectl $args }
function kgp { kubectl get pods $args }
function kgs { kubectl get services $args }
function kgd { kubectl get deployments $args }

# Python
function py { python $args }
function py3 { python3 $args }
function pip { pip3 $args }
function ve { python -m venv venv }
function va { .\venv\Scripts\Activate.ps1 }

# Node.js
function n { npm $args }
function nr { npm run $args }
function ni { npm install $args }
function nid { npm install --save-dev $args }
function nig { npm install -g $args }
function ns { npm start }
function nt { npm test }

# Reload PowerShell profile
function reload { & $PROFILE }

# Shortcuts for dotfiles
function dotfiles { Set-Location "$HOME\.dotfiles" }
function dotconfig { Set-Location "$HOME\.dotfiles\config" } 