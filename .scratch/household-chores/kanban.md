# Household chores Kanban

Source: the household chores and pocket money PRD (8 November 2026).

Columns: Backlog → Ready → In progress → Review → Done.

Move a ticket to Ready only when its blocking tickets are Done. Keep work in progress small. Review requires the ticket's acceptance criteria and relevant checks to pass. The triage status ready-for-agent indicates ticket readiness for agent handling, not completed dependencies.

## Ready

- [01: Create a household and access child profiles](issues/01-create-a-household-and-access-child-profiles.md)

## Backlog

- [02: Invite another adult](issues/02-invite-another-adult.md) — blocked by 01.
- [03: Publish weekday chores to the child board](issues/03-publish-weekday-chores-to-the-child-board.md) — blocked by 01.
- [04: Claim and release available chores](issues/04-claim-and-release-available-chores.md) — blocked by 03.
- [05: Submit, approve and earn a reward](issues/05-submit-approve-and-earn-a-reward.md) — blocked by 04.
- [06: Return work for corrections or reject it](issues/06-return-work-for-corrections-or-reject-it.md) — blocked by 05; returned-work decision required.
- [07: Publish monthly chores](issues/07-publish-monthly-chores.md) — blocked by 03.
- [08: Edit, pause and archive recurring chores](issues/08-edit-pause-and-archive-recurring-chores.md) — blocked by 03.
- [09: Record partial and full payments](issues/09-record-partial-and-full-payments.md) — blocked by 05.
- [10: Correct payments with an audit trail](issues/10-correct-payments-with-an-audit-trail.md) — blocked by 09.
- [11: Correct approved earnings safely](issues/11-correct-approved-earnings-safely.md) — blocked by 10.
- [12: Set and track an earning target](issues/12-set-and-track-an-earning-target.md) — blocked by 05.
- [13: Reflect earning corrections in targets](issues/13-reflect-earning-corrections-in-targets.md) — blocked by 11, 12.
- [14: Run the four-week household trial](issues/14-run-the-four-week-household-trial.md) — blocked by 02, 06, 07, 08, 13.

## In progress

None.

## Review

None.

## Done

None.

## Decisions still required

- Ticket 06: confirm how returned work interacts with another existing claim. The PRD proposal is to preserve both and block new claims until all unfinished work is resolved. This is not yet an approved product decision.
- Ticket 08: settle expiry boundaries for existing work when a schedule changes or a chore stops.
- Ticket 14: choose hosting before deployment.

Published to GitHub Issues. Use GitHub to track ongoing work; these local tickets retain the plan snapshot and issue links.


## GitHub issues

- [01: Create a household and access child profiles](https://github.com/funkimunky/house-jobs/issues/1)
- [02: Invite another adult](https://github.com/funkimunky/house-jobs/issues/2)
- [03: Publish weekday chores to the child board](https://github.com/funkimunky/house-jobs/issues/3)
- [04: Claim and release available chores](https://github.com/funkimunky/house-jobs/issues/4)
- [05: Submit, approve and earn a reward](https://github.com/funkimunky/house-jobs/issues/5)
- [06: Return work for corrections or reject it](https://github.com/funkimunky/house-jobs/issues/6)
- [07: Publish monthly chores](https://github.com/funkimunky/house-jobs/issues/7)
- [08: Edit, pause and archive recurring chores](https://github.com/funkimunky/house-jobs/issues/8)
- [09: Record partial and full payments](https://github.com/funkimunky/house-jobs/issues/9)
- [10: Correct payments with an audit trail](https://github.com/funkimunky/house-jobs/issues/10)
- [11: Correct approved earnings safely](https://github.com/funkimunky/house-jobs/issues/11)
- [12: Set and track an earning target](https://github.com/funkimunky/house-jobs/issues/12)
- [13: Reflect earning corrections in targets](https://github.com/funkimunky/house-jobs/issues/13)
- [14: Run the four-week household trial](https://github.com/funkimunky/house-jobs/issues/14)
