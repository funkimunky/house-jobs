# 01: Create a household and access child profiles

**What to build:** An adult sets up the household and children can securely enter their own profiles.

**Blocked by:** None (can start immediately).

**Status:** ready-for-agent

- [ ] An authenticated adult can create the household and add children by name and PIN without child email addresses.
- [ ] Adults can reset child PINs; PIN access is protected against repeated guessing.
- [ ] Children can access the shared board and their own work, finances and target only; server checks deny adult controls and other children’s private information.
- [ ] Profile switching on shared devices protects adult sessions and makes the current profile clear.
- [ ] Deliver persistence, server validation and permissions, mobile UI, and meaningful regression coverage for this behaviour.
- [ ] Confirm success only after saving; failed actions show useful errors and allow safe retries.

**GitHub issue:** https://github.com/funkimunky/house-jobs/issues/1
