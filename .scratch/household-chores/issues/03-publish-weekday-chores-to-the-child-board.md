# 03: Publish weekday chores to the child board

**What to build:** Adults publish recurring paid chores that children can browse on the correct day.

**Blocked by:** 01: Create a household and access child profiles.

**Status:** ready-for-agent

- [ ] Adults create a title, completion instructions, fixed GBP reward and selected weekdays; monetary values are stored in whole pence.
- [ ] Children see available occurrences with instructions and their agreed reward; all children are eligible.
- [ ] Occurrences become available at Europe/London midnight, including daylight-saving transitions.
- [ ] Missed scheduler runs and restarts recover current work without duplicate occurrences or an available backlog; superseded unsubmitted occurrences expire.
- [ ] Each occurrence preserves its own terms and completion status.
- [ ] Deliver persistence, server validation and permissions, mobile UI, and meaningful regression coverage for this behaviour.
- [ ] Confirm success only after saving; failed actions show useful errors and allow safe retries.

**GitHub issue:** https://github.com/funkimunky/house-jobs/issues/3
