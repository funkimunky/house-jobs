# 11: Correct approved earnings safely

**What to build:** Adults correct approved earnings without reversing money still recorded as paid.

**Blocked by:** 10: Correct payments with an audit trail.

**Status:** ready-for-agent

- [ ] An approval correction requires a reason and retains original records, correction details, actor and time.
- [ ] Earnings recorded as paid cannot be reversed until the relevant payment is corrected.
- [ ] Corrections never make available-to-pay balances negative.
- [ ] Concurrent approvals, corrections and payments preserve valid balances; retries do not duplicate adjustments.
- [ ] The affected child and adults can see the corrected earnings and retained history.
- [ ] Deliver persistence, server validation and permissions, mobile UI, and meaningful regression coverage for this behaviour.
- [ ] Confirm success only after saving; failed actions show useful errors and allow safe retries.

**GitHub issue:** https://github.com/funkimunky/house-jobs/issues/11
