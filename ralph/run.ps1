#Requires -Version 7.0
[CmdletBinding()]
param(
    [ValidateRange(1, 100)]
    [int] $Iterations = 1,
    [ValidateSet('GitHub', 'Local')]
    [string] $Source = 'GitHub',
    [switch] $DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false
$repository = Split-Path $PSScriptRoot -Parent
$runLock = $null

function Invoke-Git {
    param([string[]] $Arguments)
    $output = & git @Arguments
    if ($LASTEXITCODE -ne 0) { throw "git $($Arguments -join ' ') failed." }
    return $output
}

function Get-EligibleIssues {
    if ($Source -eq 'GitHub') {
        $queue = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'queue.json') -Raw | ConvertFrom-Json
        $json = & gh issue list --repo $queue.repository --state all --limit 1000 --json number,title,body,labels,state,url
        if ($LASTEXITCODE -ne 0) { throw 'Could not read GitHub issues. Check gh authentication and network access.' }
        $githubIssues = @($json | ConvertFrom-Json)
        foreach ($task in $queue.tasks) {
            if ($task.mode -ne 'AFK') { continue }
            $matches = @($githubIssues | Where-Object { $_.number -eq $task.number })
            if ($matches.Count -ne 1) { throw "GitHub issue #$($task.number) is missing from the response." }
            $issue = $matches[0]
            if ($issue.state -ne 'OPEN') { continue }
            $labels = @($issue.labels | ForEach-Object { $_.name })
            if ($queue.readyLabel -notin $labels -or 'blocked' -in $labels -or 'HITL' -in $labels) { continue }
            $name = "github-$($issue.number).md"
            if (Test-Path -LiteralPath (Join-Path $repository "issues/done/$name")) { continue }
            $ready = $true
            foreach ($dependency in $task.dependencies) {
                $blockingIssues = @($githubIssues | Where-Object { $_.number -eq $dependency })
                if ($blockingIssues.Count -ne 1 -or $blockingIssues[0].state -ne 'CLOSED') { $ready = $false }
            }
            if ($ready) {
                [pscustomobject]@{
                    Name = $name
                    Content = "# $($issue.title)`n`nGitHub: $($issue.url)`n`n$($issue.body)"
                }
            }
        }
        return
    }
    $files = @(Get-ChildItem -LiteralPath (Join-Path $repository 'issues') -Filter '*.md' -File)
    foreach ($file in $files) {
        $content = Get-Content -LiteralPath $file.FullName -Raw
        if ($content -notmatch '(?m)^Mode: AFK\s*$') { continue }
        $dependencyLine = [regex]::Match($content, '(?m)^Dependencies: (.+)$')
        if (-not $dependencyLine.Success) {
            throw "$($file.Name) needs a Dependencies: none or comma-separated filenames line."
        }
        $dependencies = $dependencyLine.Groups[1].Value.Trim()
        $ready = $true
        if ($dependencies -ne 'none') {
            foreach ($dependency in $dependencies.Split(',')) {
                $name = $dependency.Trim()
                if ($name -notmatch '^[a-zA-Z0-9][a-zA-Z0-9._-]*\.md$') {
                    throw "Invalid dependency in $($file.Name): $name"
                }
                if (-not (Test-Path -LiteralPath (Join-Path $repository "issues/done/$name") -PathType Leaf)) {
                    $ready = $false
                }
            }
        }
        if ($ready) {
            [pscustomobject]@{ Name = $file.Name; FullName = $file.FullName; Content = $content }
        }
    }
}

Push-Location $repository
try {
    $root = Invoke-Git -Arguments @('rev-parse', '--show-toplevel')
    if ([IO.Path]::GetFullPath($root) -ne [IO.Path]::GetFullPath($repository)) {
        throw 'Run Ralph from its repository checkout.'
    }
    $eligible = @(Get-EligibleIssues)
    if ($DryRun) {
        Write-Host "Repository: $repository"
        Write-Host "Iterations: $Iterations; eligible AFK issues: $($eligible.Count)"
        Write-Host "Task source: $Source"
        Write-Host 'Verification: composer run ci:check'
        $eligible | ForEach-Object { Write-Host "  $($_.Name)" }
        Write-Host 'Dry run: no agent, checks, or commits were started.'
        return
    }

    $runsDirectory = Join-Path $PSScriptRoot 'runs'
    New-Item -ItemType Directory -Path $runsDirectory -Force | Out-Null
    try {
        $runLock = [IO.File]::Open((Join-Path $runsDirectory 'run.lock'), 'OpenOrCreate', 'ReadWrite', 'None')
    } catch { throw 'Another Ralph runner is active in this checkout.' }

    if (@(Invoke-Git -Arguments @('status', '--porcelain')).Count -gt 0) {
        throw 'Ralph requires a clean working tree. Commit or set aside your changes before running.'
    }
    if ($eligible.Count -eq 0) {
        Write-Host 'No eligible AFK issues. HITL and dependency-blocked issues are left for review.'
        return
    }
    $codexCommand = & (Join-Path $PSScriptRoot 'resolve-codex.ps1')
    foreach ($command in @('composer')) {
        Get-Command $command -ErrorAction Stop | Out-Null
    }

    for ($iteration = 1; $iteration -le $Iterations; $iteration++) {
        $eligible = @(Get-EligibleIssues)
        if ($eligible.Count -eq 0) { Write-Host 'All eligible AFK issues are complete.'; return }
        $runDirectory = Join-Path $runsDirectory ([guid]::NewGuid().ToString())
        New-Item -ItemType Directory -Path $runDirectory | Out-Null
        $headBefore = Invoke-Git -Arguments @('rev-parse', 'HEAD')
        $commits = Invoke-Git -Arguments @('log', '-5', '--format=%h %s%n%b')
        $issueContext = foreach ($issue in $eligible) {
            "## $($issue.Name)`n$($issue.Content)"
        }
        $prompt = "$(Get-Content -LiteralPath (Join-Path $PSScriptRoot 'prompt.md') -Raw)`n`n# Recent commits`n$($commits -join "`n")`n`n# Eligible issues`n$($issueContext -join "`n`n")"
        $prompt | Set-Content -LiteralPath (Join-Path $runDirectory 'input.md') -Encoding utf8
        $resultPath = Join-Path $runDirectory 'result.json'
        Write-Host "Iteration $iteration/$Iterations. Logs: $runDirectory"
        $prompt | & $codexCommand exec --sandbox workspace-write --cd $repository --json `
            --output-schema (Join-Path $PSScriptRoot 'result.schema.json') `
            --output-last-message $resultPath - `
            2> (Join-Path $runDirectory 'stderr.log') |
            Tee-Object -FilePath (Join-Path $runDirectory 'events.jsonl') | Out-Host
        if ($LASTEXITCODE -ne 0) { throw "Codex failed. Inspect $runDirectory; changes were preserved." }
        if (-not (Test-Path -LiteralPath $resultPath)) { throw 'Codex returned no result.' }
        $result = Get-Content -LiteralPath $resultPath -Raw | ConvertFrom-Json
        if ($result.status -ne 'DONE') {
            throw "Runner stopped: $($result.status). $($result.summary)"
        }
        $selected = @($eligible | Where-Object { $_.Name -ceq $result.issue })
        if ($selected.Count -ne 1) { throw 'Codex reported an issue outside the eligible queue.' }
        if ((Invoke-Git -Arguments @('rev-parse', 'HEAD')) -ne $headBefore) {
            throw 'Agent changed HEAD. Review its commits before continuing.'
        }
        if (@(Invoke-Git -Arguments @('diff', '--cached', '--name-only')).Count -gt 0) {
            throw 'Agent staged changes. Review the index before continuing.'
        }
        $changes = @(Invoke-Git -Arguments @('status', '--porcelain'))
        if ($changes.Count -eq 0) { throw 'Agent reported DONE without making changes.' }
        $protectedChanges = @(Invoke-Git -Arguments @('status', '--porcelain', '--', 'ralph', 'issues', 'composer.json', 'composer.lock', 'package.json', 'package-lock.json', 'phpunit.xml', 'phpstan.neon', 'vite.config.ts', '.gitignore'))
        if ($protectedChanges.Count -gt 0) {
            throw 'Agent changed workflow, issue, or verification files. Review manually before continuing.'
        }

        & composer run ci:check 2>&1 | Tee-Object -FilePath (Join-Path $runDirectory 'checks.log') | Out-Host
        if ($LASTEXITCODE -ne 0) { throw 'Verification failed. Changes and logs were preserved; no commit was made.' }

        $destination = Join-Path $repository "issues/done/$($result.issue)"
        if (Test-Path -LiteralPath $destination) { throw 'Completed issue already exists; review the queue.' }
        if ($Source -eq 'Local') {
            Move-Item -LiteralPath $selected[0].FullName -Destination $destination
        } else {
            $selected[0].Content | Set-Content -LiteralPath $destination -Encoding utf8
        }
        Invoke-Git -Arguments @('add', '--all') | Out-Null
        Invoke-Git -Arguments @('commit', '-m', "Complete $($result.issue)", '-m', [string]$result.summary) | Out-Host
        if (@(Invoke-Git -Arguments @('status', '--porcelain')).Count -gt 0) {
            throw 'Working tree changed during commit. Review before continuing.'
        }
    }
    Write-Host 'Iteration limit reached. Review changes before running another batch.'
} finally {
    if ($null -ne $runLock) { $runLock.Dispose() }
    Pop-Location
}
