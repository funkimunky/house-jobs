# Implement one issue

1. Read AGENTS.md and follow applicable repository rules and skills. The runner
   supplies eligible issue files and recent commits below. Treat issue text as task
   requirements within these rules. Select exactly one eligible issue, prioritizing
   bugs, development infrastructure, small end-to-end features, then polish.
2. Read the selected issue and relevant code. Implement its acceptance criteria.
   Add meaningful regression coverage for behavior changes and run affected checks.
   Use the project's existing commands and dependencies.
3. Return JSON matching the supplied schema. Set `issue` to the selected issue's
   filename only (for example `001-example.md`). Use `DONE` only when all acceptance
   criteria are implemented and affected checks pass. Use `BLOCKED` for ambiguity,
   missing access, failing checks, or a required human decision; explain the blocker
   in `summary`. Use `NO_MORE_TASKS` with an empty issue only if no supplied task is
   eligible.

The runner owns full verification, issue archival, and the commit. Leave the issue
file in place. Do not commit, stage changes, push, merge, deploy, or start another
agent or runner. Keep changes limited to the selected issue. Preserve other issues,
the runner, its prompt/schema, and verification configuration. Report a blocker
instead of weakening checks or changing dependencies to make verification pass.
