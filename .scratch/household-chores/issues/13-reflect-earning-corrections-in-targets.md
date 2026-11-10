# 13: Reflect earning corrections in targets

**What to build:** Target progress remains accurate when qualifying earnings are corrected.

**Blocked by:** 11: Correct approved earnings safely; 12: Set and track an earning target.

**Status:** ready-for-agent

- [ ] Corrections to approvals within the active target’s qualifying period update earned progress.
- [ ] Corrections to earnings outside that period do not alter the active target.
- [ ] Payment corrections do not change approval-based target progress.
- [ ] Edits, replacements and repeated correction requests preserve the agreed counting rules.
- [ ] Both adult and child views show the same corrected progress.
- [ ] Deliver persistence, server validation and permissions, mobile UI, and meaningful regression coverage for this behaviour.
- [ ] Confirm success only after saving; failed actions show useful errors and allow safe retries.

**GitHub issue:** https://github.com/funkimunky/house-jobs/issues/13
