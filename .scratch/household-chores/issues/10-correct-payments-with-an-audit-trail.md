# 10: Correct payments with an audit trail

**What to build:** Adults correct recorded payments while preserving a visible audit history.

**Blocked by:** 09: Record partial and full payments.

**Status:** ready-for-agent

- [ ] An adult corrects a payment with a required reason.
- [ ] Original records, correction details, actor and time remain visible in history.
- [ ] Corrections update paid and available-to-pay totals without invalid or negative balances.
- [ ] Concurrent requests and retries cannot apply a correction twice or bypass balance rules.
- [ ] Children cannot correct payments or access another child’s records.
- [ ] Deliver persistence, server validation and permissions, mobile UI, and meaningful regression coverage for this behaviour.
- [ ] Confirm success only after saving; failed actions show useful errors and allow safe retries.

**GitHub issue:** https://github.com/funkimunky/house-jobs/issues/10
