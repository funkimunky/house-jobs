# 09: Record partial and full payments

**What to build:** Adults record external payments and children see accurate balances and payment history.

**Blocked by:** 05: Submit, approve and earn a reward.

**Status:** ready-for-agent

- [ ] Adults record payment amount, date and method; the app does not transfer money.
- [ ] Positive partial or full payments cannot exceed the available-to-pay balance.
- [ ] Concurrent payment requests and safe retries cannot overpay or duplicate a payment.
- [ ] Adult and child views distinguish awaiting approval, available to pay and paid amounts.
- [ ] Children see only their own payment history; monetary arithmetic uses whole pence.
- [ ] Deliver persistence, server validation and permissions, mobile UI, and meaningful regression coverage for this behaviour.
- [ ] Confirm success only after saving; failed actions show useful errors and allow safe retries.

**GitHub issue:** https://github.com/funkimunky/house-jobs/issues/9
