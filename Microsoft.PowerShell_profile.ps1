oh-my-posh --init --shell pwsh --config ~\dev\dotfiles\atomic.omp.json | Invoke-Expression

Import-Module -Name Terminal-Icons

function up1 { set-location ".." }
New-Alias -Name .. up1
function up2 { set-location "../.." }
New-Alias -Name ... up2
function up3 { set-location "../../.." }
New-Alias -Name .... up3
function up4 { set-location "../../../.." }
New-Alias -Name ..... up4

New-Alias -Name l -Value Get-ChildItem -Force
New-Alias -Name ls -Value Get-ChildItem -Force