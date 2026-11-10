[CmdletBinding()]
param(
    [ValidateRange(1, 100)]
    [int] $Iterations = 3,
    [ValidateSet('GitHub', 'Local')]
    [string] $Source = 'GitHub',
    [switch] $DryRun
)

& (Join-Path $PSScriptRoot 'run.ps1') -Iterations $Iterations -Source $Source -DryRun:$DryRun
