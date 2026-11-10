# House Jobs task runner

Requires PowerShell 7+, Git, authenticated Codex CLI, and the project's installed
PHP/Composer/Node dependencies. GitHub mode also requires authenticated `gh`.
Run in the existing development checkout; this
uses Codex's workspace sandbox, not Docker. Install dependencies and establish a
passing `composer run ci:check` baseline before unattended use.

The desktop app's bundled CLI may only be on PATH inside Codex chats. For a normal
terminal, install the standalone CLI with `npm install --global @openai/codex`,
then run `codex login`. The runner also checks `%APPDATA%\npm\codex.cmd` if PATH
does not contain Codex, so an already-open terminal can use that user installation.

## Existing GitHub Kanban (default)

GitHub Issues in `funkimunky/house-jobs` are the ongoing source of task bodies,
readiness labels, and open/closed state. `queue.json` records the dependency map
from `.scratch/household-chores/kanban.md`, because the published issue bodies do
not consistently contain it. Update this map when planning changes dependencies
or adds tasks. Unknown issues are excluded until added to the map.

Issues require `ready-for-agent`, AFK mode in the map, and closed dependencies.
Labels `blocked` or `HITL` exclude an issue. Tickets 6, 8, and 14 are HITL because
they require product decisions or the household trial. Only issue 1 is initially
eligible. The local scratch Kanban remains the original plan snapshot.

After verification the runner commits the implementation and a task snapshot in
`issues/done/github-<number>.md`. This means implemented and awaiting review; the
GitHub issue remains open. Review the implementation, then close the GitHub issue
as completed to unlock its dependants. The runner makes no GitHub writes. Existing
snapshots prevent duplicate implementation; to deliberately rework a reopened
issue, review and remove its snapshot in a separate commit first.

## Optional local issue files

Pass `-Source Local` to use approved files directly in `issues/` instead:

```markdown
# 001-example
Mode: AFK
Dependencies: none

## Goal
A small end-to-end change with decisions already resolved.

## Acceptance criteria
- Describe observable behavior and required regression coverage.

## Verification
- Name any focused checks needed in addition to the full CI check.
```

Use `Mode: HITL` for tasks needing human decisions. Dependencies are comma-separated
issue filenames, such as `001-example.md, 002-other.md`; each must exist in
`issues/done/` before the task is eligible. Filenames must be unique across open
and completed issues. Templates belong outside `issues/` so they cannot be run.
The runner does not automatically convert `prd.md` into approved tasks.

From the repository root:

```powershell
pwsh -NoProfile -File .\ralph\once.ps1 -DryRun
pwsh -NoProfile -File .\ralph\once.ps1
pwsh -NoProfile -File .\ralph\afk.ps1 -Iterations 3
```

Commit the runner and any local task files before a real run. Both runners require a
clean tree and exclusive access to the checkout. Avoid editing or running another
agent there during a batch. Dry runs only show configuration and eligible tasks;
they accept a dirty tree and do not invoke Codex, checks, or commits. GitHub dry
runs still read GitHub, so they need network access and `gh` authentication.

Each iteration uses a fresh Codex session. The agent implements one task and
returns structured JSON. The runner rejects unexpected results or no progress,
runs `composer run ci:check`, archives the task in `issues/done/`, and commits the
changes. It never pushes, merges, or deploys. Tasks that change runner files,
dependencies, or verification configuration need human implementation instead.

Inputs, JSON events, final results, stderr, and check output are saved under ignored
`ralph/runs/<run-id>/`. Blockers, CLI errors, invalid results, unexpected commits,
and failed checks stop the batch with changes preserved for review. Correct the
problem and commit or set aside remaining changes before restarting. Ctrl+C stops
the foreground run; review any partial work before restarting. Iterations bound
the number of agent sessions, not their duration or cost.

Review the commits and test the app yourself after each batch. The runner checks
Git state and test results; it does not prove every acceptance criterion or enforce
every prompt restriction independently. Sandbox or network restrictions may block
tools; resolve the environment rather than bypassing the sandbox.

Run runner integration checks with `pwsh -NoProfile -File .\ralph\test.ps1`.
They use temporary Git repositories and fake Codex, Composer, and GitHub commands;
they do not spend model credits or run application tests.
