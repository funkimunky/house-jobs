[CmdletBinding()]
param(
    [ValidateSet('GitHub', 'Local')]
    [string] $Source = 'GitHub',
    [switch] $DryRun
)

& (Join-Path $PSScriptRoot 'run.ps1') -Iterations 1 -Source $Source -DryRun:$DryRun
