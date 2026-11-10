# 05: Submit, approve and earn a reward

**What to build:** Children submit completed work and adults approve it to credit earnings.

**Blocked by:** 04: Claim and release available chores.

**Status:** ready-for-agent

- [ ] The owner submits an unexpired claim; submission frees the child to claim another occurrence.
- [ ] Adults see pending submission details and can approve; children cannot verify work.
- [ ] Approval credits the occurrence’s agreed reward exactly once, including concurrent requests and retries.
- [ ] Children see pending rewards and approved earnings separately; adults can inspect each child’s earnings.
- [ ] A submission made before expiry remains reviewable afterwards; the next occurrence is independently available.
- [ ] Invalid lifecycle transitions and late submissions fail without altering balances.
- [ ] Deliver persistence, server validation and permissions, mobile UI, and meaningful regression coverage for this behaviour.
- [ ] Confirm success only after saving; failed actions show useful errors and allow safe retries.

**GitHub issue:** https://github.com/funkimunky/house-jobs/issues/5
