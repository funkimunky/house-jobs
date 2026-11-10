# 06: Return work for corrections or reject it

**What to build:** Adults request corrections or reject submissions, and children resolve returned work.

**Blocked by:** 05: Submit, approve and earn a reward.

**Status:** ready-for-agent

- [ ] Before implementation, confirm the PRD proposal: when another claim exists, preserve both items and block new claims until no unfinished work remains; record the agreed decision.
- [ ] Returning a submission before expiry requires an explanation visible to the child.
- [ ] Returned work remains owned by the child and blocks further claims; the child can resubmit or release it, or it can expire.
- [ ] Adults can reject submissions without awarding money; rejected work stays in history.
- [ ] After occurrence expiry, pending submissions can be approved or rejected but cannot be returned.
- [ ] Concurrent review, resubmission and expiry preserve valid states and do not duplicate rewards.
- [ ] Deliver persistence, server validation and permissions, mobile UI, and meaningful regression coverage for this behaviour.
- [ ] Confirm success only after saving; failed actions show useful errors and allow safe retries.

**GitHub issue:** https://github.com/funkimunky/house-jobs/issues/6
