#Requires -Version 7.0
# Integration checks use real temporary Git repos and fake agent/check commands.
[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false
$source = $PSScriptRoot
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ('house-jobs-ralph-' + [guid]::NewGuid())
New-Item -ItemType Directory -Path $testRoot | Out-Null
$global:ralphTestscenario = ''
$global:ralphTestagentCalls = 0
$global:ralphTestcheckCalls = 0
$global:ralphTestfixture = ''

function Assert {
    param([bool] $Condition, [string] $Message)
    if (-not $Condition) { throw $Message }
}

function Invoke-FixtureGit {
    param([string[]] $Arguments)
    $output = & git -C $global:ralphTestfixture @Arguments
    if ($LASTEXITCODE -ne 0) { throw "Fixture git failed: $Arguments" }
    return $output
}

function New-Fixture {
    param([string] $Name)
    $global:ralphTestfixture = Join-Path $testRoot $Name
    $global:ralphTestscenario = $Name
    $global:ralphTestagentCalls = 0
    $global:ralphTestcheckCalls = 0
    New-Item -ItemType Directory -Path "$global:ralphTestfixture/issues/done" -Force | Out-Null
    New-Item -ItemType Directory -Path "$global:ralphTestfixture/ralph" | Out-Null
    Get-ChildItem -LiteralPath $source -File | Copy-Item -Destination "$global:ralphTestfixture/ralph"
    '/ralph/runs/' | Set-Content "$global:ralphTestfixture/.gitignore"
    "# Task`nMode: AFK`nDependencies: none`n`nImplement the task." | Set-Content "$global:ralphTestfixture/issues/001-task.md"
    Invoke-FixtureGit @('init', '--quiet') | Out-Null
    Invoke-FixtureGit @('config', 'user.name', 'Ralph Tests') | Out-Null
    Invoke-FixtureGit @('config', 'user.email', 'ralph-tests@example.invalid') | Out-Null
    Invoke-FixtureGit @('config', 'commit.gpgsign', 'false') | Out-Null
    Invoke-FixtureGit @('config', 'core.hooksPath', "$global:ralphTestfixture/no-hooks") | Out-Null
    Invoke-FixtureGit @('add', '--all') | Out-Null
    Invoke-FixtureGit @('commit', '--quiet', '-m', 'Fixture') | Out-Null
}

function codex {
    $input | Out-Null
    $arguments = @($args)
    Assert ($arguments -contains 'features.prefer_mxc=true') 'MXC preference was omitted.'
    Assert ($arguments -contains 'shell_environment_policy.experimental_use_profile=false') 'Shell profile isolation was omitted.'
    if ($arguments -contains 'sandbox') {
        $global:LASTEXITCODE = if ($global:ralphTestscenario -eq 'sandbox-error') { 1 } else { 0 }
        'Fixture sandbox tools'
        return
    }
    $global:ralphTestagentCalls++
    Assert ($arguments -contains 'workspace-write') 'Agent sandbox was omitted.'
    $outputPath = $arguments[[array]::IndexOf($arguments, '--output-last-message') + 1]
    $issue = Get-ChildItem "$global:ralphTestfixture/issues" -Filter '*.md' -File | Sort-Object Name | Select-Object -First 1
    if ($global:ralphTestscenario -eq 'github') {
        $number = if ($global:ralphTestreviewed) { 2 } else { 1 }
        $issue = @{ Name = "github-$number.md" }
    }
    $status = 'DONE'
    if ($global:ralphTestscenario -eq 'success') { $status = 'READY_FOR_VERIFICATION' }
    if ($global:ralphTestscenario -eq 'blocked') { $status = 'BLOCKED' }
    if ($global:ralphTestscenario -notin @('blocked', 'no-progress')) {
        "Implemented $($issue.Name)" | Add-Content "$global:ralphTestfixture/app.txt"
    }
    if ($global:ralphTestscenario -eq 'protected') { 'Changed' | Add-Content "$global:ralphTestfixture/ralph/prompt.md" }
    if ($global:ralphTestscenario -eq 'invalid-issue') { $issue = @{ Name = '../outside.md' } }
    @{ status = $status; issue = $issue.Name; summary = 'Fixture result' } |
        ConvertTo-Json | Set-Content -LiteralPath $outputPath
    $global:LASTEXITCODE = 0
    if ($global:ralphTestscenario -eq 'cli-error') { $global:LASTEXITCODE = 1 }
    '{"type":"test"}'
}

function composer {
    $global:ralphTestcheckCalls++
    Assert ((@($args) -join ' ') -eq 'run ci:check') 'Wrong verification command.'
    $global:LASTEXITCODE = 0
    if ($global:ralphTestscenario -eq 'failed-check') { $global:LASTEXITCODE = 1 }
    'Fixture checks'
}

function gh {
    $state = if ($global:ralphTestreviewed) { 'CLOSED' } else { 'OPEN' }
    @(
        @{ number = 1; title = 'First'; body = 'First task'; state = $state; url = 'https://example.invalid/1'; labels = @(@{ name = 'ready-for-agent' }) },
        @{ number = 2; title = 'Second'; body = 'Second task'; state = 'OPEN'; url = 'https://example.invalid/2'; labels = @(@{ name = 'ready-for-agent' }) }
    ) | ConvertTo-Json -Depth 5
    $global:LASTEXITCODE = 0
}

function Run-Fixture {
    param([switch] $ShouldFail, [int] $Iterations = 1, [string] $Source = 'Local')
    $failure = $null
    try { & "$global:ralphTestfixture/ralph/afk.ps1" -Iterations $Iterations -Source $Source }
    catch { $failure = $_ }
    Assert (($null -ne $failure) -eq [bool]$ShouldFail) "Unexpected result for $global:ralphTestscenario`: $failure"
}

New-Fixture 'success'
Run-Fixture
Assert (Test-Path "$global:ralphTestfixture/issues/done/001-task.md") 'Issue was not archived.'
Assert ((Invoke-FixtureGit @('rev-list', '--count', 'HEAD')) -eq '2') 'Expected one task commit.'
Assert (@(Invoke-FixtureGit @('status', '--porcelain')).Count -eq 0) 'Successful run left changes.'
Assert ($global:ralphTestcheckCalls -eq 1) 'Verification was skipped.'

foreach ($name in @('blocked', 'no-progress', 'failed-check', 'invalid-issue', 'protected', 'cli-error', 'sandbox-error')) {
    New-Fixture $name
    Run-Fixture -ShouldFail
    Assert ((Invoke-FixtureGit @('rev-list', '--count', 'HEAD')) -eq '1') "$name created a commit."
    Assert (Test-Path "$global:ralphTestfixture/issues/001-task.md") "$name archived the issue."
    if ($name -eq 'sandbox-error') { Assert ($global:ralphTestagentCalls -eq 0) 'Failed sandbox check started an agent.' }
}

New-Fixture 'dirty'
'Unrelated work' | Set-Content "$global:ralphTestfixture/unrelated.txt"
Run-Fixture -ShouldFail
Assert ($global:ralphTestagentCalls -eq 0) 'Dirty tree started an agent.'

New-Fixture 'eligibility'
"# Human task`nMode: HITL`nDependencies: none" | Set-Content "$global:ralphTestfixture/issues/001-task.md"
"# Dependent task`nMode: AFK`nDependencies: missing.md" | Set-Content "$global:ralphTestfixture/issues/002-task.md"
Invoke-FixtureGit @('add', '--all') | Out-Null
Invoke-FixtureGit @('commit', '--quiet', '-m', 'Queue') | Out-Null
Run-Fixture
Assert ($global:ralphTestagentCalls -eq 0) 'Ineligible tasks started an agent.'

New-Fixture 'bounded'
"# Second task`nMode: AFK`nDependencies: 001-task.md" | Set-Content "$global:ralphTestfixture/issues/002-task.md"
Invoke-FixtureGit @('add', '--all') | Out-Null
Invoke-FixtureGit @('commit', '--quiet', '-m', 'Queue') | Out-Null
Run-Fixture -Iterations 1
Assert ($global:ralphTestagentCalls -eq 1) 'Iteration limit was ignored.'
Assert (Test-Path "$global:ralphTestfixture/issues/002-task.md") 'Second task ran too early.'
Run-Fixture -Iterations 3
Assert ($global:ralphTestagentCalls -eq 2) 'Dependency did not unlock, or empty queue did not stop.'

New-Fixture 'dry-run'
'Unrelated work' | Set-Content "$global:ralphTestfixture/unrelated.txt"
& "$global:ralphTestfixture/ralph/once.ps1" -DryRun -Source Local
Assert ($global:ralphTestagentCalls -eq 0) 'Dry run started an agent.'
Assert (-not (Test-Path "$global:ralphTestfixture/ralph/runs")) 'Dry run wrote logs.'

New-Fixture 'github'
$global:ralphTestreviewed = $false
@{
    repository = 'example/test'; readyLabel = 'ready-for-agent'
    tasks = @(@{ number = 1; mode = 'AFK'; dependencies = @() }, @{ number = 2; mode = 'AFK'; dependencies = @(1) })
} | ConvertTo-Json -Depth 5 | Set-Content "$global:ralphTestfixture/ralph/queue.json"
Invoke-FixtureGit @('add', '--all') | Out-Null
Invoke-FixtureGit @('commit', '--quiet', '-m', 'GitHub queue') | Out-Null
Run-Fixture -Source GitHub -Iterations 3
Assert ($global:ralphTestagentCalls -eq 1) 'GitHub dependency ran before review.'
Assert (Test-Path "$global:ralphTestfixture/issues/done/github-1.md") 'GitHub task snapshot missing.'
$global:ralphTestreviewed = $true
Run-Fixture -Source GitHub -Iterations 3
Assert ($global:ralphTestagentCalls -eq 2) 'Closed GitHub dependency did not unlock task.'
Assert (Test-Path "$global:ralphTestfixture/issues/done/github-2.md") 'Second GitHub task snapshot missing.'

Remove-Item Function:codex
$originalPath = $env:PATH
try {
    $env:PATH = Join-Path $env:SystemRoot 'System32'
    $fakeNpm = Join-Path $testRoot 'npm'
    New-Item -ItemType Directory -Path $fakeNpm | Out-Null
    '@echo fake codex' | Set-Content (Join-Path $fakeNpm 'codex.cmd')
    $resolved = & (Join-Path $source 'resolve-codex.ps1') -NpmDirectory $fakeNpm
    Assert ($resolved.Source -eq (Join-Path $fakeNpm 'codex.cmd')) 'User npm CLI fallback was not found without PATH.'
    $missingMessage = ''
    try { & (Join-Path $source 'resolve-codex.ps1') -NpmDirectory (Join-Path $testRoot 'missing') }
    catch { $missingMessage = $_.Exception.Message }
    Assert ($missingMessage -like '*npm install --global @openai/codex*') 'Missing CLI error did not explain installation.'
} finally {
    $env:PATH = $originalPath
}

Write-Host "All Ralph integration checks passed. Fixtures: $testRoot"
