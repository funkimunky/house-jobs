#Requires -Version 7.0
[CmdletBinding()]
param([string] $NpmDirectory = (Join-Path $env:APPDATA 'npm'))

$command = Get-Command codex -ErrorAction SilentlyContinue
if ($null -ne $command) { return $command }

# A terminal opened before installation may not have the user npm directory on PATH.
$userInstall = Join-Path $NpmDirectory 'codex.cmd'
if (Test-Path -LiteralPath $userInstall -PathType Leaf) {
    return Get-Command $userInstall -ErrorAction Stop
}

throw 'Codex CLI was not found. Install it with: npm install --global @openai/codex. Then run codex login and reopen your terminal.'
