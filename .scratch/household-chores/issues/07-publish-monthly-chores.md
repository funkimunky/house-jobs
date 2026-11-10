# 07: Publish monthly chores

**What to build:** Adults schedule monthly paid chores and children see them on the correct date.

**Blocked by:** 03: Publish weekday chores to the child board.

**Status:** ready-for-agent

- [ ] Adults can choose a specific date each month and children see the resulting occurrences.
- [ ] Dates missing from a month fall on that month’s final day, including leap-year February.
- [ ] Europe/London midnight and daylight-saving rules apply.
- [ ] Missed runs and retries do not duplicate occurrences or accumulate an available backlog.
- [ ] Each occurrence expires at its next scheduled occurrence; any existing claims and pending submissions follow the established lifecycle.
- [ ] Deliver persistence, server validation and permissions, mobile UI, and meaningful regression coverage for this behaviour.
- [ ] Confirm success only after saving; failed actions show useful errors and allow safe retries.

**GitHub issue:** https://github.com/funkimunky/house-jobs/issues/7
