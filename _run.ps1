[cmdletbinding()]
param(
    [switch]$packageRestore = $false
)
    Set-StrictMode -Version latest

    # 
    .\_load.ps1

    # Always run the script with the current script location as the base path
    set-location (Split-Path $MyInvocation.MyCommand.Path)

