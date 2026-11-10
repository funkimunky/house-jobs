# Household Chores and Pocket Money

Product requirements document — first version  
Date: 8 November 2026

## Purpose and success

Help children earn pocket money by completing recurring household chores. Adults define rewards, verify work and record payments. Children choose available chores and track earnings towards a personal savings target.

The first version serves one household. Success means four weeks of household use in which children claim and submit chores independently and adults manage approvals and payments without a separate spreadsheet.

## Users and permissions

- The first adult creates the household, adds children by name and PIN, and can invite another adult with equal management permissions.
- Adults manage chores, profiles, verification, targets and payments.
- Children access individual profiles using PINs without needing email addresses.
- Children see the shared chore board and only their own work, earnings, payments and target.
- Adults can see all household activity. Child access must not grant adult permissions.

## Platform

A mobile-friendly website with touch-friendly controls. An internet connection is required. Older iPad and Safari 9 compatibility are excluded.

Confirm actions only after successful saving. Show clear errors for failed actions and allow safe retries without duplicate records.

## Chore creation and management

Adults create recurring chores with a title, instructions explaining what counts as done, a fixed reward in pounds sterling, and a schedule.

Schedules support selected weekdays or a specific date each month. Every chore in the app earns its stated reward on approval. Unpaid responsibilities are outside the app.

All children can claim every available chore. There are no individual assignments, age restrictions or child-specific reward rates.

Adults can edit, pause or archive chores. Instruction, reward and schedule changes apply to future occurrences. Existing occurrences retain their agreed terms. Pausing or archiving stops future occurrences while preserving existing claims, submissions and history.

## Scheduling and expiry

Each occurrence has its own reward and completion status.

- Occurrences become available at midnight in Europe/London time, accounting for daylight-saving changes.
- A monthly date missing from a month falls on that month's final day.
- Unsubmitted work expires when the next occurrence starts, releasing the claim.
- Expired occurrences do not accumulate as available work.
- Submissions made before expiry remain eligible for verification afterwards.
- The next occurrence is independently available even if the previous submission awaits verification.

## Claiming and verification

1. A child browses available chores, rewards and instructions.
2. The child claims an occurrence.
3. The child completes it and submits it for adult verification.
4. An adult approves, returns or rejects it.
5. Approval credits the agreed reward exactly once.

Only one child can claim an occurrence, including simultaneous claim attempts.

A child may hold only one unfinished claim at a time and can release it. Releasing an unexpired claim makes it available again. Submission frees the child to claim another chore.

Returning work requires an explanation. Returned work stays with the child and blocks further claims until resubmitted, released or expired.

After an occurrence expires, an adult can approve or reject its pending submission but cannot return it for more work. Rejected work earns nothing and remains in history.

### Lifecycle

| State | Meaning | Next actions |
| --- | --- | --- |
| Available | Open to any child | Claim or expire |
| Claimed | Reserved by one child | Submit, release or expire |
| Awaiting approval | Submitted before expiry | Approve, reject, or return before expiry |
| Returned | Adult requests corrections | Resubmit, release or expire |
| Approved | Reward credited | Audited correction |
| Rejected | No reward awarded | Retain history |
| Expired | Unsubmitted work reached its next occurrence | Retain history |

### Edge case requiring implementation confirmation

A child may have claimed another chore before an earlier submission is returned. Proposed handling: preserve both items and block further claims until no unfinished work remains. This exception to the one-claim limit was not explicitly decided in the interview and must be confirmed before implementation.

## Earnings and payments

Show each child's amounts separately:

| Amount | Meaning |
| --- | --- |
| Awaiting approval | Potential rewards for pending submissions |
| Available to pay | Approved earnings less payments and applicable corrections |
| Paid | Recorded payments after corrections |

Adults pay outside the app and record the amount, date and payment method. Partial payments are supported, up to the available-to-pay balance. The app does not transfer money.

Adults can correct approvals or payments. A reason is required, and visible history retains original records, corrections, actor and time.

Earnings already recorded as paid cannot be reversed until the relevant payment record is corrected. Corrections must not produce negative available-to-pay balances. Store money in whole pence.

## Savings targets

Each child can set one active target with a name and amount. Adults can help edit it.

Label progress “earned towards target.”

- Count earnings approved since the target began, including earnings subsequently paid out.
- Editing an existing target preserves progress.
- Replacing a target starts a new goal at zero and counts only approvals after its start.
- Corrections to qualifying earnings update progress.
- Reaching the target does not prevent further earnings.

The target measures earning progress, not actual savings or spending.

## Main screens

| Screen | Content |
| --- | --- |
| Child chore board | Available chores, rewards and instructions |
| Child work | Claims, returned work and pending submissions |
| Child earnings | Balances and payment history |
| Child target | Target details and earned progress |
| Adult chores | Create, edit, pause and archive |
| Adult verification | Submission details and verification actions |
| Adult payments | Child balances, payments and corrections |
| Household settings | Child profiles, PIN management and adult invitations |

Reminders and updates appear inside the app. Email and push reminders are excluded. Adult invitations remain part of account setup.

## Reliability and privacy

- Enforce permissions, claim ownership and financial rules on the server.
- Prevent duplicate claims, credits and payments from retries or concurrent requests.
- Preserve pending submissions through expiry.
- Generate recurring occurrences reliably across missed scheduler runs and restarts.
- Keep financial and completion history when chores stop.
- Provide clear profile switching and protect adult access on shared devices.
- Show success only after saving; show useful errors when the connection fails.

## Acceptance criteria

1. An adult can create a household, add children with PINs and invite another adult.
2. Children cannot access adult controls or another child's finances.
3. Weekday and monthly schedules generate the correct occurrences, including short months and UK clock changes.
4. Simultaneous claims produce exactly one owner per occurrence.
5. Unfinished work blocks further claims; eligible claims can be released.
6. Submission frees the child to claim again and remains reviewable after expiry.
7. Approval credits the agreed reward once; returns require an explanation; rejection awards nothing.
8. Expired submissions can be approved or rejected but not returned for further work.
9. Unsubmitted work expires when the next occurrence begins and no backlog accumulates.
10. Chore changes affect future occurrences while preserving existing terms and history.
11. Partial and full payments cannot exceed unpaid approved earnings.
12. Corrections require reasons, retain history and preserve valid balances.
13. Target progress follows the approval, payout, correction, editing and replacement rules.
14. Network failures are visible and retries do not duplicate saved actions.
15. Core adult and child workflows are usable on mobile screens with touch controls.
16. The four-week household trial meets the success criteria.

## Out of scope

One-off jobs; unpaid chores; individual assignments; age eligibility; variable rewards by child; automatic transfers; spending or actual savings tracking; multiple active targets; points, streaks and leaderboards; email or push reminders; offline operation; legacy iPad and Safari 9 support.

## Technical design follow-up

Use the existing repository's stack and conventions. Select hosting and define adult authentication, PIN recovery, invitation handling and shared-device sessions during technical design. Resolve the returned-work conflict above before implementing that workflow.

