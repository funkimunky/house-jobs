# 04: Claim and release available chores

**What to build:** Children reserve available work and release eligible claims for others.

**Blocked by:** 03: Publish weekday chores to the child board.

**Status:** ready-for-agent

- [ ] Concurrent claims for the same occurrence produce exactly one owner.
- [ ] Concurrent claims by one child cannot create multiple unfinished claims.
- [ ] A child with unfinished work is blocked from claiming more; ownership is enforced on the server.
- [ ] Releasing an unexpired claim makes it available again; other children cannot release it.
- [ ] When the next occurrence begins, unsubmitted work expires and releases the claim; stale requests cannot claim or revive expired work.
- [ ] Deliver persistence, server validation and permissions, mobile UI, and meaningful regression coverage for this behaviour.
- [ ] Confirm success only after saving; failed actions show useful errors and allow safe retries.

**GitHub issue:** https://github.com/funkimunky/house-jobs/issues/4
