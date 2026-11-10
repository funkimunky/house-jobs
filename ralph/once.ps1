[CmdletBinding()]
param(
    [ValidateSet('GitHub', 'Local')]
    [string] $Source = 'GitHub',
    [switch] $DryRun,
    [switch] $CheckEnvironment
)

& (Join-Path $PSScriptRoot 'run.ps1') -Iterations 1 -Source $Source -DryRun:$DryRun -CheckEnvironment:$CheckEnvironment
